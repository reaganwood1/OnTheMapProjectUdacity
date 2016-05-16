//
//  UdacityAuthenticationViewController.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/16/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation
import UIKit

class UdacityAuthenticationViewController: UIViewController {

    @IBOutlet weak var uxUdacityLoginWebView: UIWebView!
    var urlRequest: NSURLRequest? = nil
    
    // Give names to the webview fields
    override func viewDidLoad() {
       // uxUdacityLoginWebView.delegate = self
        navigationItem.title = "Udacity Sign Up"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelAuth")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        if let urlRequest = urlRequest {
            uxUdacityLoginWebView.loadRequest(urlRequest)
        }
    }
    
    // MARK: Cancel Auth Flow
    
    func cancelAuth() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//// MARK: - TMDBAuthViewController: UIWebViewDelegate
//
//extension UdacityAuthenticationViewController: UIWebViewDelegate {
//    
//    func webViewDidFinishLoad(webView: UIWebView) {
//        
//        if webView.request!.URL!.absoluteString == "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)/allow" {
//            
//            dismissViewControllerAnimated(true) {
//                self.completionHandlerForView!(success: true, errorString: nil)
//            }
//        }
//    }
//}