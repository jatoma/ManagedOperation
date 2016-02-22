//
//  ManagedBlockOperation.swift
//  ManagedOperation
//
//  Created by jatoma on 19.02.2016.
//

import UIKit

public class ManagedBlockOperation: ManagedOperation {
    public typealias Closure = (ManagedOperation) -> ()
    let closure: Closure
    
    
    public init(closure: Closure) {
        self.closure = closure
    }
    
    public override func start() {
         self.closure(self)
    }
    
}
