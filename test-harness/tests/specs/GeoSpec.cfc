/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	function run(){
		// all your suites go here.
		describe( "Gelocation Module", function(){
			beforeEach( function( currentSpec ){
				geoLocation = getInstance( "GeoLocation@GeoLocation" );
				setup();
			} );

			it( "should register the component", function(){
				expect( geoLocation ).toBeComponent();
			} );

			it( "can get a location", function(){
				var results = geoLocation.getLocation( "96.68.73.49" );
				expect( results ).toBeStruct().toHaveKey( "cityName,zipCode,latitude,longitude,timezone" );
				expect( results.cityName ).toBe( "Houston", results.toString() );
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
