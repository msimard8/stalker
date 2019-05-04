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
    let searchSubject = "The Night King"
    
    let stalkerNetworkService = StalkerNetworkService()
    @IBOutlet var tableView: UITableView!
    var articles:[NewsArticle] = []
    var lastPage = 0
    var loading:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 110
        self.reload(page:lastPage + 1)
        let refreshControl = UIRefreshControl()
        //  refreshControl.addTarget(self, action: #selector(reload), for: UIControl.Event.valueChanged)
        self.tableView.refreshControl = refreshControl
        self.tableView.register(UINib(nibName: "ArticleListLoadMoreTableViewCell", bundle: nil), forCellReuseIdentifier: "load-more-cell")
        self.tableView.register(UINib(nibName: "ArticleListTableViewCell", bundle: nil), forCellReuseIdentifier: "article-cell")
        self.title = searchSubject
    }
    
    @objc func reload(page:Int){
        if loading == false { //prevents duplicate loads if the user is on a slow network and scrolls up and down veyr fast
            loading = true
            stalkerNetworkService.fetchNews(subject: searchSubject, page:page) { (articles) in
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    let previousArticlesCount = self.articles.count
                     self.articles = self.articles + articles
                  
                    //only reload new articles for smoothness
                    
                    var newIndexPaths:[IndexPath] = []
                    for i in previousArticlesCount...previousArticlesCount + articles.count-1 {
                        newIndexPaths.append(IndexPath(row: i, section: 0))
                    }
                    //the load more cell if we are under the max articles
                    
                    if self.articles.count < self.maxArticleCount {
                        if (self.tableView.numberOfRows(inSection: 0) == previousArticlesCount){//only add load more cell if its not there before
                            newIndexPaths.append(IndexPath(row:self.articles.count, section: 0))
                        }
                    }
                    else if self.articles.count == self.maxArticleCount{
                        newIndexPaths.removeLast() //no more articles, no need to show the load more cell
                    }
                    
                  
                    self.tableView.insertRows(at: newIndexPaths, with: .fade)
 
                    
                    
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "article-cell") as? ArticleListTableViewCell else{
                return UITableViewCell()
            }
            let article =  articles[indexPath.row]
            cell.newsArticle = article
            return cell
        }
    }
    
    private func downloadImage( urlString:String, indexPath:IndexPath){
        stalkerNetworkService.fetchThumbnailImage(urlString: urlString) { (image, error) in
            DispatchQueue.main.async {
                if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                    if let thumbnailImage = image {
                        (self.tableView.cellForRow(at: indexPath) as? ArticleListTableViewCell)?.thumbnailImageView.image = thumbnailImage
                        (self.tableView.cellForRow(at: indexPath) as? ArticleListTableViewCell)?.thumbnailImageView.backgroundColor = .clear
                    }
                    else {
                        (self.tableView.cellForRow(at: indexPath) as? ArticleListTableViewCell)?.thumbnailImageView.image = nil
                        (self.tableView.cellForRow(at: indexPath) as? ArticleListTableViewCell)?.backgroundColor = .red
                        
                    }
                }
            }
            
        }
    }
}

extension ArticleListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let articleCell = cell as? ArticleListTableViewCell {
            
            if let urlImage = articleCell.newsArticle?.urlToImage {
                articleCell.thumbnailImageView.backgroundColor = .lightGray
                downloadImage(urlString: urlImage, indexPath: indexPath)
            }
        
            
        }
        if let _ = cell as? ArticleListLoadMoreTableViewCell {

            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                self.reload(page: self.lastPage + 1)

            }
        }
    }
}
