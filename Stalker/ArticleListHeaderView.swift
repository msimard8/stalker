//
//  ArticleContentHeaderView.swift
//  Stalker
//
//  Created by Michael Simard on 5/5/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import UIKit

class ArticleListHeaderView: UITableViewHeaderFooterView {
    static let identifier = "ArticleListHeaderView"

    override var contentView: UIView {
        return self.subviews[0]
    }
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    //  @IBOutlet weak var imageView: UIImageView!
  //  weak var titleLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
