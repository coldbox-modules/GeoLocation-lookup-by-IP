/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	function run(){
		// all your suites go here.
		describe( "Gelocation Module", function(){
			beforeEach( function( currentSpec ){
				geoLocation = getInstance( "@Gelocation" );
				setup();
			} );

			it( "should register the component", function(){
				expect( geoLocation ).toBeComponent();
			} );

			it( "can get a location", function(){
				writeDump( var = getLocation.getLocation(), top = 5 );
			} );
		} );
	}

}
