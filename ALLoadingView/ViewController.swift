//
//  ViewController.swift
//  ALLoadingView
//
//  Created by Artem Loginov on 07.10.16.
//  Copyright © 2016 ALoginov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate var step = 0
    fileprivate var updateTimer = Timer()
    
    @IBAction func action_testCaseOne(_ sender: AnyObject) {
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .windowed)
        ALLoadingView.manager.hideLoadingView(withDelay: 2.0)
    }
    
    @IBAction func action_testCaseTwo(_ sender: AnyObject) {
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.blurredBackground = true
        ALLoadingView.manager.animationDuration = 1.0
        ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator, windowMode: .fullscreen)
        ALLoadingView.manager.hideLoadingView(withDelay: 5.0)
    }
    
    @IBAction func action_testCaseThree(_ sender: AnyObject) {
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.blurredBackground = true
        ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicatorAndCancelButton, windowMode: .fullscreen)
        ALLoadingView.manager.cancelCallback = {
            ALLoadingView.manager.hideLoadingView()
        }
    }
    
    @IBAction func action_testCaseFour(_ sender: AnyObject) {
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.showLoadingView(ofType: .progress) {
            finished in
            ALLoadingView.manager.updateProgressLoadingView(withMessage: "Initializing", forProgress: 0.05)
            self.step = 1
            self.updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateProgress), userInfo: nil, repeats: true)
        }
    }
    
    func updateProgress() {
        let steps = ["Initializing", "Downloading data", "Extracting files", "Parsing data", "Updating database", "Saving"]
        ALLoadingView.manager.updateProgressLoadingView(withMessage: steps[step], forProgress: 0.2 * Float(step))
        step += 1
        if step == steps.count {
            ALLoadingView.manager.hideLoadingView()
            updateTimer.invalidate()
        }
    }
}

