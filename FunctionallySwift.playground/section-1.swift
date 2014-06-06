// Swift Pipes!

import Foundation

operator infix |> {associativity left precedence 140}
func |> <T,U> (left: @auto_closure () -> T,right: T -> U) -> U {
    return right(left())
}

operator infix <| {associativity left precendence 140}
func <| <T> (ctx: dispatch_group_t,f: @auto_closure () -> T) -> T {
    var result : T
    
    dispatch_group_async(ctx,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        println("pre task")
        sleep(5)
        result = f()
        println("post task")
        })
    dispatch_group_wait(ctx, DISPATCH_TIME_FOREVER)
    
    return result
}

func add(n1 : Int)(n2: Int) -> Int {return n1 + n2}
let addone = add(1)
let addtwo = add(2)
let a1 = addone(n2:10) |> addone |> addtwo
let a2 = 1
        |> addone
        |> {$0 + 1}
        |> {(n : Int) -> Int in return n * 2}
        |> addtwo

"andy" |> {"hello \($0)"} |> println

func async(a : Int -> Int)(b : Int) -> (() -> Int) {
    return {a(b)}
}

let z = async {
    (v : Int) -> Int in
    v * 2
}

let z1 = z(b: 10)
z1()












