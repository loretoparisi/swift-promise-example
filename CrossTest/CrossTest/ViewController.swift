//
//  ViewController.swift
//  CrossTest
//
//  Created by Loreto Parisi on 11/12/15.
//  Copyright © 2015 Musixmatch. All rights reserved.
//

import UIKit
import Foundation

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
    func GetJsonStringTest(api:SharedClassTest) -> () {
        let promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
            
            let apiEndpoint:String="https://api.spotify.com/v1/search?q=tania%20bowra&type=artist";
            api.getJsonString(apiEndpoint, success: { (response:String!) -> Void in
                resolve(response);
                }, error: { (exception:NSException!) -> Void in
                    reject(exception);
            });
        }
        promise.then { (value) -> () in
            // Probably doing something important with this data now
            print("Request succeeded");
            print( value )
            }
            .catch_ { (error) -> () in
                // Display error message, log errors
                print("Request failed");
                print(error)
            }
            .finally { () -> () in
                // Close connections, do cleanup
                print("Cleaning up resources...");
        }
    }
    
    /**
     * Test HTTP POST Call, Response handling with a Promise
    */
    func PostJsonStringTest(api:SharedClassTest) -> () {
        let promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
            
            let apiEndpoint:String="https://posttestserver.com/post.php?dir=swift-promise";
            
            let epoch:NSTimeInterval = NSDate().timeIntervalSince1970;
            let epochInt64 = Int64(epoch)
            let dict: NSMutableDictionary = [
                "timestamp" : String(epochInt64),
                "item" : [
                    "name" : "track"
                ]
            ];
            
            api.postJsonString(apiEndpoint, parameters: dict, success: { (response:String!) -> Void in
                
                
                resolve( response );
                
                
                }, error: { (exception:NSException!) -> Void in
                    reject(exception);
            });
        }
        promise.then { (value) -> () in
            // Probably doing something important with this data now
            print("Request succeeded");
            
            if let obj = value {
                
                print( obj )
                
                
            }
            
            
            }
            .catch_ { (error) -> () in
                // Display error message, log errors
                print("REQUEST FAILED");
                print(error)
            }
            .finally { () -> () in
                // Close connections, do cleanup
                print("Cleaning up resources...");
        }
    
    } //PostJsonStringTest
    
    /**
     * Test HTTP Call, Response handling with a Promise
     */
    func GetJsonObjectTest(api:SharedClassTest) -> () {
        let promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
            
            let apiEndpoint:String="https://api.spotify.com/v1/search?q=tania%20bowra&type=artist";
            
            api.getJsonObject(apiEndpoint, success: { (response:CacheObject!) -> Void in
                
                
                resolve( response );
                
                
                }, error: { (exception:NSException!) -> Void in
                    reject(exception);
            });
        }
        promise.then { (value) -> () in
            // Probably doing something important with this data now
            print("Request succeeded");
            
            if let obj = value {
                
                let result:CacheObject=obj as! CacheObject;
                
                print( result )
                print( result.timestamp )
                print( result.value )
                
                if let jsonString=result.ToJson() { // json string
                    print( "JSON STRING:\n\(jsonString)" )
                }
                
                /*if let jsonObject=result.toJsonObject() { // json object
                    
                    print("toJsonObject:\n\(jsonObject)");
                    if let jsonValue=jsonObject["artists"] {
                        print("[artists]\(jsonValue)\n[artists]][href]\(jsonValue["href"])");
                    }
                }
                else {
                    print("toJsonObject no result");
                }*/
            
            }
            
            
            }
            .catch_ { (error) -> () in
                // Display error message, log errors
                print("REQUEST FAILED");
                print(error)
            }
            .finally { () -> () in
                // Close connections, do cleanup
                print("Cleaning up resources...");
        }
    }
    
    /**
     * Static Shared Library tests
    */
    func test1() -> () {
        
        let api:SharedClassTest = SharedClassTest();
        
        databaseTest(api);
        GetJsonStringTest(api);
        GetJsonObjectTest(api);
        PostJsonStringTest(api);
        
        
    } //test1
    
    /**
      * Cocoa Json serialization tests
    */
    func test5() -> () {
        
        let epoch:NSTimeInterval = NSDate().timeIntervalSince1970;
        let epochInt64 = Int64(epoch);
        
        print( epochInt64 );
        
        let jsonObject : [String:AnyObject] = [
            "timestamp" : String(epochInt64),
            "item" : [
                "name" : "track"
            ]
        ];
        
        let valid = NSJSONSerialization.isValidJSONObject(jsonObject) // true
        
        
        print( "\(jsonObject)\nvalid:\(valid)" );
        print("\(jsonObject["timestamp"]) - \(jsonObject["item"]!["name"])");
        
        do {
            let jsonData:NSData =  try NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions.PrettyPrinted);
            print("\(jsonData)");
            
            let decoded = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject];
            print("\(decoded)");
            
        } catch _ {
            
        }
    } //test5
    
    /**
     * Swift.Dictionary tests
    */
    func test2() -> () {
        
        // A json dict
        let kv:[String:AnyObject!] = [
            "value" : 0,
            "item" : [
                "name" : "Innuendo",
                "artist" : "Queen"
            ]
            
        ];
        
        // Recursive list test
        var closure:( ([String:AnyObject!], acc:[String:AnyObject]) -> [String:AnyObject!])!
        closure = { (var x, var l) in
            if ( (x is Dictionary) ) { // leaf
                closure = nil;
                return x;
            } else {
                return closure(x, acc:l)
            }
        }
        
        var list:[String:AnyObject]! = [String:AnyObject]();
        let value = closure(kv,acc:list)
        print(value);
        
    } //test2
    
    /**
     * Linked List tests
    */
    func test4() ->() {
        
        // A json dict
        let k:[String:Int!] = [
            "value" : 0,
        ];
        
        // another json dict
        let kv:[String:AnyObject!] = [
            "value" : 0,
            "item" : [
                "name" : "Innuendo",
                "artist" : "Queen",
                "status" : true
            ]
        ];
        
        // Linked List Test
        let myList : List<AnyObject> = LinkedList(k,
            next: LinkedList(kv,
                next: NilList()))
        
        for item in myList {
            print("the item is \(item)")
        }
    
    } //test4
    
    /**
     * Generator Test (Hailstone case)
    */
    func test3() -> () {
        for (idx, hailstone) in Hailstone(start: 91773).enumerate() {
            print("hailstone #\(idx + 1) is: \(hailstone)")
            if hailstone == 1 {
                break
            }
        }
    } //test3
    
    /**
     * Run tests
    */
    func runTest() -> () {
        
        typealias MyClosure = (() -> ())
        typealias MyTuple = (f: MyClosure, on: Bool)

        let tests:[ MyTuple ] = [
            ( f: test1, on: true ),
            ( f: test2, on: false ),
            ( f: test3, on: false ),
            ( f: test4, on: false ),
            ( f: test5, on: false )
        ]
        
        for item in tests {
            if item.on {
                let f = item.f
                f()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runTest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

