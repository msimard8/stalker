//
//  ArticleListViewController.swift
//  Stalker
//
//  Created by Michael Simard on 5/2/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import UIKit

class ArticleListViewController: UIViewController {
    
    let maxArticleCount = 100 //(This is set by newsapi.org for dev accounts)
    
    @IBOutlet var tableView: UITableView!
    var articles:[NewsArticle] = []
    var lastPage = 0
    var loading:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reload(page:lastPage + 1)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload), for: UIControl.Event.valueChanged)
        self.tableView.refreshControl = refreshControl
        self.tableView.register(UINib(nibName: "ArticleListLoadMoreTableViewCell", bundle: nil), forCellReuseIdentifier: "load-more-cell")
        self.tableView.register(UINib(nibName: "ArticleListTableViewCell", bundle: nil), forCellReuseIdentifier: "article-cell")
    }
    
    @objc func reload(page:Int){
        if loading == false { //prevents duplicate loads if the user is on a slow network and scrolls up and down veyr fast
            loading = true
            StalkerNetworkService().fetchNews(subject: "Night King", page:page) { (articles) in
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.articles = self.articles + articles
                    self.tableView.reloadData()
                    self.lastPage += 1;
                    self.loading = false
                }
            }
        }
    }
}



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */




extension ArticleListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //the bottom cell will be a load more cell unless we hit the max number of articles
        switch articles.count {
        case 0:
            return 0
        case maxArticleCount:
            return articles.count
        default:
            return articles.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == articles.count) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "load-more-cell") else {
                return UITableViewCell()
            }
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "article-cell") else{
                return UITableViewCell()
            }
            cell.textLabel?.text = articles[indexPath.row].title ?? "No title"
            return cell
            
        }
    }
    
    
}

extension ArticleListViewController: UITableViewDelegate {
    
    //    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
    //        StalkerNetworkService().fetchNews(subject: "Night King") { (articles) in
    //            DispatchQueue.main.async {
    //                self.articles = self.articles ?? [] + articles
    //                self.tableView.reloadData()
    //            }
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let _ = cell as? ArticleListLoadMoreTableViewCell {
            reload(page: lastPage + 1)
        }
    }
}
