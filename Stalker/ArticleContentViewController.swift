//
//  ArticleContentViewController.swift
//  Stalker
//
//  Created by Michael Simard on 5/4/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import UIKit

class ArticleContentViewController: UIViewController {
    
    let imageViewBannerHeight:CGFloat = 200
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    
    var newsArticle:NewsArticle? = nil {
        didSet {
            titleLabel.text = newsArticle?.title ?? ""
            sourceLabel.text = newsArticle?.source ?? ""
            authorLabel.text = newsArticle?.author ?? ""
            contentTextView.text = newsArticle?.content ?? ""
            descriptionLabel.text = newsArticle?.articleDescription ?? ""
            imageViewHeightConstraint.constant = newsArticle?.urlToImage != "" ? imageViewBannerHeight : 0
         }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action:   #selector(didTapAction(sender:)))
        
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
    }
    
    
    @objc func didTapAction(sender:UIBarButtonItem){
        print ("aha")
    }
    
    private func highlightSubject(subject:String){
        
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
