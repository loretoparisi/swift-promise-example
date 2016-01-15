/**
* Silver Sugar Shared Project Example
* HTTP and Database Logic
* iOS and Android targets
* @author: Loreto Parisi (loreto at musixmatch dot com )
* @2015-2016 Loreto Parisi
*/

import Sugar
import Sugar.data;
import Sugar.io;

public class SharedClassTest {
	
	// Database Storage
	var storage:DatabaseStorage;
	
	// Console Logger
	var logger:ConsoleLogger;
	
	init() {
		
		// Logger
		let level = Logger.Level.DEBUG;
		logger = ConsoleLogger( level:level );
		
		// Persistent Database Storage
		storage = DatabaseStorage(logger:logger);
	
	}
	
	/******************
	* Public API
	******************/
	
	/**
	* Setup
	*/
	public func setup() -> () {
		
		let guid = Sugar.Guid.NewGuid();
		let osName:String = Sugar.Environment.OSName;
		let osVersion:String = Sugar.Environment.OSVersion;
		let userName:String = Sugar.Environment.UserName;
		
		let systemInfo:String = "\(osName)/\(osVersion)/\(userName)/\(guid)";
		writeLn( systemInfo );
		
		storage.testSelect();
		
	}
	
	/**
	* Perform HTTP Call
	*/
	public func httpCall(var url: String, completion: (response:String?) ->()  )	
	{
		
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
		
	}
	
	/***********************
	* Platform-Dependent API
	************************/
	
	#if java
	public func context(var context:android.content.Context) ->() {
		Sugar.Environment.ApplicationContext = context;
	}
	#endif
}