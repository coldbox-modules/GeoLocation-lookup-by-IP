<cfscript>
	/**
	 * Get the location details of an IP Address
	 *
	 * @IPAddress The ip address to lookup, if not passed in, we will auto-determine it
	 * @cache If true, we will cache the ip vs result
	 * @cacheTimeout The cache timeout in minutes
	 * @cacheLastAccessTimeout The cache last access timeout
	 * @cacheName The cache name to use to store the lookup. Defaults to the `template` scope
	 * @developerKey A custom key to use or the one seeded into the module configuration
	 *
	 * @return struct of location details
	 */
	string function getGeoLocation( string key='', boolean forceNew=false ) {
		return getInstance( 'GeoLocation@GeoLocation' ).getLocation( argumentCollection = arguments );
	}

</cfscript>
