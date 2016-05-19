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
}