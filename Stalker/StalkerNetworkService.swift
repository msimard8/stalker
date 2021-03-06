//
//  NetworkService.swift
//  Stalker
//
//  Created by Michael Simard on 5/2/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import Foundation
import AFNetworking

class StalkerNetworkService: NSObject {

    internal static var shared: StalkerNetworkService = {
        let instance = StalkerNetworkService()
        return instance
    }()

    private let newsAPIURL = "https://newsapi.org"
    private let newsAPIKey = "50600433afee4b1db1c36a8fe9745da4"

    private let manager = AFHTTPSessionManager(baseURL: URL(string: "https://newsapi.org"))
    private let imageDownloader = AFImageDownloader()

    func fetchThumbnailImage(urlString: String, completion: @escaping ((_ image: UIImage?, _ error: Error?) -> Void)) {

        guard let imageURL = URL(string: urlString) else {
            completion(nil, NSError.init(domain: "Bad URL", code: 0, userInfo: nil))
            return
        }
        imageDownloader.downloadImage(for: URLRequest(url: imageURL), success: { (_, _, image) in
            completion(image, nil)
        }, failure: { (_, _, error) in
            completion(nil, error)
        })
    }

    func fetchNews(subject: String, page: Int, completion: @escaping((_ articles: [NewsArticle], _ networkResponse: Any?) -> Void)) {

        let parameters = ["q": subject,
                          "apiKey": newsAPIKey,
                          "page": "\(page)"
        ]

        manager.get("/v2/everything", parameters: parameters, progress: { (_) in

        }, success: { (_, response: Any?) in
            guard let json = response as? [String: Any] else {
                return
            }

            guard let articles = json["articles"] as? [[String: Any]] else {
                return
            }

            var newsArticles: [NewsArticle] = []
            for articleJSON in articles {
                newsArticles.append(NewsArticle(
                    title: articleJSON["title"] as? String,
                    urlToImage: articleJSON["urlToImage"] as? String,
                    source: (articleJSON["source"] as? [String: Any])?["name"] as? String,
                    articleDescription: articleJSON["description"] as? String,
                    publishedAt: articleJSON["publishedAt"] as? String,
                    author: articleJSON["author"] as? String,
                    content: articleJSON["content"] as? String,
                    articleLink: articleJSON["url"] as? String
                    ))
            }
            completion(newsArticles, response )
        }, failure: { (_, error) in
            print (error)
        })
    }
}
