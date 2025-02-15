//
//  A2HiresViewerTests.swift
//  A2HiresViewerTests
//
//  Created by Shunichi Kitahara on 2025/02/11.
//

import XCTest
@testable import A2HiresViewer

final class A2HiresViewerTests: XCTestCase {
    func testPixcel() {
       
        let colorA1 : [NSColor]
        colorA1 = [.black, .green, .black, .green, .black, .green, .black]
        XCTAssertEqual(AppleIIHiresImage.decodePixelColors(from: 0x2a, xBlock: 0), colorA1)
        // green left 1
        let colorA2 : [NSColor]
        colorA2 = [.black, .green, .black, .black, .black, .black, .black]
        XCTAssertEqual(AppleIIHiresImage.decodePixelColors(from: 0x02, xBlock: 0), colorA2)
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
