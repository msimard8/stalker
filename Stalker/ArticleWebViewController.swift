//
//  ArticleWebViewController.swift
//  Stalker
//
//  Created by Michael Simard on 7/13/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import UIKit
import WebKit

class ArticleWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    var articleUrlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let urlString = articleUrlString {
            if let url =  URL(string: urlString) {
            webView.load(URLRequest(url: url))
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        webView.stopLoading()
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
