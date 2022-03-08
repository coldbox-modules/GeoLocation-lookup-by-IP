/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 */
component {

	// Module Properties
	this.title             = "GeoLocation By IP";
	this.author            = "Brad Wood";
	this.webURL            = "https://www.forgebox.io/view/GeoLocation-lookup-by-IP";
	this.description       = "Look up and cache a user's countryCode, countryName, regionName, cityName, , zipCode, latitude, longitude, and timeZone by IP address.";
	this.version           = "@build.version@+@build.number@";
	this.modelNamespace    = "GeoLocation";
	this.cfmapping         = "GeoLocation";
	this.dependencies      = [];
	this.autoMapModels     = true;
	this.applicationHelper = [ "helpers/Mixins.cfm" ];

	/**
	 * Configure Module
	 */
	function configure(){
		settings = {
			// Cache subsequent ip address lookups for performance
			cache          : true,
			// How many minutes to cache the IP lookup
			cacheTimeout   : "60",
			// The default cache provider to use
			cacheName      : "default",
			// The cache prefix to use on all ip keys
			cacheKeyPrefix : "GeoLocation-",
			// Register here for free:
			// https://www.ipinfodb.com
			developerKey   : ""
		};
	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
	}

}
