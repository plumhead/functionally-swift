// Swift Pipes!

import Foundation

operator infix |> {associativity left precedence 140}
func |> <T,U> (left: @auto_closure () -> T,right: T -> U) -> U {
    return right(left())
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














