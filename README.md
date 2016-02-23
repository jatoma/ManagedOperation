# ManagedOperation
`ManagedOperation` is implementation of a `NSOperation` to abstract and deal with asynchronous tasks.

Let's assume you have a time-consuming task that you'd rather perform on a background-thread.  
**ManagedOperation** provides you with two options for wrapping  task in an asynchronous `NSOperation`:

### Using `ManagedBlockOperation`:

```swift
let asyncOperation = ManagedBlockOperation() { operation in
  	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
		// perform time-consuming task
		operation.completed = true
	}
}
```


### Subclassing `ManagedOperation`:

```swift
class SampleAsyncOperation : ManagedOperation {
	override func start() {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
      // perform time-consuming task
      self!.completed = true
    }
}
```

Additionally there is extension of 'NSOperationQueue' to easily create:

### Sequential queue
operations are performed one after the other in the order from list
```swift
 let operations = [SampleAsyncOperation(),SampleAsyncOperation()];
 
 let _ = NSOperationQueue.createSequentalQueue(operations) { () -> () in
      //called when all NSOperations are completed.
  }
```

### Concurrent queue 
operations are performed in concurrent way
```swift
 let operations = [SampleAsyncOperation(),SampleAsyncOperation()];
 
 let _ = NSOperationQueue.createConcurrentQueue(operations) { () -> () in
      //called when all NSOperations are completed.
  }
```

see `ManagedOperationTests.swift` for example usages.

## License
ManagedOperation is released under the [MIT License](http://www.opensource.org/licenses/MIT).
