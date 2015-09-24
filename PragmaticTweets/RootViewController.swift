//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Cicero Oliveira on 2015-09-03.
//  Copyright (c) 2015 Cicero Oliveira. All rights reserved.
//

import UIKit
import Social
import Accounts
import Photos
import CoreImage

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/" + "default_profile_6_200x200.png")

public class RootViewController: UITableViewController, TwitterAPIRequestDelegate, UISplitViewControllerDelegate {
    
    var parsedTweets : [ParsedTweet] = []
    var parsedTweetsMock : Array<ParsedTweet> = [
        ParsedTweet(tweetText: "iOS 8 SDK Development now in Print. Swift programming FTW!", userName: "@pragprog", createdAt: "2014-08-20 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Math is cool", userName: "@redqueencode", createdAt: "2014-08-22 17:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Anime is cool", userName: "@invalidname", createdAt: "2014-08-28 15:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "iOS 8 SDK Development now in Print. Swift programming FTW!", userName: "@pragprog", createdAt: "2014-08-20 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Math is cool", userName: "@redqueencode", createdAt: "2014-08-22 17:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Anime is cool", userName: "@invalidname", createdAt: "2014-08-28 15:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "iOS 8 SDK Development now in Print. Swift programming FTW!", userName: "@pragprog", createdAt: "2014-08-20 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Math is cool", userName: "@redqueencode", createdAt: "2014-08-22 17:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Anime is cool", userName: "@invalidname", createdAt: "2014-08-28 15:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "iOS 8 SDK Development now in Print. Swift programming FTW!", userName: "@pragprog", createdAt: "2014-08-20 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Math is cool", userName: "@redqueencode", createdAt: "2014-08-22 17:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Anime is cool", userName: "@invalidname", createdAt: "2014-08-28 15:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "iOS 8 SDK Development now in Print. Swift programming FTW!", userName: "@pragprog", createdAt: "2014-08-20 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Math is cool", userName: "@redqueencode", createdAt: "2014-08-22 17:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Anime is cool", userName: "@invalidname", createdAt: "2014-08-28 15:44:30 EDT", userAvatarURL: defaultAvatarURL)
    ]

    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }
        
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetCell") as! ParsedTweetCell
        let parsedTweet = parsedTweets[indexPath.row]
        cell.userNameLabel?.text = parsedTweet.userName
        cell.tweetTextLabel?.text = parsedTweet.tweetText
        cell.createdAtLabel?.text = parsedTweet.createdAt
        
        cell.avatarImageView.image = nil
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), {
            if let imageData = NSData(contentsOfURL: parsedTweet.userAvatarURL!) {
                let avatarImage = UIImage(data: imageData)
                dispatch_async(dispatch_get_main_queue(), {
                    if cell.userNameLabel.text == parsedTweet.userName {
                        cell.avatarImageView.image = avatarImage
                    } else {
                        println("oops, wrong cell, never mind")
                    }
                })
            }
        })
        //if parsedTweet.userAvatarURL != nil {
        //    if let imageData = NSData (contentsOfURL: parsedTweet.userAvatarURL!) {
        //      cell.avatarImageView.image = UIImage (data: imageData)
        //    }
        //}
        
        return cell
    }
    
    @IBOutlet public weak var twitterWebView: UIWebView!
    
    @IBAction func handleShowMyTweetsTapped(sender: UIButton) {
        reloadTweets()
    }
    
    func reloadTweets() {
        let twitterParams = ["count" : "100"]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        let request = TwitterAPIRequest()
        request.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    @IBAction func handleTweetButtonTapped(sender : AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let message = NSLocalizedString("I just finished the first project in iOS 8 SDK Development. #pragsios8", comment: "")
            tweetVC.setInitialText(message)
            presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            println("Can't send tweet")
        }
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        println(NSThread.isMainThread() ? "On main thread" : "Not on main thread")
        if let dataValue = data {
            var parseError : NSError? = nil
            let jsonObject : AnyObject? = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(0), error: &parseError)
            if parseError != nil {
                return
            }
            if let jsonArray = jsonObject as? [[String:AnyObject]] {
                self.parsedTweets.removeAll(keepCapacity: true)
                for tweetDict in jsonArray {
                    let parsedTweet = ParsedTweet()
                    parsedTweet.tweetIdString = tweetDict["id_str"] as? String
                    parsedTweet.tweetText = tweetDict["text"] as? String
                    parsedTweet.createdAt = tweetDict["createdAt"] as? String
                    let userDict = tweetDict["user"] as! NSDictionary
                    parsedTweet.userName = userDict["name"] as? String
                    parsedTweet.userAvatarURL = NSURL(string: userDict["profile_image_url"] as! String)
                    self.parsedTweets.append(parsedTweet)
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            self.tableView.reloadData()
                        }
                    )
                
                }
            }
            //println("JSON error: \(parseError)\nJSON response: \(jsonObject)")
        } else {
            println("handleTwitterData received no data")
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        var refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl = refresher
        
        if splitViewController != nil {
            splitViewController!.delegate = self
        }
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let parsedTweet = parsedTweets[indexPath.row]
        
        if self.splitViewController != nil {
            if (self.splitViewController!.viewControllers.count > 1) {
                if let tweetDetailNav = self.splitViewController!.viewControllers[1] as? UINavigationController {
                    if let tweetDetailVC = tweetDetailNav.viewControllers[0] as? TweetDetailViewController {
                        tweetDetailVC.tweetIdString = parsedTweet.tweetIdString
                    }
                }
            } else {
                if let detailVC = storyboard!.instantiateViewControllerWithIdentifier("TweetDetailVC") as? TweetDetailViewController {
                    detailVC.tweetIdString = parsedTweet.tweetIdString
                    splitViewController!.showDetailViewController(detailVC, sender: self)
                }
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func handleRefresh(sender : AnyObject?) {
        //parsedTweets.append(ParsedTweet(tweetText: "New Tweet", userName: "@refresh", createdAt: NSDate().description, userAvatarURL: defaultAvatarURL))
        reloadTweets()
        refreshControl!.endRefreshing()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTweetDetailsSegue" {
            if let tweetDetailVC = segue.destinationViewController as? TweetDetailViewController {
                let row = tableView!.indexPathForSelectedRow()!.row
                let parsedTweet = parsedTweets[row] as ParsedTweet
                tweetDetailVC.tweetIdString = parsedTweet.tweetIdString
                println("tapped on: \(parsedTweet.tweetText!)")
            }
            
        }
    }
    
    public func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }
    
    @IBAction func handlePhotoButtonTapped(sender: UIBarButtonItem) {
        var fetchOptions = PHFetchOptions()
        
        PHPhotoLibrary.requestAuthorization{
            (authorized: PHAuthorizationStatus) -> Void in
            if authorized == .Authorized {
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
                if let firstPhoto = fetchResult.firstObject as? PHAsset {
                    self.createTweetForAsset(firstPhoto)
                }
            }
        }
    }
    
    func createTweetForAsset(asset: PHAsset) {
        var requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(640, 480), contentMode: PHImageContentMode.AspectFit, options: requestOptions) {
            (image: UIImage!, info: [NSObject:AnyObject]!) -> Void in
            
            var ciImage = CIImage(image: image)
            
            ciImage = ciImage.imageByApplyingFilter("CIPixellate", withInputParameters: ["inputScale" : 15])
            let ciContext = CIContext(options: nil)
            let cgImage = ciContext.createCGImage(ciImage, fromRect: ciImage.extent())
            let tweetImage = UIImage(CGImage: cgImage)
            
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let message = NSLocalizedString("Here's a photo I tweeted. #pragsios8", comment: "")
            tweetVC.setInitialText(message)
            tweetVC.addImage(tweetImage)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(tweetVC, animated: true, completion: nil)
            })
        }
    }
}

