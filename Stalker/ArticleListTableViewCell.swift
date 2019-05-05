//
//  ArticleListTableViewCell.swift
//  Stalker
//
//  Created by Michael Simard on 5/4/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import UIKit

class ArticleListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var newsArticle:NewsArticle? {
        didSet{
            self.backgroundColor = .white
            thumbnailImageView.image = nil
            thumbnailImageView.backgroundColor = newsArticle?.urlToImage == nil ? .clear : .lightGray
            titleLabel.text = newsArticle?.title ?? "No title"
            self.sourceLabel.text = newsArticle?.source ?? ""
            self.dateLabel.text = UTCToLocal(date:   newsArticle?.publishedAt ?? "")
            

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
