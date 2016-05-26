//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/15/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import UIKit
import Foundation

// class LoginViewController handles the loginFlow of OnTheMap
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // variables
    @IBOutlet weak var uxLoginButton: UIButton!
    @IBOutlet weak var uxUdacitySignUpButton: UIButton!
    @IBOutlet weak var uxEmailLoginTextField: UITextField!
    @IBOutlet weak var uxPasswordLoginTextField: UITextField!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set delegates
        uxEmailLoginTextField.delegate = self
        uxPasswordLoginTextField.delegate = self
        
        // set password secure entry to false so default text appears
        uxPasswordLoginTextField.secureTextEntry = false
        
        // tag the textFields for identification
        uxPasswordLoginTextField.tag = 1
        uxEmailLoginTextField.tag = 2
        
        // Do any additional setup after loading the view, typically from a nib.
        uxUdacitySignUpButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    // single call to Login to the Udacity server
    @IBAction func LoginToUdacity(sender: AnyObject) {
        
        // if one of the textFields isn't formatted properly, display the correct alert, else Login
        if (uxPasswordLoginTextField.text == "" || uxEmailLoginTextField.text == "" || uxPasswordLoginTextField.text == "Password" || uxEmailLoginTextField.text == "Email") {
            displayEmptyAlert("", message: "Empty Email or Password", actionTitle: "Dismiss")
        } else {
            loginToUdacityWithLoginAndPassword()
        }
    }
    
    // Check to see if secureText needs to be added to the password textField
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.tag == 1 && textField.text == "Password") {
            textField.text = ""
            textField.secureTextEntry = true
        }
        
        if (textField.tag == 2 && textField.text == "Email") {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        // check for improper entries and set back to defaults if so
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
        
        // run the alert in the main queue because it's a member of UIKit
        dispatch_async(dispatch_get_main_queue(), {()-> Void in
            
            let alert = UIAlertController(title: headTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: { action in
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
           
        }) // end image main queue completion handler
    }
    
    func loginToUdacityWithLoginAndPassword(){
        
        if (Reachability.isConnectedToNetwork()) { // source: http://www.brianjcoleman.com/tutorial-check-for-internet-connection-in-swift/
            
            activityView.startAnimating()
            
            UdacityClient.sharedInstance().createLoginSessionWithUdacity(uxEmailLoginTextField.text!, password: uxPasswordLoginTextField.text!) { (sessionCreated, error) in
                
                if (error == nil){
                    if (sessionCreated == true)
                    {
                        self.getUserData()// finish the loginProcess by getting the user data
                    } else {
                        
                        self.displayEmptyAlert("", message: "Invalid Email or Password", actionTitle: "Dismiss")
                        
                        // run the alert in the main queue because it's a member of UIKit
                        dispatch_async(dispatch_get_main_queue(), {()-> Void in
                            
                            self.activityView.stopAnimating()
                            
                        }) // end activity main queue
                    }
                }
                else {
                    
                    self.displayEmptyAlert("", message: "Invalid Email or Password", actionTitle: "Dismiss")
                    
                    dispatch_async(dispatch_get_main_queue(), {()-> Void in
                        
                        self.activityView.stopAnimating()
                        
                    })
                }
            }

        } else { // not connected to the network
            displayEmptyAlert("", message: "No Internet Connection Detected", actionTitle: "Ok")
        }
    } // end function
    
    // call to get the name of the user logging in
    func getUserData(){
        
        UdacityClient.sharedInstance().getFirstAndLastName { (nameRetrieved, error) in
            if (error == nil && nameRetrieved == true){
                self.finishLogin()
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {()-> Void in
                    
                    self.activityView.stopAnimating()
                    
                }) // end main queue
                
                self.displayEmptyAlert("", message: "Data could not be retrieded", actionTitle: "Ok")
            }
        }
    }
    
    // Finishes the login process to Udacity and displays the main view of the app
    func finishLogin(){
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
                // once you have this, run the handler completionHandler!
                dispatch_async(dispatch_get_main_queue(), {()-> Void in
                    
                    self.activityView.stopAnimating()
                    
                    // perform segue to the mapVC
                    self.performSegueWithIdentifier("PresentMapTabView", sender: self)
                    
                }) // end image main queue completion handler
            
        } // end closure
    } // end function
    
    // Processes sender's request to sign up for a Udacity account
    @IBAction func udacitySignUpFlow(sender: AnyObject) {
        
        // Launches safari browser so user can sign up
        let request = NSURL(string: UdacityClient.Constants.coreUdacitySignUpURL)
        UIApplication.sharedApplication().openURL(request!)
    }
    
    // when textField ends editing, dismiss the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}