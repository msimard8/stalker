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
    @IBOutlet weak var eyeView: EyeView!
    @IBOutlet weak var loadingLabel: UILabel!

    var articleUrlString: String?

    override func viewDidLoad() {
        webView.navigationDelegate = self
        super.viewDidLoad()
        if let urlString = articleUrlString {
            if let url =  URL(string: urlString) {
            webView.load(URLRequest(url: url))
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eyeView.animate()
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

extension ArticleWebViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.eyeView.isHidden = true
            self.loadingLabel.isHidden = true
        }
    }
}
