//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Siraj Zaneer on 12/30/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

protocol ComposeViewControllerDelegate {
    func did(post: Tweet)
}

class ComposeViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var screenameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var tweetView: UITextView!
    var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = User.current!
        if !user.verified {
            verifiedView.isHidden = true
        }
        nameLabel.text = user.name
        screenameLabel.text = "@" + user.screenName
        tweetView.delegate = self
        profileView.af_setImage(withURL: URL(string: user.profileImage)!)
    }

    @IBAction func onShare(_ sender: Any) {
         shareButton.isEnabled = false
        APIManager.shared.composeTweet(with: tweetView.text) { (tweet, error) in
            if let error = error {
                print(error.localizedDescription)
                self.shareButton.isEnabled = true
            } else {
                self.delegate?.did(post: tweet!)
                self.shareButton.isEnabled = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let total = 140 - tweetView.text.count
        if total == 140 || total < 0 {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
        }
        
        if total < 0 {
            countLabel.textColor = .red
        } else {
            countLabel.textColor = .lightGray
        }
        countLabel.text = "\(total)"
    }
}
