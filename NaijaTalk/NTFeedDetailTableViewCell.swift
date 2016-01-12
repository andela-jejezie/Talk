//
//  NTFeedDetailTableViewCell.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 11/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit

class NTFeedDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var likeBtn: UIButton!
    @IBOutlet var commentBtn: UIButton!
    @IBOutlet var numberOfLikes: UILabel!
    @IBOutlet var numberOfComment: UILabel!
    @IBOutlet var postDetailLabel: UILabel!
    @IBOutlet var postImageLabel: UIImageView!
    @IBOutlet var headlineLabel: UILabel!
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
    


}
