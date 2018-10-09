//
//  ValleyDownloaderTests.swift
//  ValleyTests
//
//  Created by Luciano Bohrer on 08/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

import XCTest
@testable import Valley

class ValleyDownloaderTests: XCTestCase {

    private let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    private let bundle = Bundle.init(for: ValleyDownloaderTests.self)
    
    override func setUp() {
        Valley.setup(capacityInBytes: 2 * 1024 * 1024)
    }

    func testImageDownload() {
        let expectation = XCTestExpectation(description: "Wait for image")
        let url = bundle.url(forResource: "image-sample",
                             withExtension: "jpeg")?.absoluteString ?? ""
        
        // Check if there's not image set
        XCTAssertNil(self.imageView.image)
        
        imageView.valleyImage(url: url, onSuccess: { (_) in
            XCTAssertNotNil(self.imageView.image)
            expectation.fulfill()
        })
        // Since the request is async, I make this expectation
        wait(for: [expectation], timeout: 3)
    }
    
    func testJSONDownload() {
        let expectation = XCTestExpectation(description: "Wait for json")
        let url = bundle.url(forResource: "json-sample",
                             withExtension: "json")?.absoluteString ?? ""
        
        ValleyFile<[[String: Any]]>.request(url: url, completion: { (items) -> (Void) in
            XCTAssertTrue(items.count > 0)
            expectation.fulfill()
        })
        // Since the request is async, I make this expectation
        wait(for: [expectation], timeout: 3)
    }
    
    func testDataDownload() {
        let expectation = XCTestExpectation(description: "Wait for Data")
        let url = bundle.url(forResource: "image-sample",
                             withExtension: "jpeg")?.absoluteString ?? ""
        ValleyFile<Data>.request(url: url, completion: { (data) -> (Void) in
            XCTAssertNotNil(data)
            expectation.fulfill()
        })
        // Since the request is async, I make this expectation
        wait(for: [expectation], timeout: 3)
    }
    
    func testGenericError() {
        let expectation = XCTestExpectation(description: "Wait for error")
        imageView.valleyImage(url: "file://") { (error) in
            XCTAssert(error == .generic)
            expectation.fulfill()
        }
        
        // Since the request is async, I make this expectation
        wait(for: [expectation], timeout: 3)
    }
    
    func testParsingError() {
        let expectation = XCTestExpectation(description: "Wait for parsing error")
        let url = bundle.url(forResource: "image-sample",
                             withExtension: "jpeg")?.absoluteString ?? ""
        ValleyDownloader<[String: Any]>.request(urlString: url, onError: { (error) in
            XCTAssert(error == .invalidParse)
            expectation.fulfill()
        })?.resume()
        
        // Since the request is async, I make this expectation
        wait(for: [expectation], timeout: 3)
    }
    
    func testInvalidUrl() {
        let expectation = XCTestExpectation(description: "Wait for error")
        imageView.valleyImage(url: "google.com\\") { (error) in
            XCTAssert(error == .invalidUrl)
            expectation.fulfill()
        }
        
        // Since the request is async, I make this expectation
        wait(for: [expectation], timeout: 3)
    }
}
