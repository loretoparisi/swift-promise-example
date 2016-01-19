/**
* Silver Sugar Shared Project Example
* API Client
* @author: Loreto Parisi (loreto at musixmatch dot com )
* @2015-2016 Loreto Parisi
*/

import Sugar

/**
* API Client
*/
public class APIClient {
	
	// Console Logger
	var logger:Logger;
	
	public init() {
		let level = Logger.Level.DEBUG;
		logger = ConsoleLogger( level:level );
	}
	
	public init(var logger:Logger) {
		self.logger = logger;
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
	*/
	public func post(var aUrl: String, parameters: NSObject![], completion: (response:String?)) ->() {
	
	} //post
	
	/******************
	* Test API
	******************/
	
	/**
	* Test Call
	*/
	public func testGet(var url: String, completion: (response:String?) ->()  ) {
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
		
		//let jsonObj:Sugar.Json.JsonObject = Sugar.Json.JsonObject();
		//let parsedJsonObj:Sugar.Json.JsonObject = Sugar.Json.JsonObject.Load("");
		
		let jsonCallback: HttpContentResponseBlock<Sugar.Json.JsonDocument!>! = { response in 
			if response.Success {
				var obj = response.Content.RootObject
			}
		}
		Http.ExecuteRequestAsJson( Url(url), jsonCallback)
		
		Http.ExecuteRequest(Url( url ), { response in
			writeLn (response )
		})
		
		Http.ExecuteRequest(Url(url), { response in
			if response.Success {
				response.GetContentAsString(nil) { content in
					if content.Success {
						completion( content.Content )
					}
				}
			}
		});
		
		/*let plainCallback: HttpResponseBlock<String!> = { response in
		
		}
		Http.ExecuteRequest(Url( url ), plainCallback)*/
	} //testCall

}
