//
//  PeekCell.swift
//  PeekShare
//
//  Created by Akshat Goyal on 2/26/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit
import Parse

class PeekCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var peekView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    var media0: PFObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onLike(sender: AnyObject) {
        print("sdfdfsd")
        media0?.incrementKey("likesCount")
        let likesCount = media0?["likesCount"] as! Int
        self.likesCountLabel.text = "\(likesCount)"
        self.likeBtn.setImage(UIImage(named: "like-action-on"), forState: .Normal)
    }
}
