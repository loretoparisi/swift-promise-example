//
//  OBJCObjectFactory.m
//  SwiftFactory
//
//  Created by Joshua Smith on 6/4/14.
//  Modified by Loreto Parisi on 12/15.
//  Copyright (c) 2014 iJoshSmith. All rights reserved.
//

#import "OBJCObjectFactory.h"

static id OBJCInitWithArg(id  target,
                          SEL initializer,
                          id  argument)
{
    IMP imp = [target methodForSelector:initializer];
    id (*initFunc)(id, SEL, id) = (void *)imp;
    return initFunc(target, initializer, argument);
}

@implementation OBJCObjectFactory

+ (id)create:(NSString *)className
{
    return [NSClassFromString(className) new];
}

+ (id)create:(NSString *)className
 initializer:(SEL)init
    argument:(id)arg
{
    Class class = NSClassFromString(className);
    return (class && init)
    ? OBJCInitWithArg([class alloc], init, arg)
    : nil;
}

+ (NSError*)tryCatch:(void (^)())tryBlock convertNSException:(NSError *(^)(NSException *))convertNSException
{
    NSError *error = nil;
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        error = convertNSException(exception);
    }
    @finally {
        return error;
    }
}

@end
