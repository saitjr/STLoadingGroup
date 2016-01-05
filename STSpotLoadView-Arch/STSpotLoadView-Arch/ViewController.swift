//
//  ViewController.swift
//  STSpotLoadView-Arch
//
//  Created by TangJR on 1/4/16.
//  Copyright © 2016 tangjr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var spotLoadView: STSpotLoadView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        spotLoadView.startAnimation()
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * 9))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            self.spotLoadView.stopAnimation()
        }
    }
}