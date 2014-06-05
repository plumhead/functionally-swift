// Playing with Swift and GCD

import UIKit
import Foundation


//let queue = dispatch_queue_create("com.plumhead",nil)

/*
func actionHandler1() -> () {
    let name = "andy"
    println("[ACTION] action name is \(name)")
}
*/

// This simple example doesn't work in the playground - lots of console exception trace - but does work quite happily in the iOS simulator.

/*
let queue = dispatch_queue_create("com.plumhead",nil)
func actionFunc() -> () {println("[ACTION] - function executed")}
let actionBlock = { () -> () in
    actionFunc()
    println("[ACTION] - block executed")
}
for i in 1..5 {
    dispatch_async(queue, actionBlock)
}
*/
enum AwaitResult<T> {
    case Success(a : T)
    case Timeout
}

func await<T>(f : () -> T) -> AwaitResult<T> {
    var result : AwaitResult<T> = .Timeout
    let group = dispatch_group_create()
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        println("Task Starting")
        sleep(5)
        let r = f()
        result = AwaitResult.Success(a:r)
        println("Task Ending")
        return ()
        })
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
    return result
}

func mytask() -> String {return "Andy Calderbank"}
let a = mytask()

println("Await is starting")
let result = await({() -> String in mytask()})
switch result {
case let .Success(r) : println("Result returned was \(r)")
case .Timeout : println("No result returned")
}
println("Await is finished")



