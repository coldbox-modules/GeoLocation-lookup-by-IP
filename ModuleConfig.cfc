component {

	// Module Properties
	this.title 				= "GeoLocation By IP";
	this.author 			= "Brad Wood";
	this.webURL 			= "http://www.coldbox.org/forgebox/view/GeoLocation-lookup-by-IP";
	this.description 		= "Look up and cache a user's countryCode, countryName, regionName, cityName, , zipCode, latitude, longitude, and timeZone by IP address.";
	this.version			= "1.0.0";
	this.modelNamespace		= "GeoLocation";

	function configure(){
		
  		settings = {
  			cache = true,
  			// leave blank to use cache defaults
  			cacheTimeout = '10',
  			// leave blank to use cache defaults
  			cacheLastAccessTimeout = '5',
  			cacheName = "default",
			cacheKeyPrefix = 'GeoLocation-',
  			// Register here for free:
  			// http://www.ipinfodb.com
  			developerKey = ''
  		};
		
		// Look for module setting overrides in parent app and override them.
		var coldBoxSettings = controller.getSettingStructure();
		if( structKeyExists( coldBoxSettings, 'geolocation-lookup-by-ip' ) 
			&& structKeyExists( coldBoxSettings[ 'geolocation-lookup-by-ip' ], 'settings' ) ) {
			structAppend( settings, coldBoxSettings[ 'geolocation-lookup-by-ip' ][ 'settings' ], true );
		}
		
	}

}