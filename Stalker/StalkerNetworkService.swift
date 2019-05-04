//
//  NetworkService.swift
//  Stalker
//
//  Created by Michael Simard on 5/2/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import Foundation
import AFNetworking

class NewsNetworkService: NSObject {

    let newsAPIURL = "https://newsapi.org/v2/everything"
    let newsAPIKey = "50600433afee4b1db1c36a8fe9745da4"

    let manager = AFHTTPSessionManager()
    func fetchNews(subject:String){
        
        let parameters = ["q":subject,
                          "apiKey":newsAPIKey,
                          "":"" ]
        
        manager.get(newsAPIURL, parameters: parameters, progress: { (progress) in
            
        }, success: { (sessionDataTask, response) in
            
        }) { (sessionDataTask, error) in
        
        }
    }
    
}
