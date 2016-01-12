//
//  MyFeedTableViewCell.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 11/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit

class MyFeedTableViewCell: UITableViewCell {

    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var numOfLikeLabel: UILabel!
    @IBOutlet var numOfCommentLabel: UILabel!
    @IBOutlet var cardView: UIView!
    @IBOutlet var likeBtn: UIButton!
    @IBOutlet var commentBtn: UIButton!
    @IBOutlet var feedTopicLabel: UILabel!
    @IBOutlet var feedImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        cardSetup()
        imageSetup()
    }
    
    func cardSetup(){
        cardView.alpha = 1
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 1
        //        cardView.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        //        cardView.layer.shadowRadius = 1
        //        cardView.layer.shadowOpacity = 0.2
        //
        //        let path = UIBezierPath(rect: cardView.bounds)
        //        cardView.layer.shadowPath = path.CGPath
        self.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
    }
    
    func imageSetup(){
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        profileImageView.clipsToBounds = true
    }

}
