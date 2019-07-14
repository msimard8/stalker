//
//  ArticleSplitViewController.swift
//  Stalker
//
//  Created by Michael Simard on 7/13/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import UIKit

class ArticleSplitViewController: UISplitViewController {

    let articleContentViewController = ArticleContentViewController()
    var articleContentNavigationController:UINavigationController

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        articleContentNavigationController = UINavigationController(rootViewController: articleContentViewController)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let articleListViewController = ArticleListViewController()
        articleListViewController.view.backgroundColor = UIColor.white
        articleListViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: articleListViewController)
        navigationController.navigationBar.barTintColor = .black
        articleContentNavigationController.navigationBar.barTintColor = .black

        UIBarButtonItem.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.viewControllers = [navigationController,BlinkingEyeViewController()]

        self.preferredDisplayMode = .allVisible
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

extension ArticleSplitViewController :UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

extension ArticleSplitViewController : ArticleListViewControllerDelegate {

    func didSelectArticle(article: NewsArticle) {
        articleContentViewController.loadView()
        articleContentViewController.newsArticle = article
        articleContentNavigationController.popToRootViewController(animated: false)
        self.showDetailViewController(articleContentNavigationController, sender: self)
    }
}
