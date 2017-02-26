/*
 Copyright (c) 2015 Artem Loginov
 
 Permission is hereby granted,  free of charge,  to any person obtaining a
 copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation
 the rights to  use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 DEALINGS IN THE SOFTWARE.
 */

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
        ALLoadingView.manager.blurredBackground = true
        ALLoadingView.manager.windowRatio = 0.6
        ALLoadingView.manager.showLoadingView(ofType: .message, windowMode: .windowed)
        ALLoadingView.manager.hideLoadingView(withDelay: 2.0)
    }
    
    @IBAction func action_testCaseTwo(_ sender: AnyObject) {
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.blurredBackground = true
        ALLoadingView.manager.animationDuration = 1.0
        ALLoadingView.manager.itemSpacing = 30.0
        ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator, windowMode: .fullscreen)
        ALLoadingView.manager.hideLoadingView(withDelay: 2.0)
    }
    
    @IBAction func action_testCaseThree(_ sender: AnyObject) {
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.blurredBackground = true
        ALLoadingView.manager.itemSpacing = 50.0
        ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicatorAndCancelButton, windowMode: .fullscreen)
        ALLoadingView.manager.cancelCallback = {
            ALLoadingView.manager.hideLoadingView()
        }
    }
    
    @IBAction func action_testCaseFour(_ sender: AnyObject) {
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.itemSpacing = 30.0
        ALLoadingView.manager.showLoadingView(ofType: .progress) {
            finished in
            ALLoadingView.manager.updateProgressLoadingView(withMessage: "Initializing", forProgress: 0.05)
            self.step = 1
            self.updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateProgress), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func action_testCaseFive(_ sender: AnyObject) {
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.itemSpacing = 20.0
        ALLoadingView.manager.windowRatio = 0.6
        ALLoadingView.manager.messageText = "Press on Cancel button to change text and progress value"
        ALLoadingView.manager.showLoadingView(ofType: .progressWithCancelButton, windowMode: .windowed)
        ALLoadingView.manager.cancelCallback = {
            [unowned self] in
            
            self.iterate()
        }
    }
    
    var caseFiveStep = 0
    func iterate() {
        guard caseFiveStep < 5 else {
            caseFiveStep = 0
            ALLoadingView.manager.hideLoadingView()
            return
        }
        caseFiveStep += 1
        
        ALLoadingView.manager.updateProgressLoadingView(withMessage: "Count = \(caseFiveStep)", forProgress: 0.2 * Float(caseFiveStep))
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
