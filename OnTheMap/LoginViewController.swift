//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/15/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var uxLoginButton: UIButton!
    @IBOutlet weak var uxUdacitySignUpButton: UIButton!
    @IBOutlet weak var uxEmailLoginTextField: UITextField!
    @IBOutlet weak var uxPasswordLoginTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uxEmailLoginTextField.delegate = self
        uxPasswordLoginTextField.delegate = self
        uxPasswordLoginTextField.secureTextEntry = false
        uxPasswordLoginTextField.tag = 1
        uxEmailLoginTextField.tag = 2
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // single call to Login to the Udacity server
    @IBAction func LoginToUdacity(sender: AnyObject) {
        
        if (uxPasswordLoginTextField.text == "" || uxEmailLoginTextField.text == "" || uxPasswordLoginTextField.text == "Password" || uxEmailLoginTextField.text == "Email") {
            displayEmptyAlert("", message: "Empty Email or Password", actionTitle: "Dismiss")
        }
        loginToUdacityWithLoginAndPassword()
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.tag == 1){
            textField.secureTextEntry = true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if (textField.tag == 1) {
            if (textField.text == ""){
                textField.text = "Password"
                textField.secureTextEntry = false
            }
        } else if (textField.tag == 2) {
            if (textField.text == ""){
                textField.text = "Email"
            }
        }
        
        
    }
    
    func displayEmptyAlert(headTitle: String?, message: String?, actionTitle: String?){
        
        
        // once you have this, run the handler completionHandler!
        dispatch_async(dispatch_get_main_queue(), {()-> Void in
            
            let alert = UIAlertController(title: headTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: { action in
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
           
        }) // end image main queue completion handler
    }
    
    func loginToUdacityWithLoginAndPassword(){
        UdacityClient.sharedInstance().createLoginSessionWithUdacity(uxEmailLoginTextField.text!, password: uxPasswordLoginTextField.text!) { (sessionCreated, error) in
            
            if (error == nil){
                if (sessionCreated == true)
                {
                    self.getUserData()// finish the loginProcess by getting the user data
                } else {
                    self.displayEmptyAlert("", message: "Invalid Email or Password", actionTitle: "Dismiss")
                }
            }
            else {
                self.displayEmptyAlert("", message: "Invalid Email or Password", actionTitle: "Dismiss")
            }
            
        }
    } // end function
    
    func getUserData(){
        
        UdacityClient.sharedInstance().getFirstAndLastName { (nameRetrieved, error) in
            if (error == nil && nameRetrieved == true){
                self.finishLogin()
            } else {
                print("name info was not retrived successfully")
            }
        }
    }
    
    // Finishes the login process to Udacity and displays the main view of the app
    func finishLogin(){

        
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
                // once you have this, run the handler completionHandler!
                dispatch_async(dispatch_get_main_queue(), {()-> Void in
                    
                    // perform segue
                    self.performSegueWithIdentifier("PresentMapTabView", sender: self)
//                    let mapViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PinMapViewController") as! PinMapViewController
//                    self.navigationController!.pushViewController(mapViewController, animated: true)
                }) // end image main queue completion handler
            
        } // end closure
        
        
    } // end function
    
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