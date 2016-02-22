//
//  ManagedOperationTests.swift
//  ManagedOperationTests
//
//  Created by jatoma on 19.02.2016.
//

import XCTest
@testable import ManagedOperation

class ManagedOperationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func synced(lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    
    func createBlockManagedOperations(count : Int,operationBlock : (ManagedOperation) -> (), completionBlock : () -> ()) -> [NSOperation]{
        var operations = [NSOperation]();
        for _ in 0..<count {
            let asyncOperation = ManagedBlockOperation(closure: operationBlock)
            asyncOperation.completionBlock = completionBlock;
            operations.append(asyncOperation);
        }
        return operations;
    }

    func testConcurrentQueueOfManagedOperations() {
        
        var completedOperationsCount = 0;
        
        let operations = self.createBlockManagedOperations(1000,
            
            operationBlock: { operation in
                operation.completed = true;
            }, completionBlock: { [weak self] in
                
                self!.synced(self!, closure: { () -> () in
                    completedOperationsCount += 1;
                });
            });
        
        
        let expectation = expectationWithDescription("concurrent queue")
        
        let _ = NSOperationQueue.createConcurrentQueue(operations) { () -> () in
            expectation.fulfill();
        }
        
        self.waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error, "Timeout Error");
            XCTAssert(operations.count == completedOperationsCount, "Error in completed operations count expected: \(operations.count) has result:\(completedOperationsCount)" )
        }
        
        
    }
    
    func testSequentalQueueOfManagedOperations() {
        
        var completedOperationsCount = 0;
       
        let operations = self.createBlockManagedOperations(1000,
            
            operationBlock: { operation in
                operation.completed = true;
            }, completionBlock: {
               completedOperationsCount += 1;
            });
        
        let expectation = expectationWithDescription("Sequental queue ")
        let _ = NSOperationQueue.createSequentalQueue(operations) { () -> () in
            expectation.fulfill();
        }
        
        self.waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error, "Timeout Error");
            XCTAssert(operations.count == completedOperationsCount, "Error in completed operations count expected: \(operations.count) has result:\(completedOperationsCount)" )
        }
    }
    
    
    func testSampleAsyncOperation(){
        
        let sampleAsyncOperation = SampleAsyncOperation();
        
        let expectation = expectationWithDescription("async operation")
        let _ = NSOperationQueue.createSequentalQueue([sampleAsyncOperation]) { () -> () in
            expectation.fulfill();
        }
        
        self.waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error, "Timeout Error");
        }
    }

    
}
