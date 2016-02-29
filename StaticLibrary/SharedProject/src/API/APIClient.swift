/**
* Silver Sugar Shared Project Example
* API Client
* @author: Loreto Parisi (loreto at musixmatch dot com )
* @2015-2016 Loreto Parisi
*/

import Sugar
import Sugar.Cryptography;

/**
* API Client
*/
class APIClient {
	
	__event Callback: ((Int) -> ())!
	
	// Console Logger
	var logger:Logger;
	
	public override init() {
		let level = Logger.Level.DEBUG;
		logger = ConsoleLogger( level:level );
	}
	
	public override init(var logger:Logger) {
		self.logger = logger;
	}
	
	/******************
	* Private API
	******************/
	
	/**
	 * Get a signed url
	 * uses Sugar.Crypto
	 */
	private func getSignedUrl(baseUrl:String!) -> (String) {
		 var signedUrl="";
		
		// 1- append UTC now
		let now = DateTime.UtcNow
		let unixMsec = (now.Ticks - DateTime.TicksSince1970 ) / TimeSpan.TicksPerSecond;
		signedUrl = baseUrl + Convert.ToString(unixMsec,10);
		
		// 2- sign base url with secret in SHA1 encryption
		let digest = MessageDigest( DigestAlgorithm.SHA1 );
		// let data=Convert.ToByte(signedUrl);
	   // self.logger.debug( Convert.ToString( data ) );
		
		// 3 - base64 of the signature
		
		// 4 - url safe encode signed url
		// escape chars sequence is ":/?#[]@$&’,;+="
		
		self.logger.debug( "SIGNED URL "  + signedUrl );
		
		return signedUrl;
	}
	
	/******************
	* Public API
	******************/
	
	/**
	* Http Get
	*/
	public func get(var aUrl: String, completion: (response:String?)) ->() {
	
	} //get
	
	/**
	* Http Post
	* https://github.com/remobjects/sugar/blob/master/Sugar/JSON/JsonDocument.pas
	*/
	public func post(var aUrl: String, parameters: AnyObject![], completion: (response:String?)) ->() {
	} //post
	
	/******************
	* Test API
	******************/
	
	/**
	 * Post JSON object
	 */
	public func testPostJsonString(var url:String,
		let parameters: [String:String]!,
		success: (response:String?) ->(),
		error: (response:Exception?) ->()) ->() {
			
			var body=""
			for (key,value) in parameters {
				body += "&"+key+"="+value
			}
			
			let request = HttpRequest( Url(url) );
			
			request.Mode=HttpRequestMode.Post;
			request.FollowRedirects = true;
			request.Headers["User-Agent"]="switft-example";
			request.Content = HttpBinaryRequestContent(body, Encoding.UTF8)
			
			Http.ExecuteRequest(request, { response in
				if response.Success {
					response.GetContentAsString(nil) { content in
						if content.Success {
							success( content.Content )
						}
						else {
							error(response.Exception);
						}
					}
				}
			});
	} //testPostJsonString
	
	/**
	* Retrieve a json string
	*/
	public func testGetJsonString(var url: String, success: (response:String?) ->(), error: (response:Exception?) ->()  ) -> () {
		let jsonCallback: HttpContentResponseBlock<Sugar.Json.JsonDocument!>! = { response in 
			if response.Success {
				
				
				// Json Object Response
				let jsonObject:Sugar.Json.JsonObject = response.Content.RootObject;
				
				let rndIndex=(Sugar.Random()).NextInt();
				let key="USER_"+Convert.ToString(rndIndex,10);
				let now = DateTime.UtcNow;
				let unixMsec = (now.Ticks - DateTime.TicksSince1970 ) / TimeSpan.TicksPerSecond;
				
				self.logger.debug( jsonObject.ToString() );
				
				var cacheObject:CacheObject = CacheObject(key:key, value:jsonObject.ToString(), timestamp: Convert.ToString(unixMsec, 10) );
				 
				self.logger.debug( "CACHE OBJECT "  + cacheObject.timestamp );
				  
				cacheObject.map(jsonObject.ToString() );
				success( cacheObject.ToJson() );
				
			}
			else {
				error(response.Exception);
			}
		}
		Http.ExecuteRequestAsJson( Url(url), jsonCallback)
	} //testGetJson
	
	/**
	* Retrieve a json object
	*/
	public func testGetJsonObject(var url: String, success: (response:CacheObject?) ->(), error: (response:Exception?) ->()  ) -> () {
		let jsonCallback: HttpContentResponseBlock<Sugar.Json.JsonDocument!>! = { response in 
			if response.Success {
				
				
				// Json Object Response
				let jsonObject:Sugar.Json.JsonObject = response.Content.RootObject;
				
				let rndIndex=(Sugar.Random()).NextInt();
				let key="USER_"+Sugar.Convert.ToString(rndIndex,10);
				let now = DateTime.UtcNow
				let unixMsec = (now.Ticks - DateTime.TicksSince1970 ) / TimeSpan.TicksPerSecond;
				var cacheObject:CacheObject = CacheObject(key:key, value:jsonObject.ToString(), timestamp: Convert.ToString( unixMsec, 10 ) );
				 
				self.logger.debug( "CACHE OBJECT "  + cacheObject.timestamp );
				
				cacheObject.map(jsonObject.ToString() );
				success( cacheObject );
				
			}
			else {
				error(response.Exception);
			}
		}
		let signedUrl=getSignedUrl(url);
		Http.ExecuteRequestAsJson( Url(url), jsonCallback)
	} //testGetJson
	
	/**
	* Test Call
	*/
	public func testGetContent(var url: String, success: (response:String?) ->(), error: (response:Exception?) ->()  ) {
		Http.ExecuteRequest(Url(url), { response in
			if response.Success {
				response.GetContentAsString(nil) { content in
					if content.Success {
						success( content.Content )
					}
					else {
						error(response.Exception);
					}
				}
			}
		});
		 /*var promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
			
			/*response = API.login()
			if (response.success) {
				resolve(response.user)
			} else {
				reject(response.error)
			}*/
		}
		promise.then { (value) -> () in
				// Probably doing something important with this data now
			}
			.catch_ { (error) -> () in
				// Display error message, log errors
			}
			.finally { () -> () in
			// Close connections, do cleanup
		}*/
	} //testGetContent

}
