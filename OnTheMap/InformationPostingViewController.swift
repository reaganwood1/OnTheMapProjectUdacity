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
    
    override func viewDidLoad() {
        
        // set locationTextView delegate
        locationTextView.delegate = self
        cancelButton.bringSubviewToFront(cancelButton)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        locationTextView.text = ""
        locationTextView.textAlignment = .Left
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        // reposition the text at the end of editing
        locationTextView.textAlignment = .Center
    }
}