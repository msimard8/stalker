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
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    //CACHE
    func testStoreAndRetreiveImage(){
        ImageCache.shared.storeImage(key: "image", image: UIImage.emptyImage(with: CGSize(width: 20, height: 20))!)
        XCTAssert(((ImageCache.shared.retrieveImage(key: "image")) != nil), "Image not found after storage")
    }

    func testRetrieveNonExistentImage () {
        XCTAssert(((ImageCache.shared.retrieveImage(key: "image")) == nil), "returned image when expecting none")
    }


    //NETWORKING
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

    //UTILS
    func testDateFormatter() {
        //given
        let date = "2019-04-09T16:28:18Z"
        //TODO: Eventually make date more dynamic (ie showing article was published x hours ago. Those tests can be done here)
        XCTAssert(Utils.formatDate(date: date) == "Apr 9, 2019, 12:28 PM")
    }

    func testStalkerNameStore() {
        UserDefaults.standard.setValue("", forKey: Utils.stalkerNameKey)
        let stalkerName = "Jon Snow"
        Utils.stalkerName = stalkerName
        let userDefaultsStalkerName = UserDefaults.standard.value(forKey: Utils.stalkerNameKey) as? String ?? ""
        UserDefaults.standard.synchronize()
        XCTAssert(userDefaultsStalkerName == stalkerName, "Stalker name does not match what is stored")
    }

    func testStalkerNameRetrieval() {
        UserDefaults.standard.setValue("Jon Snow", forKey: Utils.stalkerNameKey)
        let retrievedStalkerName = Utils.stalkerName
        UserDefaults.standard.synchronize()
        XCTAssert(retrievedStalkerName == "Jon Snow", "Stalker name does not match what is stored")
    }

    func testDateFormatterPerformance() {
        let date = "2019-04-09T16:28:18Z"
        self.measure {
           let _ = (Utils.formatDate(date: date))
        }
    }
}

//source https://stackoverflow.com/questions/14594782/how-can-i-make-an-uiimage-programmatically
//used for testing cacheing
extension UIImage {
    static func emptyImage(with size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
