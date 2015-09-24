//
//  ParsedTweet.swift
//  PragmaticTweets
//
//  Created by Cicero Oliveira on 2015-09-15.
//  Copyright (c) 2015 Cicero Oliveira. All rights reserved.
//

import UIKit

class ParsedTweet: NSObject {
    var tweetIdString : String?
    var tweetText : String?
    var userName : String?
    var createdAt : String?
    var userAvatarURL : NSURL?
    
    init (tweetText : String?, userName : String?,
        createdAt : String?, userAvatarURL : NSURL?) {

        super.init()
        self.tweetText = tweetText
        self.userName = userName
        self.createdAt = createdAt
        self.userAvatarURL = userAvatarURL
    }
    
    override init() {
        super.init()
    }
   
}
