//
//  StalkerTests.swift
//  StalkerTests
//
//  Created by Michael Simard on 5/2/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import XCTest
@testable import Stalker

class StalkerTests: XCTestCase {

    var sampleResonseData: Any?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNewsResponseFormat() {
        let expectation = self.expectation(description: "network request")
        StalkerNetworkService.shared.fetchNews(subject: "bitcoin", page: 1) { (articles, response) in
            guard let json = response as? [String: Any] else {
                XCTAssert(false, "Data not returned as JSON")
                return
            }

            guard let articles = json["articles"] as? [[String: Any]] else {
                XCTAssert(false, "No Articles Array")
                return
            }
            guard let articleJSON = articles.first else {
                XCTAssert(false, "Empty Articles Array")
                return
            }

            XCTAssert (((articleJSON["title"] as? String) != nil), "title not a string or not in response")
            XCTAssert (((articleJSON["urlToImage"] as? String) != nil), "urlToImage is not a string or not in response")
            XCTAssert ((((articleJSON["source"] as? [String: Any])?["name"] as? String) != nil), "source and/or name not a string or in response")
            XCTAssert (((articleJSON["description"] as? String) != nil), "description not a string or not in response")
            XCTAssert (((articleJSON["publishedAt"] as? String) != nil), "publishedAt not a string or not in response")
            XCTAssert (((articleJSON["author"] as? String) != nil), "author is not a string or not in response")
            XCTAssert (((articleJSON["content"] as? String) != nil), "content is not a string or in response")
            XCTAssert (((articleJSON["url"] as? String) != nil), "url is not a string or not in response")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)

    }

    func testDateFormatter() {
        //given
        let date = "2019-04-09T16:28:18Z"
        //TODO: Eventually make date more dynamic (ie showing article was published x hours ago. Those tests can be done here)
        XCTAssert(Utils.formatDate(date: date) == "Apr 9, 2019, 12:28 PM")
    }

    func testDateFormatterPerformance() {
        let date = "2019-04-09T16:28:18Z"
        self.measure {
           (Utils.formatDate(date: date))
        }
    }
}
