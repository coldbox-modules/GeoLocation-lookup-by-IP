# Geolocation Lookup Module

[![Build Status](https://github.com/ColdBox/coldbox-platform/actions/workflows/ci.yml/badge.svg)](https://github.com/ColdBox/coldbox-platform/actions/workflows/)

This module will retrieve geolocation information for a specific user's ip address using the API available at https://www.ipinfodb.com.

## Features

The following and more information will be retrieved for you:

- countryCode
- countryName
- regionName
- cityName
- zipCode
- latitude
- longitude
- timeZone

```xml
<cfdump var="#getModel( 'GeoLocation@GeoLocation' ).getLocation()#">
```

## License

Apache License, Version 2.0.

## Links

- https://www.forgebox.io/view/GeoLocation-lookup-by-IP
- https://github.com/coldbox-modules/GeoLocation-lookup-by-IP

## Requirements

- Lucee 5+
- ColdFusion 2018+
- ColdBox 5+

## Installation

Use CommandBox to install

`box install GeoLocation-lookup-by-IP`

You can then continue to configure the module in your `config/Coldbox.cfc`.

```js
moduleSettings = {

    "GeoLocation-lookup-by-IP" : {
        // Should results be cached
        cache = true,
        // leave blank to use cache defaults
        cacheTimeout = '10',
        // leave blank to use cache defaults
        cacheLastAccessTimeout = '5',
        // Name of CacheBox provider to use
        cacheName = "default",
        // Prefix to be used for cache keys
        cacheKeyPrefix = 'GeoLocation-',
        // Register here for free:,
        // http://www.ipinfodb.com
        developerKey = ''
    }

}
```

## Usage

You can retrieve the main model via injection or requesting it from WireBox using the following DSL

- `GeoLocation@GeoLocation`

There are two two public methods:

### getLocation()

```js
var result = GeoLocation.getLocation();
```

By default, it will use the IP address obtained from the CGI scope (taking into account a forwarded request).  By default, this method will also cache the result in your default CacheBox provider for 10 minutes.

This method takes the following optional parameters that override the module defaults:

- `IPAddress`
- `cache`
- `cacheTimeout`
- `cacheLastAccessTimeout`
- `cacheName`
- `developerKey`

### clearCache()

This method will clear out any items in the cache that it put there.
This method takes the following optional parameter that override the module defaults:

- `cacheName`

This code comes with no warranties, promises, or rainbows.  In fact, it will probably kick your cat.

Brad Wood
- brad@bradwood.com
- http://www.codersrevolution.com

********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************

### HONOR GOES TO GOD ABOVE ALL

Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the
Holy Ghost which is given unto us. ." Romans 5:5

### THE DAILY BREAD

 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
