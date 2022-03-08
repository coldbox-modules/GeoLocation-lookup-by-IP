/**
 * I determine a user's location by their IP address
 */
component singleton {

	// DI
	property name="cachebox" inject="cachebox";
	property name="log"      inject="logbox:logger:{this}";
	property name="settings" inject="coldbox:moduleSettings:geolocation-lookup-by-ip";

	/**
	 * Constructor
	 */
	function init(){
		variables.GEO_SERVICE_URL     = "http://api.ipinfodb.com/v3/ip-city/";
		variables.GEO_SERVICE_TIMEOUT = 5;
		return this;
	}

	/**
	 * Get the associated cache provider for this module
	 */
	function getGeoCache(){
		return variables.cachebox.getCache( variables.settings.cacheName );
	}

	/**
	 * Clear the lookup cache
	 */
	GeoLocation function clearCache(){
		// Look for cache keys that start with the key prefix
		var regex         = "^" & variables.settings.cacheKeyPrefix & ".*";
		var cacheProvider = getGeoCache();

		cacheProvider
			.getKeys()
			.filter( function( thisKey ){
				return reFindNoCase( regex, thisKey );
			} )
			.each( function( thisKey ){
				cacheProvider.clear( thisKey );
			} );

		return this;
	}

	/**
	 * Get the location details of an IP Address
	 *
	 * @IPAddress The ip address to lookup, if not passed in, we will auto-determine it
	 * @cache     If true, we will cache the ip vs result
	 *
	 * @return struct of location details
	 */
	function getLocation( IPAddress = getRealIp(), cache = "#variables.settings.cache#" ){
		// Not caching
		if ( !arguments.cache ) {
			return getDetails( arguments.IPAddress, variables.settings.developerKey );
		}

		var cacheKey      = variables.settings.cacheKeyPrefix & arguments.IPAddress;
		var cacheProvider = getGeoCache();
		var results       = cacheProvider.get( cacheKey );

		if ( isNull( results ) ) {
			results = getDetails( arguments.IPAddress, variables.settings.developerKey );
			cacheProvider.set(
				cacheKey,
				results,
				variables.settings.cacheTimeout,
				0
			);
		} else {
			results.cached = true;
		}
		return results;
	}

	/**
	 * Get ip location details from our service
	 *
	 * @IPAddress    The ip address to lookup, if not passed in, we will auto-determine it
	 * @developerKey A custom key to use or the one seeded into the module configuration
	 *
	 * @throws InvalidNonJsonResponse      - When the response is not JSON
	 * @throws GeoLocationServiceException - When the service returns a non `OK` response
	 */
	private struct function getDetails( required string IPAddress, required string developerKey ){
		// one way or another, I will return this struct.
		// it may or may not be populated with useful data.
		var response = {
			"statusCode"    : "ERROR",
			"statusMessage" : "Check logs",
			"ipAddress"     : "",
			"countryCode"   : "",
			"countryName"   : "",
			"regionName"    : "",
			"cityName"      : "",
			"zipCode"       : "",
			"latitude"      : "0",
			"longitude"     : "0",
			"timeZone"      : "",
			"cached"        : false
		};

		try {
			cfhttp(
				url          = "#variables.GEO_SERVICE_URL#",
				method       = "GET",
				timeout      = "#variables.GEO_SERVICE_TIMEOUT#",
				throwOnError = true,
				charset      = "utf-8",
				result       = "httpResult"
			) {
				cfhttpParam(
					name  = "key",
					value = arguments.developerKey,
					type  = "url"
				);
				cfhttpParam(
					name  = "ip",
					value = arguments.IPAddress,
					type  = "url"
				);
				cfhttpParam( name = "format", value = "json", type = "url" );
			}

			if ( !isJSON( httpResult.fileContent ) ) {
				throw(
					type    = "InvalidNonJsonResponse",
					message = "Non-JSON response from IPInfoDB API",
					detail  = httpResult.fileContent
				);
			}


			structAppend(
				response,
				deserializeJSON( httpResult.fileContent ),
				true
			);

			if ( response.statusCode != "OK" ) {
				throw(
					type    = "GeoLocationServiceException",
					message = "Non-'OK' response from IPInfoDB API",
					detail  = httpResult.fileContent
				);
			}

			// The API sends back '-' for values it doesn't know, but I'd
			// rather just have an empty string so it's easier to check and see
			// if you have data.
			response = response.map( function( key, value ){
				return ( arguments.value == "-" ) ? "" : arguments.value;
			} );
		} catch ( any e ) {
			variables.log.error( e.message, e.detail );
			response.statusMessage = e.message & e.detail;
			response.stackTrace    = e.stacktrace;
		}

		// We should always make it here and fail silently if anything goes boom above.
		return response;
	}

	/**
	 * Get Real IP, by looking at clustered, proxy headers and locally.
	 */
	string function getRealIP(){
		var headers = getHTTPRequestData( false ).headers;

		// When going through a proxy, the IP can be a delimtied list, thus we take the last one in the list

		if ( structKeyExists( headers, "x-cluster-client-ip" ) ) {
			return trim( listLast( headers[ "x-cluster-client-ip" ] ) );
		}
		if ( structKeyExists( headers, "X-Forwarded-For" ) ) {
			return trim( listFirst( headers[ "X-Forwarded-For" ] ) );
		}

		return len( cgi.remote_addr ) ? trim( listFirst( cgi.remote_addr ) ) : "127.0.0.1";
	}

}
