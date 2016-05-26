//
//  UdacityStudentListViewController.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/18/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation
import UIKit

// class displays student information in tableView
class UdacityStudentListViewController: UITableViewController {
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // when row is selected, attemps to open URL link in Safari
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = PARSEStudentInformation.udacityStudentInformation[indexPath.row]
        
            let app = UIApplication.sharedApplication()
            if let toOpen = cell.mediaURL{
                if (UIApplication.sharedApplication().canOpenURL(NSURL(string: toOpen)!)){ // if the link can be opened, open it in Safari
                    app.openURL(NSURL(string: toOpen)!)
                } else { // if the link can't be opened, display an alert message with this indication
                    
                    let alert = UIAlertController(title: "", message: "Invalid Link", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: { action in
                        
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
    }
    
    // assigns each piece of student information to a row in the tableView
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // indexes into the PARSEClient to access student information data
        let student = PARSEStudentInformation.udacityStudentInformation[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell")!
        cell.textLabel!.text = "\(student.firstName!) \(student.lastName!)"
        cell.detailTextLabel?.text = "\(student.mediaURL!)"
        return cell
    }
    
    // accesses PARSEClient model to get number of rows for the tableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PARSEStudentInformation.udacityStudentInformation.count
    }
    
    // dismiss the view, present the loginViewController
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })}
    } // end func
    
    // load the data from the PARSE server again
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                
                self.retrieveAndDisplayStudentInfo()
                
            })}
    }
    
    // retrieve the data from the PARSE server
    func retrieveAndDisplayStudentInfo() {
        
        PARSEClient.sharedInstance().getStudentInfo { (retrived, error) in
            
            if (error == nil){
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        // TODO: add code to actually reload the data
                        self.tableView.reloadData()
                        
                    })}
                
            }else {
                self.displayEmptyAlert("", message: "Data Could not be Retrieved", actionTitle: "Ok")
            } // end else
        } // end parseClient
    } // end func
    
    // presents the InformationPostingVC to add or update user data to the Parse server
    @IBAction func addLocationButtonPushed(sender: AnyObject) {
        
        // if the user hasn't been added, present the VC
        if (PARSEClient.sharedInstance().objectID == nil){
            self.performSegueWithIdentifier("PresentInformationView", sender: self)
        } else { // if the user already has been added to the PARSE server, ask if they want to overwrite their existing data
            
            AskToOverWrite({ (overwrite) in
                if (overwrite == true){ // if they choose to overwrite, present the VC
                    self.performSegueWithIdentifier("PresentInformationView", sender: self)
                }
            })
        }
    }
    
    // function to ask user if they would like to overwrite their existing data
    func AskToOverWrite(completionHandlerForOverWrite: (overwrite: Bool) -> Void){
        
        // once you have this, run the handler completionHandler!
        dispatch_async(dispatch_get_main_queue(), {()-> Void in
            
            let name = UdacityClient.sharedInstance().userFirstName! + " " + UdacityClient.sharedInstance().userLastname!
            let alert = UIAlertController(title: "", message: "User \(name) Has Already Posted a Student Location. Would You Like to Overwrite Their Location?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
                completionHandlerForOverWrite(overwrite: false)
            }))
            alert.addAction(UIAlertAction(title: "Overwrite", style: .Destructive, handler: { action in
                completionHandlerForOverWrite(overwrite: true)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }) // end main queue completion handler
        
    }

    // blanket alert view template function
    func displayEmptyAlert(headTitle: String?, message: String?, actionTitle: String?){
        
        // run the alert in the main queue because it's a member of UIKit
        dispatch_async(dispatch_get_main_queue(), {()-> Void in
            
            let alert = UIAlertController(title: headTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: { action in
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }) // end image main queue completion handler
    }
} // end class