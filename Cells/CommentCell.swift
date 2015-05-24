//
//  CommentCell.swift
//  iShots
//
//  Created by Tope Abayomi on 04/01/2015.
//  Copyright (c) 2015 App Design Vault. All rights reserved.
//

import Foundation
import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet var profileImageView : UIImageView!
    @IBOutlet var dateImageView : UIImageView!

    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var postLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!

    override func awakeFromNib() {
        
        dateImageView.image = UIImage(named: "clock")
        dateImageView.alpha = 0.20
        profileImageView.layer.cornerRadius = 15
        profileImageView.clipsToBounds = true
        
        nameLabel.font = UIFont(name: MegaTheme.fontName, size: 16)
        nameLabel.textColor = MegaTheme.darkColor
        
        postLabel?.font = UIFont(name: MegaTheme.fontName, size: 12)
        postLabel?.textColor = MegaTheme.lightColor
        
        dateLabel.font = UIFont(name: MegaTheme.fontName, size: 11)
        dateLabel.textColor = MegaTheme.lightColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        postLabel.preferredMaxLayoutWidth = CGRectGetWidth(postLabel.frame)

    }
}