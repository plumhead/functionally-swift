// Playground - noun: a place where people can play

import UIKit
import Foundation

/*
None of this is working - will be coming back to it to work out whats possible.
*/

operator prefix --> {}
@prefix func --> <T> (f: () -> Optional<T>) -> Optional<T> {
    return .None
}

func maybe<T>(a: Array<(() -> Optional<T>)>) -> Optional<T> {
    for (index,value) in enumerate(a) {
        if let r = value() {
            continue
        }
        
        return Optional.None
    }
    
    return Optional.None
}

maybe([
    // {Optional.None},
    {Optional.Some(123)},
    {Optional.Some("andy")}
    ])




