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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let selectStalkerViewController = SelectStalkerViewController()
        let navigationController = UINavigationController(rootViewController: selectStalkerViewController)

                if Utils.stalkerName != "" {
                    let articleListViewController = ArticleListViewController()
                    navigationController.pushViewController(articleListViewController, animated: false)
                    articleListViewController.view.backgroundColor = UIColor.white
                    articleListViewController.delegate = self
                 }

        navigationController.navigationBar.barTintColor = .black

        UIBarButtonItem.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.viewControllers = [navigationController,articleContentViewController]

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



    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
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

    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {

    }
//    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
//        if let articleContentViewController = vc as? ArticleContentViewController {
//            return articleContentViewController.newsArticle != nil
//    }
//        return true 
//    }
}

extension ArticleSplitViewController : ArticleListViewControllerDelegate {

    func didSelectArticle(article: NewsArticle) {
       // articleContentViewController.loadView()
        articleContentViewController.newsArticle = article
        self.showDetailViewController(articleContentViewController, sender: self)
    }
}
