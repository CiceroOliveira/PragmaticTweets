//
//  SizeClassOverrideViewController.swift
//  PragmaticTweets
//
//  Created by Cicero Oliveira on 2015-09-21.
//  Copyright (c) 2015 Cicero Oliveira. All rights reserved.
//

import UIKit

class SizeClassOverrideViewController: UIViewController {
    var embeddedSplitVC : UISplitViewController?
    var screenNameForOpenURL : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSizeClassOverridingVC(segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillTransitionToSize(size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            if size.width > 480.0 {
                let overrideTraits = UITraitCollection (
                    horizontalSizeClass: UIUserInterfaceSizeClass.Regular)
                setOverrideTraitCollection(overrideTraits,
                    forChildViewController: embeddedSplitVC!)
            } else {
                setOverrideTraitCollection(nil,
                    forChildViewController: embeddedSplitVC!)
            }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedSplitViewSegue" {
            embeddedSplitVC = segue.destinationViewController as? UISplitViewController
        } else if segue.identifier == "ShowUserFromURLSegue" {
            if let userDetailVC = segue.destinationViewController as? UserDetailViewController {
                userDetailVC.screenName = self.screenNameForOpenURL
            }
        }
    }

}
