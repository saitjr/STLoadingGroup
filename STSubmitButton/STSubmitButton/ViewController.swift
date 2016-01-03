//
//  ViewController.swift
//  STSubmitButton
//
//  Created by TangJR on 1/3/16.
//  Copyright © 2016 tangjr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func submitButtonTapped(sender: STSubmitButton) {
        sender.startAnimation()
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * 3))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            sender.stopAnimation()
        }
    }
}