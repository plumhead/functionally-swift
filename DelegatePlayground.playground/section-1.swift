
import UIKit

// Investigations on Protocols and function delegates


/*
 The accepted way of doing things
*/
protocol ProtoDelegate {
    func ProtoAction(msg : String)
}

class TestController : ProtoDelegate {
    func ProtoAction(msg: String) {
        println("Controller : \(msg)")
    }
}


class TestClass {
    var delegate : ProtoDelegate?
    
    func test() {
        delegate?.ProtoAction("Hello World using normal delegates")
    }
}



var x = TestClass()
x.test() // Nothing will be printed here as we haven't assigned a delegate yet
// Assign a delegate
x.delegate = TestController()
x.test()  // Prints : Controller : Hello World using normal delegates


/*
 Delegates as functions
*/

class TestClassFunction {
    var delegate : (String -> ())?  // an optional function taking a string parameter and returning nothing (void)
    
    func test() {
        delegate?("Hello world as a function delegate")
    }
    
}


var y = TestClassFunction()

y.test() // Print nothing as before as we don't have a delegate yet (but note use of optionals)

// Lets define our controller class again but without the protocol
class TestControllerFunction {
    func ProtoActionFunction(msg: String) {
        println("Function Controller : \(msg)")
    }
}

// Assign it to our delegate
let controller = TestControllerFunction()
y.delegate = controller.ProtoActionFunction   // Note no parameters
y.test() // Prints - Function Controller : Hello world as a function delegate

// Can we get away from having to define a controller?

// Lets just create a function and use that
func echo(msg: String) {
    println("Echo \(msg)")
}

y.delegate = echo
y.test() // Prints - Echo: Hello world as a function delegate

// Can we go one step further and simply assign a 'block'
y.delegate = {println($0)}
y.test() // Prints - Hello world as a function controller


/*
 Why might this be useful?
*/

// Lets suppose we have some requirement for a generic document
// Loosely based on the rather good example provided by Apple here -> https://developer.apple.com/library/prerelease/ios/samplecode/Lister/Introduction/Intro.html



class MyDocument<T> {
    var model : T?
    
    func doSomethingWithModel() {
        // do something with our model object
        if let m = model {
            println("Model is \(m)")
        }
        else {
            println("Model content isn't defined yet")
        }
    }
}

var m1 = MyDocument<Int>()
var m2 = MyDocument<String>()

m1.doSomethingWithModel() // Should print Model content isn't defined yet
m2.doSomethingWithModel() // Should print Model content isn't defined yet

m1.model = 123
m1.doSomethingWithModel() // Should print Model is 123
m2.model = "Hello"
m2.doSomethingWithModel() // Should print Model is Hello

// What if we wanted our doSomething function to notify a delegate about our model?
// What would a protocol look like

/* Commented as the compile errors seem to prevent the playground evaluating!

protocol ModelDelegate {
    func modelNotification(model : MyDocument) // this won't compile as we're lacking the type arguments
}

protocol ModelDelegate2 {
    func modelNotification(model: MyDocument<_>) // this won't compile as we can't 'ignore' the type
}

protocol ModelDelegate3<T> {
    func modelNotification(model: MyDocument<T>) // this won't compile - can't have generic protocols
}
*/

// We can do it with type aliases however
protocol ModelDelegate4 {
    typealias ModelType
    
    func modelNotification(model: ModelType)
}

class ModelDelegate4Controller<T> : ModelDelegate4 {
    func modelNotification(model: T) {
        println("Delegate: model is \(model)")
    }
}

// Lets update the MyDocument class to incorporate this
class MyDocument2<T> {
    var model : T?
    var delegate : ModelDelegate4Controller<T>?
    
    func doSomethingWithModel() {
        // do something with our model object
        if let m = model {
            delegate?.modelNotification(m)
        }
        else {
            println("Model content isn't defined yet")
        }
    }
}


var m3 = MyDocument2<Int>()

m3.doSomethingWithModel()
m3.model = 123
m3.doSomethingWithModel()

// Lets now try with our function based approach

class MyDocument3<T> {
    
    var model : T?
    var modelNotification : (T -> ())?
    
    func doSomethingWithModel() {
        // do something with our model object
        if let m = model {
            modelNotification?(m)
        }
        else {
            println("Model content isn't defined yet")
        }
    }
}

var m4 = MyDocument3<Int>()
m4.doSomethingWithModel() // Prints : Model content isn't defined yet
m4.model = 345
m4.doSomethingWithModel() // no output
m4.modelNotification = { println("Function: \($0)")}
m4.doSomethingWithModel() // Prints : Function: 345


// Finally, we'd probably actually setup a listener on the model itself for notifications

class MyDocument4<T> {
    var model : T? {
        didSet {
            modelNotification?(model)
        }
    }
    var modelNotification : (T? -> ())?
}

var m5 = MyDocument4<String>()
m5.model = "Hello" // no output
m5.modelNotification = {println($0)}
m5.model = "World" // Prints: Optional<"World">



































