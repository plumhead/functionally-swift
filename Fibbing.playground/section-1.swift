// Playground - noun: a place where people can play

import UIKit
import Foundation

operator infix |> {associativity left precedence 140}
func |> <T,U> (left: @auto_closure () -> T,right: T -> U) -> U {
    return right(left())
}


func map<S,T>(f : S -> T)(a : Array<S>) -> Array<T> {
    var result = Array<T>()
    for (index, value) in enumerate(a) {
        result.append(f(value))
    }
    return result
}


func filter<S>(f : S -> Bool)(a : Array<S>) -> Array<S> {
    var result = Array<S>()
    for (index, value) in enumerate(a) {
        if f(value) {
            result.append(value)
        }
    }
    return result
}



/* Source: Wikipedia - an F# Fib example
/// Fibonacci Number formula
let rec fib n =
match n with
| 0 | 1 -> n
| _ -> fib (n - 1) + fib (n - 2)

// Print even fibs
[1 .. 10]
|> List.map     fib
|> List.filter  (fun n -> (n % 2) = 0)
|> printList

*/

func fib(n : Int) -> Int {
    if n == 0 || n == 1 {
        return n
    }
    else {
        return fib(n - 1) + fib(n - 2)
    }
}

let output = {(n: Array<Int>) -> () in
    for (index,value) in enumerate(n) {
        println("[\(index)] is \(value)")
    }
}


[1,2,3,4,5,6,7,8,9,10]
    |> map(fib)
    |> filter({$0 % 2 == 0})
    |> output

