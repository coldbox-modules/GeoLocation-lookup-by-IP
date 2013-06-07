<cfcomponent name="GeoLocation" hint="I determine a user's location by their IP address" extends="coldbox.system.Plugin" output="false" cache="true">
	
    <cffunction name="init" access="public" returntype="GeoLocation" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
  		super.Init(arguments.controller);
  		
  		setpluginName("GeoLocation");
  		setpluginVersion("1.0");
  		setpluginDescription("I determine a user's location by their IP address");
  		
		variables.instance.cacheKeyPrefix = 'GeoLocation-';
		
		// Setting these here will apply to all calls
  		variables.instance.defaults = {
  			cache = true,
  			// leave blank to use cache defaults
  			cacheTimeout = '10',
  			// leave blank to use cache defaults
  			cacheLastAccessTimeout = '5',
  			cacheName = "default",
  			// Register here for free:
  			// http://www.ipinfodb.com
  			developerKey = ''
  		};
  		
  		return this;
		</cfscript>
	</cffunction>

	<cffunction name="getLocation" output="false" access="public" returntype="any" hint="Call me to get the location details on your user.">
		<cfargument name="IPAddress"				type="string"	required="false" default=""	hint="IP Address to lookup.  If not passed in, CGI.HTTP_X_Forwarded_For will be used, then CGI.Remote_Addr">
		<cfargument name="cache"					type="boolean"	required="false" default="#variables.instance.defaults.cache#"	hint="Cache results">
		<cfargument name="cacheTimeout"				type="string"	required="false" default="#variables.instance.defaults.cacheTimeout#">
		<cfargument name="cacheLastAccessTimeout"	type="string"	required="false" default="#variables.instance.defaults.cacheLastAccessTimeout#">
		<cfargument name="cacheName"				type="string"	required="false" default="#variables.instance.defaults.cacheName#" hint="Name of CacheBox Cache provider to use.">
		<cfargument name="developerKey"				type="string"	required="false" default="#variables.instance.defaults.developerKey#" hint="Override the one specified in the plugin">
		
		<cfscript>
			local.IPAddress = arguments.IPAddress;
			if(!len(trim(local.IPAddress))) {
				// The listFirst() because I've seen the IP twice as a comma-delimted list for some reason.
				if( len(trim(listFirst(CGI.HTTP_X_Forwarded_For))) ) {
					local.IPAddress = listFirst(CGI.HTTP_X_Forwarded_For); 
				} else {
					local.IPAddress = CGI.Remote_Addr;
				}
			}
						
			// Not caching
			if(!arguments.cache) {
				return getDetails(local.IPAddress,arguments.developerKey);
			}
			
			// We are caching
			local.cacheProvider = getColdboxOCM(arguments.cacheName);
			local.cacheKey = variables.instance.cacheKeyPrefix & local.IPAddress;
			
			// Look for it
			local.result = local.cacheProvider.get(local.cacheKey);
			
			// If we found it, return it
			if(structKeyExists(local,"result")) {
				return local.result;
			}
			
			// If not, get it ...
			local.result = getDetails(local.IPAddress,arguments.developerKey);
			
			// ... and set it.
			local.cacheParams = {
				objectKey = local.cacheKey,
				object = local.result
			};
			
			// Only override if set so we can fall back to cache provider defaults
			if(len(trim(arguments.cacheTimeout))) {
				local.cacheParams.timeout = arguments.cacheTimeout;
			}
			if(len(trim(arguments.cacheLastAccessTimeout))) {
				local.cacheParams.lastAccessTimeout = arguments.cacheLastAccessTimeout;				
			}
						
			local.cacheProvider.set(argumentCollection=local.cacheParams);
			
			return local.result;


		</cfscript>
	</cffunction>

	<cffunction name="getDetails" access="private" returntype="struct" output="false">
		<cfargument name="IPAddress"	type="string"	required="true">
		<cfargument name="developerKey"	type="string"	required="true">
		
		<cfscript>
			// one way or another, I will return this struct.
			// it may or may not be populated with useful data.
			local.response = {
				statusCode = 'ERROR',
				statusMessage = 'Check logs',
				ipAddress = '',
				countryCode = '',
				countryName = '',
				regionName = '',
				cityName = '',
				zipCode = '',
				latitude = '',
				longitude = '',
				timeZone = ''
			};
			
			
			try {
				
				local.HTTPResult = new http(
					url='http://api.ipinfodb.com/v3/ip-city/?key=#arguments.developerKey#&ip=#arguments.IPAddress#&format=json',
					method='GET',
					timeout='5',
					throwOnError=true
					)
				.send();
				
				local.fileContent = local.HTTPResult.getPrefix().fileContent;
				 
				if(!isJSON(local.fileContent)) {
					throw(message="Non-JSON response from IPInfoDB API", detail=local.fileContent);				
				}
				
				local.response = DeserializeJSON(local.fileContent);
						
				if( local.response.statusCode != 'OK') {
					throw(message="Non-'OK' response from IPInfoDB API", detail=local.fileContent);
				}          
					
				// The API sends back '-' for values it doesn't know, but I'd
				// rather just have an empty string so it's easier to check and see
				// if you have data.  
				for(local.key in local.response) {
					if(local.response[local.key] == '-') {
						local.response[local.key] = '';
					}
				}
					
			}
			catch(any e) {
				variables.log.error(e.message, e.detail);
			}	
			
			// We should always make it here and fail silently if anything goes boom above.
			return local.response;
		
		</cfscript>
	</cffunction>

	<cffunction name="clearCache" access="public" returntype="void" output="false">
		<cfargument name="cacheName"	type="string"	required="false" default="#variables.instance.defaults.cacheName#" hint="Name of CacheBox Cache provider to use.">
		
		<cfscript>
			// Look for cache keys that start with the key prefix
			local.regex = "^" & variables.instance.cacheKeyPrefix & ".*";
			 
			local.cacheProvider = getColdboxOCM(arguments.cacheName);
			local.keys = local.cacheProvider.getKeys();
			// Loop over all keys
			for(local.key in local.keys) {
				// And delete the ones that match
				if(reFindNoCase(local.regex,local.key)) {
					local.cacheProvider.clear(local.key);
				}
			}
		</cfscript>
	</cffunction>
	
</cfcomponent>