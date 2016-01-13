//
//  ObjectFactory.swift
//  SwiftFactory
//
//  Created by Joshua Smith on 6/4/14.
//  Modified by Loreto Parisi on 12/15.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

/*
This class requires:
#import "OBJCObjectFactory.h"
in your project's bridging header file.

Usage:
let store = OBJCObjectFactory.create("UIViewController")
*/

import Foundation

/** Instantiates NSObject subclasses by name. */
class ObjectFactory<TBase: NSObject>
{
    /**
    Returns a new instance of the specified class,
    which should be `TBase` or a subclass thereof.
    Uses the parameterless initializer.
    */
    class func createInstance(className className: String!) -> TBase?
    {
        return OBJCObjectFactory.create(className) as! TBase?
    }
    
    /**
    Returns a new instance of the specified class,
    which should be `TBase` or a subclass thereof.
    Uses the specified single-parameter initializer.
    */
    class func createInstance(
        className className:  String!,
        initializer: Selector!,
        argument:    AnyObject) -> TBase?
    {
        return OBJCObjectFactory.create(
                         className,
            initializer: initializer,
            argument:    argument) as! TBase?
    }
    
    func tryCatch(closure: () -> (), convertNSException:(NSException!)->(NSError!)) -> NSError {
        return OBJCObjectFactory.tryCatch(closure, convertNSException: convertNSException);
    }
}
