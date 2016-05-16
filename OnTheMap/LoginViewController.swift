//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/15/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var uxLoginButton: UIButton!
    @IBOutlet weak var uxUdacitySignUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // single call to Login to the Udacity server
    @IBAction func LoginToUdacity(sender: AnyObject) {
        
    }
    // Processes sender's request to sign up for a Udacity account
    @IBAction func udacitySignUpFlow(sender: AnyObject) {
        
        // Launches safari browser so person can sign up
        let request = NSURL(string: UdacityClient.Constants.coreUdacitySignUpURL)
        UIApplication.sharedApplication().openURL(request!)
    }
    
    /* This function opens a TMDBAuthViewController to handle Step 2a of the auth flow */
    private func SignUpWithUdacity(hostViewController: UIViewController, completionHandlerForLogin: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSURL(string: UdacityClient.Constants.coreUdacitySignUpURL)
        UIApplication.sharedApplication().openURL(request!)

        //        let requestURL = UdacityClient.Constants.coreUdacityURL // get the url for signing up
//        //let request = NSURLRequest(URL: requestURL)
//        
//        let url = NSURL(string: requestURL)!
//        UIApplication.sharedApplication().openURL(url)
//
//        // control the webview for presenting info on Udacity Sign up
//        let webAuthViewController = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("UdacityAuthenticationViewController") as! UdacityAuthenticationViewController
//       // webAuthViewController.urlRequest = request
//        let webAuthNavigationController = UINavigationController()
//        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
//        performUIUpdatesOnMain {
//            hostViewController.presentViewController(webAuthNavigationController, animated: true, completion: nil)
//        }

        } // end method
}