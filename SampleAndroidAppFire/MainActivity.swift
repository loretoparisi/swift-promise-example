import java.util
import android.app
import android.content
import android.os
import android.util
import android.view
import android.widget

import sugar

public class MainActivity: Activity {
	
	// The Shared Library Core
	var sampleAPI:SharedClassTest?;

	public override func onCreate(savedInstanceState: Bundle!) {
		super.onCreate(savedInstanceState)
		ContentView = R.layout.main
		
		Log.d("TEST", "Hello Android on Fire!");
		
		// Calling Application class (see application tag in AndroidManifest.xml)
		
		// Shared Library instance

		if let self.sampleAPI = SharedClassTest() {
			// set application context
			sampleAPI.context(getApplicationContext());

			// database setup
			sampleAPI.setup();
			
			let url = "https://api.spotify.com/v1/search?q=tania%20bowra&type=artist";
			
			let successAction:Action1<sugar.String?> = { result in
				Log.d("TEST", result);
			};
			let errorAction:Action1<Exception?> = { error in
				if let err = error {
					Log.d("TEST", err.toString());
				}
			};
			
			/*let successDelegate = {
				// [self]   // Original version had this not commented; it's commented to let people know it was a typo
				class SomethingClass {
					func run(s:String) -> () {  Log.d("TEST", s); }
				}
				return SomethingClass()
			}()
			
			let errorDelegate = {
				// [self]   // Original version had this not commented; it's commented to let people know it was a typo
				class SomethingClass {
					func run(e:Exception) -> () {  Log.d("TEST", e.toString()); }
				}
				return SomethingClass()
			}()*/
			
			sampleAPI.getJsonString(url, success:successAction, error: errorAction);
		}
	}
	
	public override func onResume() {
		super.onResume();

		// set application context
		/*if let sampleAPI = self.sampleAPI {
			sampleAPI.context(getApplicationContext());
		}*/

	}
}

