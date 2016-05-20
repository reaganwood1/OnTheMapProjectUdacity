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
        locationTextView.textAlignment = .Center
    }
   
    
    // dismissed the current view controller and presents the previous view
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func findOnMapButtonPressed(sender: AnyObject) {
        secondViewMapView.hidden = false
        secondViewTextView.hidden = false
        secondViewSubmitButton.hidden = false
        findOnMapButton.hidden = true
        locationTextView.hidden = true
        whereAreYouLabel.hidden = true
        studyingLabel.hidden = true
        todayLabel.hidden = true
        self.view.bringSubviewToFront(secondViewSubmitButton)
        view.backgroundColor = UIColor(red:0.16, green:0.5, blue:0.67, alpha:1.0)
        cancelButton.titleLabel?.textColor = UIColor.whiteColor()
    }
}