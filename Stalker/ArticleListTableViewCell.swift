//
//  ArticleListTableViewCell.swift
//  Stalker
//
//  Created by Michael Simard on 5/4/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import UIKit

protocol ArticleListTableViewCellDelegate:class {
    func showMoreInfoButtonTapped(articleListTableViewCell:ArticleListTableViewCell)
}
class ArticleListTableViewCell: UITableViewCell {

   static let identifier = "ArticleListTableViewCell"
   weak var delegate:ArticleListTableViewCellDelegate?
    
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var expanded:Bool = false  {
        didSet{
            if expanded {
                self.descriptionLabel.text = newsArticle?.articleDescription ?? ""
            }
            else {
                self.descriptionLabel.text = ""
            }
        }
    }
    var newsArticle:NewsArticle? {
        didSet{
            self.backgroundColor = .white
            thumbnailImageView.image = nil
            thumbnailImageView.isHidden = newsArticle?.urlToImage == ""
            titleLabel.text = newsArticle?.title ?? "No title"
            self.sourceLabel.text = newsArticle?.source ?? ""
            self.dateLabel.text = UTCToLocal(date:   newsArticle?.publishedAt ?? "")
            self.seeMoreButton.isHidden = newsArticle?.articleDescription == ""
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func showMoreInfoButtonTapped(_ sender: Any) {
        delegate?.showMoreInfoButtonTapped(articleListTableViewCell: self)
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let formmattedDate = dateFormatter.date(from: date){
            print (formmattedDate)
            let displayFormatter = DateFormatter()
            displayFormatter.locale = Locale(identifier: "en_US")
            displayFormatter.dateFormat = "MMM d, YYYY, h:mm a"
            return displayFormatter.string(from: formmattedDate)
        }
        return ""
    }
}
