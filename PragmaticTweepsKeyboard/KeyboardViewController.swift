//
//  KeyboardViewController.swift
//  PragmaticTweepsKeyboard
//
//  Created by Cicero Oliveira on 2015-09-23.
//  Copyright (c) 2015 Cicero Oliveira. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UITableViewDataSource, UITableViewDelegate, TwitterAPIRequestDelegate {

    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextKeyboardBarButton: UIBarButtonItem!
    
    var tweepNames : [String] = []

    @IBAction func nextKeyboardBarButtonTapped(sender: UIBarButtonItem) {
        advanceToNextInputMode()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweepNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell") as! UITableViewCell
        cell.textLabel!.text = "@\(tweepNames[indexPath.row])"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let keyInputProxy = textDocumentProxy as? UIKeyInput {
            let atName = "@\(tweepNames[indexPath.row])"
            keyInputProxy.insertText(atName)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let twitterParams : Dictionary = ["count":"100"]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/friends/list.json")
        
        let request = TwitterAPIRequest()
        request.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }

    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let datavalue = data {
            var parseError : NSError? = nil
            let jsonObject : AnyObject? = NSJSONSerialization.JSONObjectWithData(datavalue, options: NSJSONReadingOptions(0), error: &parseError)
            if parseError != nil {
                return
            }
            
            if let jsonDict = jsonObject as? [String:AnyObject] {
                if let usersArray = jsonDict["users"] as? NSArray {
                    self.tweepNames.removeAll(keepCapacity: true)
                    
                    for userObject in usersArray {
                        if let userDict = userObject as? [String:AnyObject] {
                            let tweepName = userDict["screen_name"] as! String
                            self.tweepNames.append(tweepName)
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        } else {
            println("handleTwitterData received no data")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        var proxy = self.textDocumentProxy as! UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        //self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
