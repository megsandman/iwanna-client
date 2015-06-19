//
//  WebViewController.swift
//  iwanta
//
//  Created by Meg Sandman on 6/19/15.
//  Copyright (c) 2015 Meg Sandman. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView:UIWebView!
    var matchResult:Match!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load web content
        if let url = NSURL(string: matchResult.link) {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
