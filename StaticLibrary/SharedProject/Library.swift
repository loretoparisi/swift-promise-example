import Sugar
import Sugar.data;
import Sugar.io;

//import Promise

public class SharedClassTest {
	
	public func databaseSetup() -> () {
		
		// file system folder path
		let Separator:Char=Sugar.io.folder.Separator;
		let userLocal:Folder=Sugar.IO.Folder.UserLocal();
		let userLocalPath:String=userLocal.Path;
		
		let dbPath:String = Sugar.io.Path.Combine(userLocalPath,Separator+"db.sql");
		
		writeLn (dbPath )
		
		let dbConn:SQLiteConnection = SQLiteConnection.init(dbPath, false, true); // name, readonly, createifneeded
		
	}

	public func httpCall(var url: String, completion: (response:String?) ->()  )	
	{
		
		// this is just an example now until the Promise.swift will work
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
}