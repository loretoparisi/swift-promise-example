//
//  ViewController.swift
//  CrossTest
//
//  Created by Loreto Parisi on 11/12/15.
//  Copyright © 2015 Musixmatch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    
        let promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
            
            let pippo:MiaClasse2 = MiaClasse2();
            pippo.httpCall( "https://api.spotify.com/v1/search?q=tania%20bowra&type=artist" ) { (response:String!) in
                resolve( response )
            };
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

