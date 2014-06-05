// Playing with map, filter etc

/*

Restricted to Arrays for the moment unti I've worked out the Swift Collection hierarchy

*/

import UIKit
import Foundation

operator infix |> {associativity left precedence 140}
func |> <T,U> (left: @auto_closure () -> T,right: T -> U) -> U {
    return right(left())
}


func mapi<S,T>(f : (Int,S) -> T)(a : Array<S>) -> Array<T> {
    var result = Array<T>()
    for (index, value) in enumerate(a) {
        result.append(f(index,value))
    }
    return result
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



func choose<S,T>(f : S -> T?)(a : Array<S>) -> Array<T> {
    var result = Array<T>()
    for (index, value) in enumerate(a) {
        if let r = f(value) {
            result.append(r)
        }
    }
    return result
}

func m2(search: String)(a: String) -> String? {
    if a.rangeOfString(search, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
        let z : String? = a
        return z
    }
    else {
        return nil
    }
}

let m1 = {(a: Int,b: String) in "[\(a)]=\(b)"}
let s1 = m2("abc")
let m3 = {(s: String) -> Int in s.lengthOfBytesUsingEncoding(NSASCIIStringEncoding)}
let m4 = {(s: String) -> String in
    let split = s.componentsSeparatedByString("=")
    return "\(split[1]) at \(split[0])"
}


["abcd","aabbcc","aaabcabc","xyz"]
    |> mapi(m1)
    |> choose(s1)
    |> choose(m2("a"))
    |> map(m4)





