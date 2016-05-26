//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/20/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate, UITextViewDelegate{

    // variables representing two different views
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var secondViewTextView: UITextView!
    @IBOutlet weak var secondViewMapView: MKMapView!
    @IBOutlet weak var secondViewSubmitButton: UIButton!
    @IBOutlet weak var whereAreYouLabel: UILabel!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var located: CLLocation? = nil
    var stringLocation: String? = ""
    
    override func viewDidLoad() {
        
        // set locationTextView delegate
        locationTextView.delegate = self
        secondViewTextView.delegate = self
        cancelButton.bringSubviewToFront(cancelButton)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (locationTextView.text == "Enter Your Location Here"){
            locationTextView.text = ""
        }
        
        if (secondViewTextView.hidden == false && secondViewTextView.text == "Enter a Link to Share Here"){
            secondViewTextView.text = ""
            secondViewTextView.textAlignment = .Left
        }
        
        locationTextView.textAlignment = .Left
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        // reposition the text at the end of editing
        locationTextView.textAlignment = .Center
        secondViewTextView.textAlignment = .Center
        
        if (locationTextView.text == "") {
            locationTextView.text = "Enter Your Location Here"
        }
        if (secondViewTextView.text == ""){
            secondViewTextView.text = "Enter a Link to Share"
        }
    }
   
    // dismissed the current view controller and presents the previous view
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        if (secondViewTextView.text != "Enter a Link to Share Here" || secondViewTextView.text != "") {
            submitInfoToParse({ (success) in
                if (!success) {
                    self.displayEmptyAlert("", message: "Data could not be posted", actionTitle: "Dismiss")
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else { //end if
                    self.dismissViewControllerAnimated(true, completion: nil)
                    // TODO: Present the other view controller
                }// end else
            }) // end closure
        } // end if
        
    } // end function
    
    // submit user info to the PARSE database
    func submitInfoToParse (completionHandlerForParse: (success: Bool) -> Void) {
        
        // store coordinate info
        let coordinate = located?.coordinate
        let doubleLat = coordinate!.latitude
        let doubleLon = coordinate!.longitude
        let name = "\(UdacityClient.sharedInstance().userLastname) \(UdacityClient.sharedInstance().userLastname)"
        
        // if the user has never been added to the PARSE DB, add data
        if (PARSEClient.sharedInstance().objectID == nil) {
            PARSEClient.sharedInstance().sendToParseServerStudentInfo(doubleLat, name: name, locationString: stringLocation!, mediaURL: secondViewTextView.text, longitude: doubleLon) { (success, error) in
                
                if (error == nil) {
                    completionHandlerForParse(success: true)
                } else {
                    completionHandlerForParse(success: false)
                }
            } // end sendToParseServerStudentInfo
        }else { // if the user has been added to the PARSE DB, update the user's info
            PARSEClient.sharedInstance().sendToParseServerUpdatedStudentInfo(doubleLat, name: name, locationString: stringLocation!, mediaURL: secondViewTextView.text, longitude: doubleLon) { (success, error) in
                
                if (error == nil){
                    completionHandlerForParse(success: true)
                } else {
                    completionHandlerForParse(success: false)
                }
            } // end sendToParseServerUpdatedStudentInfo
        } // end else
        
    } // end function
    
    // switch view to allow user to enter a link to share
    @IBAction func findOnMapButtonPressed(sender: AnyObject) {
        
        activityView.startAnimating()
        
        geoCodeLocation(locationTextView.text) { (success, error) in
            if (error == nil && success == true){
                self.activityView.stopAnimating()
                self.stringLocation = self.locationTextView.text
                self.secondViewMapView.hidden = false
                self.secondViewTextView.hidden = false
                self.secondViewSubmitButton.hidden = false
                self.findOnMapButton.hidden = true
                self.locationTextView.hidden = true
                self.whereAreYouLabel.hidden = true
                self.studyingLabel.hidden = true
                self.todayLabel.hidden = true
                self.view.bringSubviewToFront(self.secondViewSubmitButton)
                self.view.backgroundColor = UIColor(red:0.16, green:0.5, blue:0.67, alpha:1.0)
                self.cancelButton.titleLabel?.textColor = UIColor.whiteColor()
                self.zoomToLocation()
            }else {
                self.activityView.stopAnimating()
                self.displayEmptyAlert("", message: "Location could not be located", actionTitle: "Try Again")
            }
        }
    } // end function
    
    // zooms to the location the user specified
    func zoomToLocation() {
        AddAnnotation()
        let location = located?.coordinate
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let region = MKCoordinateRegion(center: location!, span: span)
        secondViewMapView.setRegion(region, animated: true)
        
    } // end function
    
    // adds the annotation to the temporary map
    func AddAnnotation () {
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = located?.coordinate
        
        let first = UdacityClient.sharedInstance().userFirstName
        let last = UdacityClient.sharedInstance().userLastname
        let mediaURL = ""
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
    
    // When the array is complete, we add the annotations to the map.
    self.secondViewMapView.addAnnotation(annotation)
    
    }
    
    // Geocode the string entered by the use
    func geoCodeLocation(stringForGeoCode: String, completionHandler: (success: Bool, error: NSError?)-> Void) {
        
        
        let CLGeocode = CLGeocoder()
        
        CLGeocode.geocodeAddressString(stringForGeoCode) { placemarks, error in
            
            if (error == nil){
                self.located = placemarks!.first?.location!
                completionHandler(success: true, error: nil)
                
            } else {

                completionHandler(success: false, error: error)
                
            } // end else
        } // end completion handler
        
    } // end function
    
    // specifies when the keyboard should be dismissed
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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