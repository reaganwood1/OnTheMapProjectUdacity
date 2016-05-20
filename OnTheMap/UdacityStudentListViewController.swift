//
//  UdacityStudentListViewController.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/18/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation
import UIKit

class UdacityStudentListViewController: UITableViewController {
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let student = PARSEClient.sharedInstance().udacityStudentInformation[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell")!
        cell.textLabel!.text = "\(student.firstName!) \(student.lastName!)"
        cell.detailTextLabel?.text = "\(student.mediaURL!)"
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PARSEClient.sharedInstance().udacityStudentInformation.count
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })}
    } // func
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                
                self.retrieveAndDisplayStudentInfo()
                
            })}
    }
    
    func retrieveAndDisplayStudentInfo() {
        
        PARSEClient.sharedInstance().getStudentInfo { (retrived, error) in
            
            if (error == nil){
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        
                        self.tableView.reloadData()
                        
                    })}
                
            }else {
                print(error)
            } // end else
        } // end parseClient
    } // end func
    
    @IBAction func addLocationButtonPushed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("PresentInformationView", sender: self)
    }
    
} // end class