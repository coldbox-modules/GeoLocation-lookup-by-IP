6/7/2013

This is a ColdBox plugin that will retrieve the following info for you based on your user's IP address using the API available at http://www.ipinfodb.com:
- countryCode
- countryName
- regionName
- cityName
- zipCode
- latitude
- longitude
- timeZone

Drop the plugin inside your plugins directory and access it via getMyPlugin("GeoLocation"). The plugin has the following configuration fields inside:

// Should results be cached
cache = true
// leave blank to use cache defaults
cacheTimeout = '10'
// leave blank to use cache defaults
cacheLastAccessTimeout = '5'
// Name of CacheBox provider to use
cacheName = "default"
// Register here for free:
// http://www.ipinfodb.com
developerKey = ''

There are two two public methods:

var result = GeoLocation.getLocation();

By default, it will use the IP address obtained from the CGI scope (taking into account a forwarded request)
By default, this method will also cache the result in your default CacheBox provider for 10 minutes.
This method takes the following optional parameters that override the plugin defaults:

- IPAddress
- cache
- cacheTimeout
- cacheLastAccessTimeout
- cacheName
- developerKey

GeoLcation.clearCache();

This method will clear out any items in the cache that it put there.
This method takes the following optional parameter that override the plugin defaults:
- cacheName

This code comes with no warranties, promises, or rainbows.  In fact, it will probably kick your cat.

Brad Wood
- brad@bradwood.com
- http://www.codersrevolution.com