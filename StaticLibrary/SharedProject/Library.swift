import Sugar
import Promise

public class MiaClasse2 {
	
	public  func add (var a: Int, var b: Int) -> Int {
		return a + b;
	}
	
	public func diff( var a:Int, var b:Int) -> Int {
		return (a>b ? a-b : b-a);
	}

	public func httpCall(var url: String, completion: (response:String?) ->()  )	
	{
		
		
		// this is just an example now until the Promise.swift will work
		var promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
			
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
		}
		
		println(url);
	
		let jsonCallback: HttpContentResponseBlock<Sugar.Json.JsonDocument!>! = { response in 
			if response.Success {
				var obj = response.Content.RootObject
				println( "JSON RESPONSE " )
				println( obj)
			}
		}
		Http.ExecuteRequestAsJson( Url(url), jsonCallback)
		
		Http.ExecuteRequest(Url( url ), { response in
			println (response )
		})
		
		Http.ExecuteRequest(Url(url), { response in
			if response.Success {
				response.GetContentAsString(nil) { content in
					if content.Success {
						writeLn("Response was: "+content.Content);
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