//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: TTTAttributedLabel!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var favoriteView: UIImageView!
    @IBOutlet weak var retweetView: UIImageView!
    @IBOutlet weak var verifiedConstraint: NSLayoutConstraint!
    @IBOutlet weak var screennameAndDateLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            if !tweet.user.verified {
                verifiedConstraint.constant = 0
            }
            
            screennameAndDateLabel.text = "@\(tweet.user.screenName) . \(tweet.createdAtString)"
            replyCountLabel.text = "\(tweet.replyCount)"
            retweetCountLabel.text = "\(tweet.retweetCount)"
            
            if let favoriteCount = tweet.favoriteCount {
                favoriteCountLabel.text = "\(favoriteCount)"
            }
            if let favorited = tweet.favorited, favorited {
                favoriteView.image = UIImage(named: "favor-icon-red")
            }
            
            if tweet.retweeted {
                favoriteView.image = UIImage(named: "retweet-icon-green")
            }
            
            
            tweetTextLabel.text = tweet.text
            nameLabel.text = tweet.user.name
            profileView.af_setImage(withURL: URL(string: tweet.user.profileImage)!)
            profileView.layer.cornerRadius = 8
            profileView.layer.masksToBounds = true
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
    
}
