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

    let newsAPIURL = "https://newsapi.org"
    let newsAPIKey = "50600433afee4b1db1c36a8fe9745da4"

    let manager = AFHTTPSessionManager(baseURL: URL(string: "https://newsapi.org"))
   
    
    func fetchNews(subject:String, page:Int, completion:@escaping ((_ articles:[NewsArticle])->())){
        
        let parameters = ["q":subject,
                          "apiKey":newsAPIKey,
                          "page":"\(page)"
                           ]
        
        manager.get("/v2/everything", parameters: parameters, progress: { (progress) in
            
        }, success: { (sessionDataTask, response) in
             guard let json = response as? [String:Any] else {
                return
            }
            
            guard let articles = json["articles"] as? [[String:Any]] else {
                return
            }
            
            var newsArticles:[NewsArticle] = []
            
            for articleJSON in articles{
               newsArticles.append(NewsArticle(title: articleJSON["title"] as? String))
            }
            
            completion(newsArticles)
            print (newsArticles)
            
        }) { (sessionDataTask, error) in
        
            print (error)
        }
    }
    
}
