/**
* Silver Sugar Shared Project Example
* Shared Library
* @author: Loreto Parisi (loreto at musixmatch dot com )
* @2015-2016 Loreto Parisi
*/

import Sugar

public class SharedClassTest {
	
	// Database Storage
	var storage:DatabaseStorage;
	
	// API Client
	var client:APIClient;
	
	// Console Logger
	var logger:ConsoleLogger;
	
	public init() {
		
		// Logger
		let level = Logger.Level.DEBUG;
		logger = ConsoleLogger( level:level );
		
		// Persistent Database Storage
		storage = DatabaseStorage(logger:logger);
	
		// API Client
		client = APIClient(logger:logger);
	
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
		
		storage.testDatabase();
		
	}
	
	/**
	* Perform HTTP REST Call
	*/
	public func getJsonObject(var aUrl: String, success: (response:CacheObject?) ->(), error: (response:Exception?) ->()  )	 {
		client.testGetJsonObject(aUrl, success: { (response:CacheObject!) -> () in
				success( response )
		},
		error: { (response:Exception!) -> () in
			error( response )
		});
	}
	
	/**
	* Perform HTTP REST Call
	*/
	public func getJsonString(var aUrl: String, success: (response:String?) ->(), error: (response:Exception?) ->()  )	 {
		client.testGetJsonString(aUrl, success: { (response:String!) -> () in
				success( response )
		},
		error: { (response:Exception!) -> () in
			error( response )
		});
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