//
//  ManagedOperation.swift
//  Pods
//
//  Created by jatoma on 29.01.2016.
//
//

import UIKit


extension NSOperationQueue {
    
    public typealias completionClosure = () -> ()
    
    static func createSequentalQueue( operations : Array<NSOperation>, completion : completionClosure?) -> (NSOperationQueue){
        return createQueue(operations, maxConcurrentOperationCount: 1, completion: completion);
    }
    
    static func createConcurrentQueue( operations : Array<NSOperation>, completion : completionClosure?) -> (NSOperationQueue){
        return createQueue(operations, maxConcurrentOperationCount: NSOperationQueueDefaultMaxConcurrentOperationCount, completion: completion);
    }
    
    
    static func createQueue( operations : Array<NSOperation>,maxConcurrentOperationCount : Int, completion : completionClosure?) -> (NSOperationQueue){
        let operationQue = NSOperationQueue()
         operationQue.maxConcurrentOperationCount = maxConcurrentOperationCount;
        
        var queueOperations = operations;
        
        if let completion = completion {
            let finishCallback = ManagedBlockOperation{  operation in
                operation.completed = true;
                completion();
            }
            
            for operation in queueOperations {
                finishCallback.addDependency(operation)
            }
            
            queueOperations = Array([operations, [finishCallback]].flatten());
        }
        
        operationQue.addOperations(queueOperations, waitUntilFinished: false)
        return operationQue;
    }
}

public class ManagedOperation: NSOperation {
    
 
    
    public var completed : Bool = false {
        willSet {
            self.willChangeValueForKey("isExecuting")
            self.willChangeValueForKey("isFinished")
        }
        didSet {
            self.didChangeValueForKey("isExecuting")
            self.didChangeValueForKey("isFinished")
        }
    }
    
    override public var executing: Bool {
        get {
            return !completed
        }
    }
    
    override public var finished: Bool {
        get {
            return completed
        }
    }
}
