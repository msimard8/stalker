//
//  ArticleListViewController.swift
//  Stalker
//
//  Created by Michael Simard on 5/2/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import UIKit

class ArticleListViewController: UIViewController {

    let cellHeight: CGFloat = 150
    let cellExpandedHeight: CGFloat = 200
    var expandedIndexPaths: [IndexPath] = []
    let headerHeight: CGFloat = 200

    let maxArticleCount = 100 //(This is set by newsapi.org for dev accounts)
    let searchSubject = "Yzerman"
    let thumbnailCache = NSCache<NSString, UIImage>()

    @IBOutlet var tableView: UITableView!
    var articles: [NewsArticle] = []
    var lastPage = 0
    var loading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = cellHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        let refreshControl = UIRefreshControl()
        //  refreshControl.addTarget(self, action: #selector(reload), for: UIControl.Event.valueChanged)
        self.tableView.refreshControl = refreshControl
        self.tableView.register(UINib(nibName: "ArticleListLoadMoreTableViewCell", bundle: nil),
                                forCellReuseIdentifier: ArticleListLoadMoreTableViewCell.identifier)
        self.tableView.register(UINib(nibName: "ArticleListTableViewCell", bundle: nil),
                                forCellReuseIdentifier: ArticleListTableViewCell.identifier)
        self.tableView.register(UINib(nibName: "ArticleListHeaderView", bundle: nil),
                                forHeaderFooterViewReuseIdentifier: ArticleListHeaderView.identifier)
        self.title = searchSubject
        thumbnailCache.countLimit = maxArticleCount

        self.reload(page: lastPage + 1)
    }

    override func didReceiveMemoryWarning() {
        thumbnailCache.removeAllObjects()
    }

    @objc func reload(page: Int) {
        if loading == false { //prevents duplicate loads on slow networks
            loading = true
            StalkerNetworkService.shared.fetchNews(subject: searchSubject, page: page) { (articles) in
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    let previousArticlesCount = self.articles.count
                    self.articles += articles

                    //only reload new articles for smoothness
                    var newIndexPaths: [IndexPath] = []
                    for idx in previousArticlesCount...previousArticlesCount + articles.count-1 {
                        newIndexPaths.append(IndexPath(row: idx, section: 0))
                    }
                    //the load more cell if we are under the max articles
                    if self.articles.count < self.maxArticleCount {
                        //only add load more cell if its not there before
                        if self.tableView.numberOfRows(inSection: 0) == previousArticlesCount {
                            newIndexPaths.append(IndexPath(row: self.articles.count, section: 0))
                        }
                    } else if self.articles.count == self.maxArticleCount {
                        newIndexPaths.removeLast() //no more articles, no need to show the load more cell
                    }

                    self.tableView.insertRows(at: newIndexPaths, with: .fade)
                    self.lastPage += 1
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
        if indexPath.row == articles.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListLoadMoreTableViewCell.identifier) else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListTableViewCell.identifier) as? ArticleListTableViewCell else {
                return UITableViewCell()
            }
            let article =  articles[indexPath.row]
            cell.newsArticle = article
            cell.selectionStyle = .none
            cell.expanded = self.expandedIndexPaths.contains(indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ArticleListHeaderView.identifier) as? ArticleListHeaderView {
            headerView.titleLabel.text = ("  \(searchSubject)  ")
            return headerView
        }
        return nil
    }

    private func downloadImage(urlString: String, indexPath: IndexPath) {
        StalkerNetworkService.shared.fetchThumbnailImage(urlString: urlString) { (image, error) in
            if error == nil {
                DispatchQueue.main.async {
                    let articleListTableViewCell = self.tableView.cellForRow(at: indexPath) as? ArticleListTableViewCell
                    if let thumbnailImage = image {
                        self.thumbnailCache.setObject(thumbnailImage, forKey: urlString as NSString)

                        let articleListHeaderView = self.tableView.headerView(forSection: 0) as? ArticleListHeaderView
                        if articleListHeaderView?.backgroundImageView.image == nil {
                            articleListHeaderView?.backgroundImageView.image = image
                        }
                        articleListTableViewCell?.thumbnailImageView.image = thumbnailImage
                        articleListTableViewCell?.thumbnailImageView.backgroundColor = .clear
                    } else {
                        articleListTableViewCell?.thumbnailImageView.image = nil
                        articleListTableViewCell?.thumbnailImageView.backgroundColor = .clear
                    }
                }
            }
        }
    }
}

extension ArticleListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let articleCell = cell as? ArticleListTableViewCell {
            articleCell.delegate  = self
            if let urlImage = articleCell.newsArticle?.urlToImage {
                articleCell.thumbnailImageView.backgroundColor = .lightGray
                if let cachedImage = thumbnailCache.object(forKey: urlImage as NSString) {
                    articleCell.thumbnailImageView.image = cachedImage
                } else {
                    downloadImage(urlString: urlImage, indexPath: indexPath)
                }
            }
        }
        if cell as? ArticleListLoadMoreTableViewCell != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                self.reload(page: self.lastPage + 1)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleContentViewController = ArticleContentViewController()
        articleContentViewController.loadView()
        articleContentViewController.newsArticle = articles[indexPath.row]

        if let imageURL = articles[indexPath.row].urlToImage {
            articleContentViewController.imageView.image = thumbnailCache.object(forKey: imageURL as NSString)
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(articleContentViewController, animated: true)
        }
    }
}

extension ArticleListViewController: ArticleListTableViewCellDelegate {
    func showMoreInfoButtonTapped(articleListTableViewCell: ArticleListTableViewCell) {
        DispatchQueue.main.async {
            if let indexPath = self.tableView.indexPath(for: articleListTableViewCell) {
                articleListTableViewCell.expanded = !articleListTableViewCell.expanded
                if articleListTableViewCell.expanded {
                    self.expandedIndexPaths.append(indexPath)
                } else {
                    self.expandedIndexPaths = self.expandedIndexPaths.filter {$0 != indexPath}
                }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
