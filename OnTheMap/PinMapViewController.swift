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

class PinMapViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // for now, see if you can get the student information right here
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
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
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
        
    }
    
    // When map is done loading, then add the data
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        retrieveAndDisplayStudentInfo()
        mapView.reloadInputViews()
    }
    
    func retrieveAndDisplayStudentInfo() {
        
        PARSEClient.sharedInstance().getStudentInfo { (retrived, error) in
            
            if (error == nil){
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        
                        self.addStudentsToMap(PARSEClient.sharedInstance().udacityStudentInformation)
                        
                    })}
                
            }else {
                print(error)
            }
        }
    }
    
    func addStudentsToMap(udacityStudents: [PARSEStudentInformation])
    {
        var studentsLocations = [MKAnnotation]()
        
        for udacityStudent in udacityStudents {
            
            let studentPoint = MKPointAnnotation()
            
            if (udacityStudent.firstName == UdacityClient.sharedInstance().userFirstName && udacityStudent.lastName == UdacityClient.sharedInstance().userLastname) {
                PARSEClient.sharedInstance().objectID = udacityStudent.objectID!
            }
            
            if let longitude = udacityStudent.longitude {
                if let latitude = udacityStudent.latitude {
                    let studentLocation = CLLocationCoordinate2DMake(latitude, longitude)
                    
                    studentPoint.title = "\(udacityStudent.firstName!) \(udacityStudent.lastName!)"
                    studentPoint.coordinate = studentLocation
                    studentPoint.subtitle = udacityStudent.mediaURL!
                    studentsLocations.append(studentPoint)
                    mapView.addAnnotation(studentPoint)
                }
            }
        }
    }
    
    @IBAction func logoutOfMapButtonPressed(sender: AnyObject) {
       
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })}
    }
    
    @IBAction func PostToMapButtonPressed(sender: AnyObject) {
        
        if (PARSEClient.sharedInstance().objectID == nil){
            self.performSegueWithIdentifier("PresentInformationView", sender: self)
        } else {
            
            AskToOverWrite({ (overwrite) in
                if (overwrite == true){
                    self.performSegueWithIdentifier("PresentInformationView", sender: self)
                }
            })
        }
    }
    
    func AskToOverWrite(completionHandlerForOverWrite: (overwrite: Bool) -> Void){
        
        let name = UdacityClient.sharedInstance().userFirstName! + " " + UdacityClient.sharedInstance().userLastname!
        let alert = UIAlertController(title: "", message: "User \(name) Has Already Posted a Student Location. Would You Like to Overwrite Their Location?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
            completionHandlerForOverWrite(overwrite: false)
        }))
        alert.addAction(UIAlertAction(title: "Overwrite", style: .Destructive, handler: { action in
            completionHandlerForOverWrite(overwrite: true)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func refreshMapButtonPressed(sender: AnyObject) {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                
              
                    self.retrieveAndDisplayStudentInfo()
            })}
    }
    
    
}