import XCTest
@testable import SwiftObserver

class PromiseTests: XCTestCase
{
    func testThatPromiseCanBeFulfilledAsynchronously()
    {
        let promise = Promise<Void>()
        
        let promiseFulfilled = expectation(description: "promise is fulfilled")
        
        let observer = TestObserver()
        
        observer.observe(promise)
        {
            promiseFulfilled.fulfill()
        }
        
        DispatchQueue.main.async { promise.fulfill(()) }
        
        waitForExpectations(timeout: 3)
    }
    
    func testThatPromiseProvidesValueAsynchronously()
    {
        let promise = Promise<Int>()
        
        let valueReceived = expectation(description: "did reveive value from promise")
        
        promise.whenFulfilled
        {
            XCTAssertEqual($0, 42)
            valueReceived.fulfill()
        }
        
        DispatchQueue.main.async { promise.fulfill(42) }
        
        waitForExpectations(timeout: 3)
    }
    
    func testThatFulfilledPromiseProvidesValueSynchronously()
    {
        let promise = Promise<Int>()
        
        promise.fulfill(42)
        
        var valueReceived = false
        
        promise.whenFulfilled
        {
            XCTAssertEqual($0, 42)
            valueReceived = true
        }
        
        XCTAssert(valueReceived)
    }
    
    class TestObserver: Observer
    {
        let receiver = Receiver()
    }
}