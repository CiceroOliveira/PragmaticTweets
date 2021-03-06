//
//  TweetDetailViewController.swift
//  PragmaticTweets
//
//  Created by Cicero Oliveira on 2015-09-21.
//  Copyright (c) 2015 Cicero Oliveira. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, TwitterAPIRequestDelegate {
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    
    var tweetIdString : String? {
        didSet {
            reloadTweetDetails()
        }
    }
    
    func reloadTweetDetails() {
        if tweetIdString == nil {
            return
        }
        
        let twitterRequest = TwitterAPIRequest()
        let twitterParams = ["id" : tweetIdString!]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json")
        twitterRequest.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let datavalue = data {
            var parseError : NSError? = nil
            let jsonObject : AnyObject? = NSJSONSerialization.JSONObjectWithData(datavalue, options: NSJSONReadingOptions(0), error: &parseError)
            
            if parseError != nil {
                return
            } else {
                if let tweetDict = jsonObject as? [String:AnyObject] {
                    dispatch_async(dispatch_get_main_queue(), {
                        println("\(tweetDict)")
                        let userDict = tweetDict["user"] as! NSDictionary
                        self.userRealNameLabel.text = userDict["name"] as? String
                        self.userScreenNameLabel.text = userDict["screen_name"] as? String
                        self.tweetTextLabel.text = tweetDict["text"] as? String
                        let userImageURL = NSURL(string: userDict["profile_image_url"] as! String)
                        self.userImageButton.setTitle(nil, forState: .Normal)
                        
                        if userImageURL != nil {
                            if let imageData = NSData(contentsOfURL: userImageURL!) {
                                self.userImageButton.setImage(UIImage(data: imageData), forState: UIControlState.Normal)
                            }
                            
                        }
                        
                        if let entities = tweetDict["entities"] as? NSDictionary {
                            if let media = entities["media"] as? NSArray {
                                if let mediaString = media[0]["media_url"] as? String {
                                    if let mediaURL = NSURL(string: mediaString) {
                                        if let mediaData = NSData(contentsOfURL: mediaURL) {
                                            self.tweetImageView.image = UIImage(data: mediaData)
                                        }
                                    }
                                }
                            }
                        }
                    })
                }
            }
        } else {
            println("handleTwitterData received no data")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTweetDetails()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showUserDetailsSegue") {
            if let userDetailVC = segue.destinationViewController as? UserDetailViewController {
                userDetailVC.screenName = userScreenNameLabel.text
            }
        }
    }

    @IBAction func unwindToTweetDetailVC(segue: UIStoryboardSegue?) {
        
    }

}
