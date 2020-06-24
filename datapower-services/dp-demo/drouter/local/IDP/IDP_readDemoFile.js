var urlopen  = require('urlopen');
var sm = require ('service-metadata.js');
var hm = require ('header-metadata.js');

var uri = sm.getVar ('var://service/URI');	
console.warn("URI: " + uri);	

// Compute the token URL
var backendURL = 'local://' + uri;

// Set URL Options for GET
var GETOptions = {
            target: backendURL,
            method: 'GET',
       contentType: 'text/html',
           timeout: 120
           };
urlopen.open(GETOptions, function(error, response) {
  if (error) {

    var httpCode=503;
    var httpReasonPhrase='URLopen Error';
    var errorMessage=error;
    var ignoreCatch='true';
    session.output.write(error);

  } else {
    // get the response status code
    var responseStatusCode = response.statusCode;
    var responseReasonPhrase = response.reasonPhrase;
    console.log("Response status code: " + responseStatusCode);
    console.log("Response reason phrase: " + responseReasonPhrase);
    // reading response data
    response.readAsBuffer(function(error, responseData){
      if (error){
        throw error ;
      } else {
        hm.response.set ('Content-Type', 'text/html');	
        session.output.write(responseData);
      }
    });
  }
});