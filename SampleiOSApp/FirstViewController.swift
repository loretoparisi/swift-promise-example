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
		
		let apiEndpoint:String="https://api.spotify.com/v1/search?q=tania%20bowra&type=artist";
		api.getJsonString(apiEndpoint, success: successDelegate, error: errorDelegate);
		
		api.getJsonObject(apiEndpoint, success: {
			(result:CacheObject?) -> () in
			
			if let deserialized = result.value! {
				print( deserialized );
			}
			
		}, error: errorDelegate);
	
	}

	public override func didReceiveMemoryWarning() {

		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
