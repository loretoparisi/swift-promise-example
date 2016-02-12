package musixmatch.com.sampleandroidapp;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.os.AsyncTask;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

// Shared Library Test
import com.remobjects.elements.system.Action1;

import org.json.JSONException;
import org.json.JSONObject;

import samplelibrary.CacheObject;
import samplelibrary.SharedClassTest;
import samplelibrary.ConsoleLogger;
import sugar.json.JsonNode;
import sugar.json.JsonObject;

public class MainActivity extends AppCompatActivity {

    // The Shared Library Core
    SharedClassTest sampleAPI;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });

        // Calling Application class (see application tag in AndroidManifest.xml)
        final GlobalApplication globalVariable = (GlobalApplication) getApplicationContext();

        // Shared Library instance

        sampleAPI = new SharedClassTest();

        // set application context
        sampleAPI.context(getApplicationContext());

        // database setup
        sampleAPI.setup();


        // Async Task Shared Library Test
        BrowserTask task = new BrowserTask();
        task.execute();

    }

    @Override
    public void onResume() {
        super.onResume();

        // set application context
        if(sampleAPI!=null) {
            sampleAPI.context(getApplicationContext());
        }

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private class BrowserTask extends AsyncTask<String, Void, String> {
        @Override
        protected String doInBackground(String... params) {

        String apiURL = "https://api.spotify.com/v1/search?q=tania%20bowra&type=artist";

            Log.d("TEST", "Now calling sdk");

            Action1<CacheObject> success = new Action1<CacheObject>() {
                @Override
                public void run(CacheObject keyValuePairs) {
                    HashMap<String, Object> myObj = keyValuePairs.toJsonObject();

                    Iterator iter = myObj.entrySet().iterator();
                    while ( iter.hasNext() ) { // traverse items
                        Map.Entry menEntry = (Map.Entry) iter.next();

                        Log.d("TEST", "key:"+menEntry.getKey() +" value:"+menEntry.getValue() + "\nClass type:"
                                +menEntry.getValue().getClass().getSimpleName());

                        JsonObject jsonObject = (JsonObject) menEntry.getValue();
                        JsonNode aNode=jsonObject.getItem("artists");
                        Log.d("TEST", "[artists]"+aNode.ToJson());

                    }

                }
            };
            Action1<Exception> error = new Action1<Exception>() {
                @Override
                public void run(Exception e) {

                }
            };
            sampleAPI.getJsonObject__success__error(apiURL, success,error);

            sampleAPI.getJsonString__success__error(apiURL, new Action1<String>() {
                        @Override
                        public void run(String s) {
                            Log.d("TEST", s);
                        }
                    },

                    new Action1<Exception>() {
                        @Override
                        public void run(Exception e) {
                            Log.d("TEST", e.toString());
                        }
                    });

            return null;
        }

        @Override
        protected void onPostExecute(String result) {
        }

        @Override
        protected void onPreExecute() {
        }

        @Override
        protected void onProgressUpdate(Void... values) {
        }
    }
}
