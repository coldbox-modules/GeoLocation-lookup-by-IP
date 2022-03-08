<cfscript>
	/**
	 * Get the location details of an IP Address
	 *
	 * @IPAddress The ip address to lookup, if not passed in, we will auto-determine it
	 * @cache If true, we will cache the ip vs result
	 *
	 * @return struct of location details
	 */
	function getGeoLocation(
		IPAddress,
		cache
	) {
		return getInstance( 'GeoLocation@GeoLocation' ).getLocation( argumentCollection = arguments );
	}

</cfscript>
