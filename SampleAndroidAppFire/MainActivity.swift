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
	var sampleAPI:SharedClassTest!;
	
	private func testAPIGetJson() -> () {
		let url = "https://api.spotify.com/v1/search?q=tania%20bowra&type=artist";
			
		let successAction:Action1<sugar.String?> = { result in
			Log.d("TEST", result);
		};
		let errorAction:Action1<Exception?> = { error in
			if let err = error {
				Log.d("TEST", err.toString());
			}
		};
		sampleAPI.getJsonString(url, success:successAction, error: errorAction);
	}

	public override func onCreate(savedInstanceState: Bundle!) {
		super.onCreate(savedInstanceState)
		ContentView = R.layout.main
		
		Log.d("TEST", "Hello Android on Fire!");
		
		self.sampleAPI = SharedClassTest();
		// set application context
		self.sampleAPI.context(getApplicationContext());
		// database setup
		self.sampleAPI.setup();
	
	}
	
	public override func onResume() {
		super.onResume();
		
		self.sampleAPI.context(getApplicationContext());
		self.testAPIGetJson();

	}
}

