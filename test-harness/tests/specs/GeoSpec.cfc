/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	function run(){
		// all your suites go here.
		describe( "Gelocation Module", function(){
			beforeEach( function( currentSpec ){
				setup();
				geoLocation = getInstance( "GeoLocation@GeoLocation" );
			} );

			it( "should register the component", function(){
				expect( geoLocation ).toBeComponent();
			} );

			it( "can get a location with caching defaults", function(){
				var results = geoLocation.getLocation( "96.68.73.49" );
				expect( results ).toBeStruct().toHaveKey( "cityName,zipCode,latitude,longitude,timezone" );
				expect( results.cityName ).toBe( "Houston", results.toString() );
				expect( results.cached ).toBe( false );

				var results = geoLocation.getLocation( "96.68.73.49" );
				expect( results.cached ).toBe( true );
			} );

			it( "can get a location with no cache", function(){
				var results = geoLocation.getLocation( ipAddress = "96.68.73.49", cache = false );
				expect( results ).toBeStruct().toHaveKey( "cityName,zipCode,latitude,longitude,timezone" );
				expect( results.cityName ).toBe( "Houston", results.toString() );
				expect( results.cached ).toBe( false );
			} );

			it( "can clear the cache", function(){
				var results = geoLocation.getLocation( "96.68.73.49" );
				expect( results.cityName ).toBe( "Houston", results.toString() );
				expect( geoLocation.getGeoCache().getKeys() ).notToBeEmpty();
				geoLocation.clearCache();
				expect( geoLocation.getGeoCache().getKeys() ).toBeEmpty();
			} );
		} );
	}

}
