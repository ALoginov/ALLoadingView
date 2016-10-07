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
import ALLoadingView

class ViewController: UIViewController {

    fileprivate var step = 0
    fileprivate var updateTimer = Timer()
    
    @IBAction func action_testCaseOne(_ sender: AnyObject) {
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.showLoadingViewOfType(.default, windowMode: .windowed, completionBlock: nil)
        ALLoadingView.manager.hideLoadingViewWithDelay(2.0)
    }
    
    @IBAction func action_testCaseTwo(_ sender: AnyObject) {
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.bluredBackground = true
        ALLoadingView.manager.showLoadingViewOfType(.messageWithIndicator, windowMode: .fullscreen, completionBlock: nil)
        ALLoadingView.manager.hideLoadingViewWithDelay(2.0)
    }
    
    @IBAction func action_testCaseThree(_ sender: AnyObject) {
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.bluredBackground = true
        ALLoadingView.manager.showLoadingViewOfType(.messageWithIndicatorAndCancelButton, windowMode: .fullscreen, completionBlock: nil)
        ALLoadingView.manager.cancelCallback = {
            ALLoadingView.manager.hideLoadingView()
        }
    }
    
    @IBAction func action_testCaseFour(_ sender: AnyObject) {
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.showLoadingViewOfType(.progress) {
            (finished) -> Void in
            ALLoadingView.manager.updateProgressLoadingViewWithMessage("Initializing", forProgress: 0.05)
            self.step = 1
            self.updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateProgress), userInfo: nil, repeats: true)
        }
    }
    
    func updateProgress() {
        let steps = ["Initializing", "Downloading data", "Extracting files", "Parsing data", "Updating database", "Saving"]
        ALLoadingView.manager.updateProgressLoadingViewWithMessage(steps[step], forProgress: 0.2 * Float(step))
        step += 1
        if step == steps.count {
            ALLoadingView.manager.hideLoadingView()
            updateTimer.invalidate()
        }
    }
}

