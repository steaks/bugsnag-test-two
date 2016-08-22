//
//  ViewController.swift
//  bugsnag-test-two
//
//  Created by Steven Wexler on 8/22/16.
//  Copyright © 2016 Steven Wexler. All rights reserved.
//

import UIKit
import Bugsnag

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let config = BugsnagConfiguration()
        config.apiKey = "{API_KEY}"
        config.appVersion = "{APP_VERSION}"
        config.releaseStage = "{RELEASE_STAGE}"
        config.setUser("{YOUR_ID}", withName: "{YOUR_NAME}", andEmail: "{YOUR_EMAIL}")
        Bugsnag.startBugsnagWithConfiguration(config)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func testAction(sender: AnyObject) {
        let url = NSURL(string: "https://www.google.com")!
        AnotherClass.httpGetBad(url, completionHandler: { (response, data, error) in
            let exception = NSException(name: "Test", reason: "Test reason", userInfo: nil)
            Bugsnag.notify(exception)
        })
    }
}

class AnotherClass: NSObject {
    
    class func httpGetBad(url: NSURL, completionHandler: ((response: NSURLResponse?, data: NSData?, error: NSError?) -> Void)?) {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if let callback = completionHandler {
                callback(response: response, data: data, error: error)
            }
        }
        task.resume()
    }
    
    class func httpGetGood(url: NSURL, completionHandler: (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            let callback = completionHandler
            callback(response: response, data: data, error: error)
        }
        task.resume()
    }
}

