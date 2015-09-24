//
//  TwitterAPIRequestDelegate.swift
//  PragmaticTweets
//
//  Created by Cicero Oliveira on 2015-09-21.
//  Copyright (c) 2015 Cicero Oliveira. All rights reserved.
//

import Foundation

protocol TwitterAPIRequestDelegate {
    func handleTwitterData (data: NSData!,
        urlResponse: NSHTTPURLResponse!,
        error: NSError!,
        fromRequest: TwitterAPIRequest!)
}