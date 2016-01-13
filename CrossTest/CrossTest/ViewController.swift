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
    
    func importDatabaseURL() -> NSURL? {
        
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
                    return nil
                }
                return finalDatabaseURL
            }
            return finalDatabaseURL
        }
        return nil
    }
    
    func databaseExecuteQuery(dbConn:SQLiteConnection, query:String) throws -> SQLiteQueryResult? {
        let RES:SQLiteQueryResult = dbConn.ExecuteQuery(query , nil);
        return RES;
    }
    
    func databaseAppTest() -> () {
        let fname = importDatabaseURL()?.absoluteString;
        print(fname);
        if let fpath = fname { // unwrap optional
            
            let dbConn:SQLiteConnection = SQLiteConnection.init(fpath, false, true); // name, readonly, createifneeded
            print(dbConn);
            
            let INSERT = "INSERT OR REPLACE INTO CACHE (cache_key, cache_value, timestamp) VALUES (\"USER\",\"LORETO\",\"20160111\");";
            
            dbConn.Execute(INSERT,nil);
            
            do {
                
                let SQL = "SELECT * from CACHE";
                let RES=try databaseExecuteQuery(dbConn, query: SQL);
                if let result:SQLiteQueryResult = RES { // unwrap optional
                    print("Columns " + String(result.ColumnCount));
                    print(result);
                    if ( !result.IsNull ) {
                        print( result.GetString( 0 ), result.GetString( 1 ), result.GetString( 2 ) );
                        while (  result.MoveNext() ) {
                            print( result.GetString( 0 ), result.GetString( 1 ), result.GetString( 2 ) );
                        }
                    }
                }
                
                
            } catch let error as SQLiteException {
                print("sql error");
                print(error.description)
            } catch let error as NSError {
                print("undefined error");
                print(error.description)
            }
        }
        else {
            let fname = createDatabaseURL()?.absoluteString;
            let dbConn:SQLiteConnection = SQLiteConnection.init(fname, false, true); // name, readonly, createifneeded
            let SQL = "CREATE TABLE IF NOT EXISTS CACHE (ID INTEGER PRIMARY KEY AUTOINCREMENT, CACHE_KEY TEXT UNIQUE, CACHE_VALUE TEXT, TIMESTAMP TEXT);";
            
            print(SQL);
            
            //var VALUES: AutoreleasingUnsafeMutablePointer<NSObject?> = nil;
            
            let INSERT = "INSERT OR REPLACE INTO CACHE (cache_key, cache_value, timestamp) VALUES (\"USER\",\"LORETO\",\"20160111\");";
            dbConn.ExecuteQuery(INSERT,nil);
            
        }
    }
    
    /**
     * Test Database
    */
    func databaseTest(api:SharedClassTest) -> () {
        
        api.databaseSetup();
        
    }
    
    /**
     * Test HTTP Call, Response handling with a Promise
     */
    func httpCallTest(api:SharedClassTest) -> () {
        let promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
            
            let apiEndpoint:String="https://api.spotify.com/v1/search?q=tania%20bowra&type=artist";
            api.httpCall(apiEndpoint, completion: { (response:String!) -> Void in
                resolve( response )
            });
        }
        promise.then { (value) -> () in
            // Probably doing something important with this data now
            print( value )
            }
            
            .catch_ { (error) -> () in
                // Display error message, log errors
            }
            .finally { () -> () in
                // Close connections, do cleanup
        }
    }
    
    func test1() -> () {
        
        let api:SharedClassTest = SharedClassTest();
        
        databaseTest(api);
        databaseAppTest();
        
        httpCallTest(api);
        
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

