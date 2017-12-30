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
            replyCountLabel.text = "\(tweet.replyCount ?? 0)"
            retweetCountLabel.text = "\(tweet.retweetCount)"
            
            if let favoriteCount = tweet.favoriteCount {
                favoriteCountLabel.text = "\(favoriteCount)"
            }
            if let favorited = tweet.favorited, favorited {
                favoriteView.image = UIImage(named: "favor-icon-red")
            } else {
                favoriteView.image = UIImage(named: "favor-icon")
            }
            
            if tweet.retweeted {
                favoriteView.image = UIImage(named: "retweet-icon-green")
            } else {
                favoriteView.image = UIImage(named: "retweet-icon")
            }
            
            retweetView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(retweetPost)))
            favoriteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoritePost)))
            
            tweetTextLabel.text = tweet.text
            nameLabel.text = tweet.user.name
            profileView.af_setImage(withURL: URL(string: tweet.user.profileImage)!)
            profileView.layer.cornerRadius = 8
            profileView.layer.masksToBounds = true
        }
    }
    
    func favoritePost() {
        favoriteView.isUserInteractionEnabled = false
        if let favorited = tweet.favorited {
            if favorited {
                APIManager.shared.unFavorite(tweet, completion: { (tweet, error) in
                    if let error = error {
                        self.favoriteView.isUserInteractionEnabled = true
                        print(error.localizedDescription)
                    } else {
                        self.favoriteView.isUserInteractionEnabled = true
                        self.tweet = tweet
                    }
                })
            } else {
                APIManager.shared.favorite(tweet, completion: { (tweet, error) in
                    if let error = error {
                        self.favoriteView.isUserInteractionEnabled = true
                        print(error.localizedDescription)
                    } else {
                        self.favoriteView.isUserInteractionEnabled = true
                        self.tweet = tweet
                    }
                })
            }
        } else {
            APIManager.shared.favorite(tweet, completion: { (tweet, error) in
                if let error = error {
                    self.favoriteView.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.favoriteView.isUserInteractionEnabled = true
                    self.tweet = tweet
                }
            })
        }
    }
    
    func retweetPost() {
        if tweet.retweeted {
            retweetView.isUserInteractionEnabled = false
            APIManager.shared.retweet(tweet, completion: { (tweet, error) in
                if let error = error {
                    self.retweetView.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.retweetView.isUserInteractionEnabled = true
                    self.tweet = tweet
                }
            })
        } else {
            retweetView.isUserInteractionEnabled = false
            APIManager.shared.unRetweet(tweet, completion: { (tweet, error) in
                if let error = error {
                    self.retweetView.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.retweetView.isUserInteractionEnabled = true
                    self.tweet = tweet
                }
            })
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
