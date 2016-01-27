//
//  ViewController.swift
//  CrossTest
//
//  Created by Loreto Parisi on 11/12/15.
//  Copyright © 2015 Musixmatch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    func createDatabaseURL() -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        // If array of path is empty the document folder not found
        guard urls.count == 0 else {
            let finalDatabaseURL = urls.first!.URLByAppendingPathComponent("testdb.sql")
            // Check if file reachable, and if reacheble just return path
            guard finalDatabaseURL.checkResourceIsReachableAndReturnError(nil) else {
                // Check if file is exists in bundle folder
                if let bundleURL = NSBundle.mainBundle().URLForResource("testdb", withExtension: "sql") {
                    // if exist we will copy it
                    do {
                        try fileManager.copyItemAtURL(bundleURL, toURL: finalDatabaseURL)
                    } catch _ {
                        print("File copy failed!")
                    }
                } else {
                    print("Our file not exist in bundle folder")
                    return finalDatabaseURL
                }
                return finalDatabaseURL
            }
            return finalDatabaseURL
        }
        return nil
    }
    
    /**
     * Test Database
    */
    func databaseTest(api:SharedClassTest) -> () {
    
        api.setup();
    
    }
    
    /**
     * Test HTTP Call, Response handling with a Promise
     */
    func httpCallTest(api:SharedClassTest) -> () {
        let promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
            
            let apiEndpoint:String="https://api.spotify.com/v1/search?q=tania%20bowra&type=artist";
            api.getJsonObject(apiEndpoint, success: { (response:String!) -> Void in
                resolve(response);
                }, error: { (exception:NSException!) -> Void in
                    reject(exception);
            });
        }
        promise.then { (value) -> () in
            // Probably doing something important with this data now
            print("REQUEST SUCCESS");
            print( value )
            }
            .catch_ { (error) -> () in
                // Display error message, log errors
                print("REQUEST FAILED");
                print(error)
            }
            .finally { () -> () in
                // Close connections, do cleanup
        }
    }
    
    func test1() -> () {
        
        let api:SharedClassTest = SharedClassTest();
        
        databaseTest(api);
        httpCallTest(api);
        
        let epoch:NSTimeInterval = NSDate().timeIntervalSince1970;
        print( epoch );
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        test1();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

