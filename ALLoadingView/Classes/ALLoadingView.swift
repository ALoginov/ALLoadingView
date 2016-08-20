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

typealias ALLVCompletionBlock = () -> Void
typealias ALLVCancelBlock = () -> Void

public enum ALLVType {
    case Default
    case Message
    case MessageWithIndicator
    case MessageWithIndicatorAndCancelButton
    case Progress
}

public enum ALLVWindowMode {
    case Fullscreen
    case Windowed
}

private enum ALLVProgress {
    case Hidden
    case Initializing
    case ViewReady
    case Loaded
    case Hiding
}

// building blocks
private enum ALLVViewType {
    case BlankSpace
    case MessageLabel
    case ProgressBar
    case CancelButton
    case ActivityIndicator
}

public class ALLoadingView: NSObject {
    //MARK: - Public variables
    var animationDuration: NSTimeInterval = 1.5
    var cornerRadius: CGFloat = 0.0
    var cancelCallback: ALLVCancelBlock?
    var bluredBackground: Bool = false
    lazy var backgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5)
    lazy var textColor: UIColor = UIColor(white: 1.0, alpha: 1.0)
    lazy var messageFont: UIFont = UIFont.systemFontOfSize(25.0)
    lazy var messageText: String = "Loading"
    //MARK: Adjusment
    var windowRatio: CGFloat = 0.4 {
        didSet {
            windowRatio = min(max(0.3, windowRatio), 1.0)
        }
    }
    
    //MARK: - Private variables
    private var loadingViewProgress: ALLVProgress
    private var loadingViewType: ALLVType
    private var loadingView: UIView = UIView()
    private var operationQueue = NSOperationQueue()
    //MARK: Custom setters/getters
    private var loadingViewWindowMode: ALLVWindowMode {
        didSet {
            if loadingViewWindowMode == .Fullscreen {
                cornerRadius = 0.0
            } else  {
                bluredBackground = false
                if cornerRadius == 0.0 {
                    cornerRadius = 10.0
                }
            }
        }
    }
    private var frameForView: CGRect {
        if loadingViewWindowMode == .Fullscreen || windowRatio == 1.0 {
            return UIScreen.mainScreen().bounds
        } else {
            let bounds = UIScreen.mainScreen().bounds;
            let size = min(CGRectGetWidth(bounds), CGRectGetHeight(bounds))
            return CGRectMake(0, 0, size * windowRatio, size * windowRatio)
        }
    }
    private var isUsingBlurEffect: Bool {
        return self.loadingViewWindowMode == .Fullscreen && self.bluredBackground
    }
    
    //MARK: - Initialization
    class var manager: ALLoadingView {
        struct Singleton {
            static let instance = ALLoadingView()
        }
        return Singleton.instance
    }
    
    override init() {
        loadingViewWindowMode = .Fullscreen
        loadingViewProgress = .Hidden
        loadingViewType = .Default
    }
    
    //MARK: - Public methods
    //MARK: Show loading view
    func showLoadingViewOfType(type: ALLVType, completionBlock: ALLVCompletionBlock?) {
        showLoadingViewOfType(type, windowMode: .Fullscreen, completionBlock: completionBlock)
    }
    
    func showLoadingViewOfType(type: ALLVType, windowMode: ALLVWindowMode, completionBlock: ALLVCompletionBlock? = nil) {
        assert(loadingViewProgress == .Hidden || loadingViewProgress == .Hiding, "ALLoadingView Presentation Error. Trying to push loading view while there is one already presented")
        
        loadingViewProgress = .Initializing
        loadingViewWindowMode = windowMode
        loadingViewType = type
        
        let operationInit = NSBlockOperation { () -> Void in
            self.performSelectorOnMainThread(#selector(ALLoadingView.initializeLoadingView), withObject: nil, waitUntilDone: true)
        }
        
        let operationShow = NSBlockOperation { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().windows[0].addSubview(self.loadingView)
                self.updateSubviewsTitles()
                self.animateLoadingViewAppearanceWithCompletionBlock(completionBlock)
            }
        }
        
        operationShow.addDependency(operationInit)
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.addOperations([operationInit, operationShow], waitUntilFinished: false)
    }
    
    private func animateLoadingViewAppearanceWithCompletionBlock(completionBlock: ALLVCompletionBlock? = nil) {
        self.updateContentViewAlphaValue(0.0)
        UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
            self.updateContentViewAlphaValue(1.0)
            }) { finished -> Void in
                if finished {
                    self.loadingViewProgress = .Loaded
                    completionBlock?()
                }
        }
    }
    
    //MARK: Hide loading view
    func hideLoadingView(completionBlock: ALLVCompletionBlock? = nil) {
        hideLoadingViewWithDelay(0.0) { () -> Void in
            completionBlock?()
        }
    }
    
    func hideLoadingViewWithDelay(delay: NSTimeInterval, completionBlock: ALLVCompletionBlock? = nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.loadingViewProgress = .Hiding
            self.animateLoadingViewDisappearanceWithCompletionBlock(completionBlock)
        }
    }
    
    private func animateLoadingViewDisappearanceWithCompletionBlock(completionBlock: ALLVCompletionBlock? = nil) {
        if isUsingBlurEffect {
            self.loadingViewProgress = .Hidden
            self.loadingView.removeFromSuperview()
            completionBlock?()
            self.freeViewData()
        } else {
            UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
                self.loadingView.alpha = 0.0
                }) { finished -> Void in
                    if finished {
                        self.loadingViewProgress = .Hidden
                        self.loadingView.removeFromSuperview()
                        completionBlock?()
                        self.freeViewData()
                    }
            }
        }
    }
    
    private func freeViewData() {
        // View is hidden, now free memory
        for subview in loadingViewSubviews() {
            subview.removeFromSuperview()
        }
        self.loadingView = UIView(frame: CGRectZero);
    }
    
    //MARK: Reset to defaults
    func resetToDefaults() {
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        self.textColor = UIColor(white: 1.0, alpha: 1.0)
        self.messageFont = UIFont.systemFontOfSize(25.0)
        self.bluredBackground = false
        self.animationDuration = 0.5
        self.messageText = "Loading"
        self.cornerRadius = 0.0
        self.windowRatio = 0.4
        //
        self.loadingViewWindowMode = .Fullscreen
        self.loadingViewType = .Default
    }
    
    //MARK: Updating subviews data
    func updateProgressLoadingViewWithMessage(message: String, forProgress progress: Float) {
        guard self.loadingViewProgress == .Loaded else {
            return
        }
        assert(loadingViewType == .Progress, "ALLoadingView Update Error. Set Progress type to access progress bar.")
        
        performSelectorOnMainThread(#selector(ALLoadingView.progress_updateProgressControlsWithData(_:)), withObject: ["message": message, "progress" : progress], waitUntilDone: true)
    }
    
    func progress_updateProgressControlsWithData(data: NSDictionary) {
        let message = data["message"] as? String ?? ""
        let progress = data["progress"] as? Float ?? 0.0
        
        for view in self.loadingViewSubviews() {
            if view.respondsToSelector(Selector("setText:")) {
                (view as! UILabel).text = message
            }
            if view.respondsToSelector(Selector("setProgress:")) {
                (view as! UIProgressView).progress = progress
            }
        }
    }
    
    func updateMessageLabelWithText(message: String) {
        assert(loadingViewType == .Message ||
               loadingViewType == .MessageWithIndicator ||
               loadingViewType == .MessageWithIndicatorAndCancelButton, "ALLoadingView Update Error. Set .Message, .MessageWithIndicator and .MessageWithIndicatorAndCancelButton type to access message label.")
        
        performSelectorOnMainThread(#selector(ALLoadingView.progress_updateProgressControlsWithData(_:)), withObject: ["message": message], waitUntilDone: true)
    }
    
    private func updateSubviewsTitles() {
        let subviews: [UIView] = self.loadingViewSubviews()
        
        switch self.loadingViewType {
        case .Message, .MessageWithIndicator:
            for view in subviews {
                if view.respondsToSelector(Selector("setText:")) {
                    (view as! UILabel).text = self.messageText
                }
            }
            break
        case .MessageWithIndicatorAndCancelButton:
            for view in subviews {
                if view.respondsToSelector(Selector("setTitle:")) {
                    (view as! UIButton).setTitle("Cancel", forState: .Normal)
                    (view as! UIButton).addTarget(self, action: #selector(ALLoadingView.cancelButtonTapped(_:)), forControlEvents: .TouchUpInside)
                }
                if view.respondsToSelector(Selector("setText:")) {
                    (view as! UILabel).text = self.messageText
                }
            }
            break
        case .Progress:
            for view in subviews {
                if view.respondsToSelector(Selector("setProgress:")) {
                    (view as! UIProgressView).progress = 0.0
                    
                }
                if view.respondsToSelector(Selector("setText:")) {
                    (view as! UILabel).text = self.messageText
                }
            }
            break
        default:
            break
        }
    }
    
    //MARK: - Private methods
    //MARK: Initialize view
    func initializeLoadingView() {
        if isUsingBlurEffect {
            let lightBlur = UIBlurEffect(style: .Dark)
            let lightBlurView = UIVisualEffectView(effect: lightBlur)
            loadingView = lightBlurView
            loadingView.frame = frameForView
        } else {
            loadingView = UIView(frame: frameForView)
            loadingView.backgroundColor = backgroundColor
        }
        loadingView.center = CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))
        loadingView.layer.cornerRadius = cornerRadius
        
        // View has been created. Add subviews according to selected type.
        createSubviewsForLoadingView()
    }
    
    private func createSubviewsForLoadingView() {
        let viewTypes = getSubviewsTypes()
        
        // calculate frame for each view
        let viewsCount: Int = viewTypes.count
        let elementHeight: CGFloat = CGRectGetHeight(frameForView) / CGFloat(viewsCount)
        
        for (index, type) in viewTypes.enumerate() {
            let frame: CGRect = CGRectMake(0, elementHeight * CGFloat(index), CGRectGetWidth(frameForView), elementHeight)
            let view = initializeViewWithType(type, andFrame: frame)
            
            addSubviewToLoadingView(view)
        }
        
        self.loadingViewProgress = .ViewReady
    }
    
    private func getSubviewsTypes() -> [ALLVViewType] {
        switch self.loadingViewType {
        case .Default:
            return [.ActivityIndicator]
        case .Message:
            return [.MessageLabel]
        case .MessageWithIndicator:
            return [.MessageLabel, .ActivityIndicator]
        case .MessageWithIndicatorAndCancelButton:
            if self.loadingViewWindowMode == ALLVWindowMode.Windowed {
                return [.MessageLabel, .ActivityIndicator, .CancelButton]
            } else {
                return [.BlankSpace, .BlankSpace, .MessageLabel, .ActivityIndicator, .BlankSpace, .CancelButton]
            }
        case .Progress:
            return [.MessageLabel, .BlankSpace, .ProgressBar]
        }
    }
    
    //MARK: Loading view accessors & methods
    private func addSubviewToLoadingView(subview: UIView) {
        if isUsingBlurEffect {
            // Add subview to content view of UIVisualEffectView
            if let asVisualEffectView = loadingView as? UIVisualEffectView {
                asVisualEffectView.contentView.addSubview(subview)
                asVisualEffectView.contentView.bringSubviewToFront(subview)
            }
        } else {
            loadingView.addSubview(subview)
            loadingView.bringSubviewToFront(subview)
        }
    }
    
    private func loadingViewSubviews() -> [UIView] {
        if isUsingBlurEffect {
            if let asVisualEffectView = loadingView as? UIVisualEffectView {
                return asVisualEffectView.contentView.subviews
            }
        }
        return loadingView.subviews
    }
    
    private func updateContentViewAlphaValue(alpha: CGFloat) {
        if isUsingBlurEffect {
            if let asVisualEffectView = loadingView as? UIVisualEffectView {
                asVisualEffectView.contentView.alpha = alpha
            }
        } else {
            loadingView.alpha = alpha
        }
    }
    
    //MARK: Initializing subviews
    private func initializeViewWithType(type: ALLVViewType, andFrame frame: CGRect) -> UIView {
        switch type {
        case .MessageLabel:
            return view_messageLabel(frame)
        case .ActivityIndicator:
            return view_activityIndicator(frame)
        case .CancelButton:
            return view_cancelButton(frame)
        case .BlankSpace:
            return UIView(frame: frame)
        case .ProgressBar:
            return view_standardProgressBar(frame)
        }
    }
    
    private func view_activityIndicator(frame: CGRect) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    private func view_messageLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.textAlignment = .Center
        label.textColor = textColor
        label.font = messageFont
        return label
    }
    
    private func view_cancelButton(frame: CGRect) -> UIButton {
        let button = UIButton(type: .Custom)
        button.frame = frame
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.backgroundColor = .clearColor()
        return button
    }
    
    private func view_standardProgressBar(frame: CGRect) -> UIProgressView {
        let progressView = UIProgressView(progressViewStyle: .Default)
        progressView.frame = frame
        return progressView
    }
    
    //MARK: Subviews actions
    func cancelButtonTapped(sender: AnyObject?) {
        if let _ = sender as? UIButton {
            cancelCallback?()
        }
    }
}