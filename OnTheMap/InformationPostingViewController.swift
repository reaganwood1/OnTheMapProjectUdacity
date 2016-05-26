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

    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var secondViewTextView: UITextView!
    @IBOutlet weak var secondViewMapView: MKMapView!
    @IBOutlet weak var secondViewSubmitButton: UIButton!
    @IBOutlet weak var whereAreYouLabel: UILabel!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
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
            submitInfoToParse({ (success, error) in
                if let error = error {
                    print("error present!")
                } else { //end if
                    
                    // TODO: Present the other view controller
                }// end else
            }) // end closure
        } // end if
        
    } // end function
    
    
    func submitInfoToParse (completionHandlerForParse: (success: Bool, error: NSError?) -> Void) {
        
        let coordinate = located?.coordinate
        let doubleLat = coordinate!.latitude
        let doubleLon = coordinate!.longitude
        let name = "\(UdacityClient.sharedInstance().userLastname) \(UdacityClient.sharedInstance().userLastname)"
        if (PARSEClient.sharedInstance().objectID == nil) {
            PARSEClient.sharedInstance().sendToParseServerStudentInfo(doubleLat, name: name, locationString: stringLocation!, mediaURL: secondViewTextView.text, longitude: doubleLon) { (success, error) in
                
                if (error == nil) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print("You need to display an alert view saying what went wrong here")
                }
            } // end sendToParseServerStudentInfo
        }else {
            PARSEClient.sharedInstance().sendToParseServerUpdatedStudentInfo(doubleLat, name: name, locationString: stringLocation!, mediaURL: secondViewTextView.text, longitude: doubleLon) { (success, error) in
                
                if (error == nil){
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print("you need to display an alert view saying what went wrong here")
                }
            } // end sendToParseServerUpdatedStudentInfo
        } // end else
        
    } // end function
    
    @IBAction func findOnMapButtonPressed(sender: AnyObject) {
        
        geoCodeLocation(locationTextView.text) { (success, error) in
            if (error == nil && success == true){
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
                print("display message here for non-correct output")
            }
        }
    } // end function
    
    
    func zoomToLocation() {
        AddAnnotation()
        var location = located?.coordinate
        var span = MKCoordinateSpanMake(0.002, 0.002)
        var region = MKCoordinateRegion(center: location!, span: span)
        secondViewMapView.setRegion(region, animated: true)
        
    } // end function
    
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
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}