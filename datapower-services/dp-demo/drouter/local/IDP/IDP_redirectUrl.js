var sm = require ('service-metadata.js');
var hm = require ('header-metadata.js');
var url = require ('url');

var context = session.name('saved');
var userName = context.getVariable ('userName');
var token = context.getVariable ('securityTokenFinal');
var originalUrl = context.getVariable ('originalUrl');

console.warn ('userName: ' + userName );
console.warn ('token: ' + token );
console.warn ('originalUrl: ' + originalUrl ); 

if (originalUrl) {
		// Check if code is generated
		if (token) {

        	var link = originalUrl +'&username='+ userName + '&confirmation=' + token;	
        	
        	if(userName == 'admin2@think.ibm') { 
        		link = originalUrl +'&username='+ userName + '&error=' + 'Not granted access';	
        	}
			// Set the Redirect location 
			hm.response.set ('Location', link);
        	console.warn ('redirectUrl: ' + link );
	
			// Set the Response Headers
			hm.response.statusCode = '302 redirected';
		}
} else {
		// Check if the request is already being redirected
		var currentLocationHeader = hm.response.get ('Location');
		console.warn ('currentLocationHeader: ' + currentLocationHeader );
		
		if (currentLocationHeader) {

		    // Get the Local service address
		    var localServiceAddress = sm.getVar ('var://service/local-service-address');
		    console.warn ('localServiceAddress: ' + localServiceAddress );	
		    
		    // Check if the DataPower instance was running locally
		    if ((currentLocationHeader.includes(localServiceAddress)) || (currentLocationHeader.includes('localhost'))) {

        		console.warn ('No need to strip the port from the redirect URL' );
		    
        	} else  { 
        	
        	    var locationTokens = currentLocationHeader.split(":");
        	    
        	    // Check if port is specified and there were three tokens
        	    if (locationTokens[2]) {
        	    
        			// Reset the Location Header
        			var newLink =  locationTokens[0] + ':' + locationTokens[1] +  locationTokens[2].slice(4)
        		
        			// Set the Redirect location without the listener port 6443
        			hm.response.set ('Location', newLink);
        			console.warn ('Revised redirectUrl: ' + newLink );
        		}
        	}
		}
}

