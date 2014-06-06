//
//  Async.swift
//  TestSwiftUI
//
//  Created by Plumhead on 06/06/2014.
//
// There are many holes in this which will be ironed out over time - put up as a starting point for ideas
//

import Foundation

enum AwaitResult<T> {
    case Success(a : T)
    case Timeout
}

typealias Ctx = dispatch_group_t


operator infix ! {associativity left precedence 140}
func ! <T> (ctx: Ctx,f: () -> T) -> T {
    var result : (() -> T)?
    
    dispatch_group_async(ctx,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        println("pre task")
        sleep(5)
        result = {f()}
        println("post task")
        })
    dispatch_group_wait(ctx, DISPATCH_TIME_FOREVER)
    
    return result!()
}

class Async {
    
    class func async<T>(f : Ctx -> T)(ctx: Ctx) -> T {
        println("Running Async!!!")
        return f(ctx)
    }
    
    class func RunAsynchronously<T>(f: Ctx -> T) -> AwaitResult<T> {
        var result : AwaitResult<T> = .Timeout
        let group = dispatch_group_create()
        
        dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            println("RunAsync Starting")
            sleep(5)
            let childgroup = dispatch_group_create()
            let r = f(childgroup)
            dispatch_group_wait(childgroup, DISPATCH_TIME_FOREVER)
            result = AwaitResult.Success(a:r)
            println("RunAsync Ending")
            })
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        
        return result
    }
    
    class func test() {
        func f3(name : String) -> Int {return name.lengthOfBytesUsingEncoding(NSASCIIStringEncoding)}
        
        let f1 = async {
            (ctx : Ctx) -> Int in
            
            let a = ctx ! {10}
            let b = ctx ! {20}
            let c = ctx ! {f3("Andy Calderbank")}
            
            println("Finished Running Async Block with result =\(a+b+c)")
            return a + b + c
        }
        
        let result = Async.RunAsynchronously(f1)
        
        switch result {
        case let .Success(a) : println ("Success with result=\(a)")
        case .Timeout : println("Timeout")  // NOT IMPLEMENTED YET!
        }
    }
}