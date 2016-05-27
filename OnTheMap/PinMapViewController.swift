//
//  PinMapViewController.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/17/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// class handles the map display of students taking the Udacity devleoper course
class PinMapViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    var postingStudent: PARSEStudentInformation?
    var allAnnotations = [MKAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.retrieveAndDisplayStudentInfo()
        mapView.reloadInputViews()
    }
    
    // Returns the view associated with the specified annotation object
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
     // displays urls when a pin is clicked through Safari
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                if (UIApplication.sharedApplication().canOpenURL(NSURL(string: toOpen)!)){
                    app.openURL(NSURL(string: toOpen)!)
                } else { // display alert view if link cannot be opened
                
                    displayEmptyAlert("", message: "Invalid Link", actionTitle: "Dismiss")
                    
                }
            }
        }
        
    }
    
    // call to retrieve the student data from th parse server
    func retrieveAndDisplayStudentInfo() {
        
        PARSEClient.sharedInstance().getStudentInfo { (retrived, error) in
            
            if (error == nil){
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        
                        self.addStudentsToMap(StudentData.sharedInstance().udacityStudentInformation)
                        
                    })}
                
            }else { // if data couldn't be retrieved display error in the alert view
                self.displayEmptyAlert("", message: "Data could not be retrieved", actionTitle: "Ok")
            }
        }
    }
    
    // adds students to the mapView
    func addStudentsToMap(udacityStudents: [PARSEStudentInformation])
    {
        // removes old student data
        mapView.removeAnnotations(allAnnotations)
        
        var studentsLocations = [MKAnnotation]()
        
        // iterate through each student
        for udacityStudent in udacityStudents {
            
            // create point annotation object
            let studentPoint = MKPointAnnotation()
            
            // get the object id to be used for overwriting data
            if (udacityStudent.firstName == UdacityClient.sharedInstance().userFirstName && udacityStudent.lastName == UdacityClient.sharedInstance().userLastname) {
                PARSEClient.sharedInstance().objectID = udacityStudent.objectID!
                            }
            
            // add the point object to the map
            if let longitude = udacityStudent.longitude {
                if let latitude = udacityStudent.latitude {
                    let studentLocation = CLLocationCoordinate2DMake(latitude, longitude)
                    
                    studentPoint.title = "\(udacityStudent.firstName!) \(udacityStudent.lastName!)"
                    studentPoint.coordinate = studentLocation
                    studentPoint.subtitle = udacityStudent.mediaURL!
                    studentsLocations.append(studentPoint)
                    mapView.addAnnotation(studentPoint)
                } // end if
            } // end if
        } // end for
        
        // add to global annotation object
        allAnnotations = studentsLocations
    }
    
    // logout and load the LoginVC
    @IBAction func logoutOfMapButtonPressed(sender: AnyObject) {
       
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })}
    }
    
    // Call to add student info to the map
    @IBAction func PostToMapButtonPressed(sender: AnyObject) {
        
        if (PARSEClient.sharedInstance().objectID == nil){
            self.performSegueWithIdentifier("PresentInformationView", sender: self)
        } else { // data already exists, ask user if they would like to overwrite the existing data
            
            AskToOverWrite({ (overwrite) in
                if (overwrite == true){
                    self.performSegueWithIdentifier("PresentInformationView", sender: self)
                }
            })
        }
    }
    
    // This function handles alert view for asking students if they would like to overwrite their existing data
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
    
    // refreshes the data on the map
    @IBAction func refreshMapButtonPressed(sender: AnyObject) {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
              
                    self.retrieveAndDisplayStudentInfo()
            })}
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
}