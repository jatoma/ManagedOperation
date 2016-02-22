//
//  SampleAsyncOperation.swift
//  ManagedOperation
//
//  Created by jatoma on 19.02.2016.
//

import UIKit

class SampleAsyncOperation: ManagedOperation {

    
     override func start() {
        
        //Sample Async Task
        NSThread.sleepForTimeInterval(1.0)
        
        self.completed = true;
    }
}
