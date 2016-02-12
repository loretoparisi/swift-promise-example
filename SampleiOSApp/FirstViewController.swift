import UIKit
import Sugar

@IBObject public class FirstViewController : UIViewController {

	public override func viewDidLoad() {

		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let api:SharedClassTest = SharedClassTest();
		api.setup();
		
		let successDelegate:(String?) -> ()  = {
			(result:String?) -> () in
				print(result);
		};
			
		let errorDelegate:(Exception?) -> ()  = {
			(error:Exception?) -> () in
				print(error);
		};
		
		var apiEndpoint:String="https://api.spotify.com/v1/search?q=tania%20bowra&type=artist";
		api.getJsonString(apiEndpoint, success: successDelegate, error: errorDelegate);
		
		api.getJsonObject(apiEndpoint, success: {
			(result:CacheObject?) -> () in
			
			if let obj = result { //unwrap CacheObject
				if let deserialized = obj.value! { //unwrap props
					print( deserialized );
					print( obj.ToJson() );
				}
				
				// Following code not working yet
				/*
				if let jsonObject=obj.toJsonObject() { // json object
					
					print("\(jsonObject)\n[artists]=\(jsonObject["artists"])");
					if let jsonValue=jsonObject["artists"] {
						print("[artists]][href]\(jsonValue["href"])");
					}
				}*/
			}
			
		}, error: errorDelegate);
		
		api.getJsonString(apiEndpoint, success: successDelegate, error: errorDelegate);
		
		apiEndpoint="https://posttestserver.com/post.php?dir=swift-promise";
		let epoch:NSTimeInterval = NSDate().timeIntervalSince1970;
		let epochInt64 = Int64(epoch)
		var dict: Dictionary<String, String> = [
			"key" : "value"
			,"timestamp" : Convert.ToString(epochInt64)
		];
		api.postJsonString(apiEndpoint, parameters:dict, success: {
			(result:String?) -> () in
			
			if let obj = result { //unwrap CacheObject
				print( obj );
			}
			
		}, error: errorDelegate);
	
	}

	public override func didReceiveMemoryWarning() {

		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
