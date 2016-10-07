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

public typealias ALLVCompletionBlock = () -> Void
public typealias ALLVCancelBlock = () -> Void

public enum ALLVType {
    case basic
    case message
    case messageWithIndicator
    case messageWithIndicatorAndCancelButton
    case progress
}

public enum ALLVWindowMode {
    case fullscreen
    case windowed
}

private enum ALLVProgress {
    case hidden
    case initializing
    case viewReady
    case loaded
    case hiding
}

// building blocks
private enum ALLVViewType {
    case blankSpace
    case messageLabel
    case progressBar
    case cancelButton
    case activityIndicator
}

public class ALLoadingView: NSObject {
    //MARK: - Public variables
    public var animationDuration: TimeInterval = 0.5
    public var cornerRadius: CGFloat = 0.0
    public var cancelCallback: ALLVCancelBlock?
    public var blurredBackground: Bool = false
    public lazy var backgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.5)
    public lazy var textColor: UIColor = UIColor(white: 1.0, alpha: 1.0)
    public lazy var messageFont: UIFont = UIFont.systemFont(ofSize: 25.0)
    public lazy var messageText: String = "Loading"
    
    //MARK: Adjusment
    public var windowRatio: CGFloat = 0.4 {
        didSet {
            windowRatio = min(max(0.3, windowRatio), 1.0)
        }
    }
    
    //MARK: - Private variables
    private var loadingViewProgress: ALLVProgress
    private var loadingViewType: ALLVType
    private var loadingView: UIView = UIView()
    private var operationQueue = OperationQueue()
    
    //MARK: Custom setters/getters
    private var loadingViewWindowMode: ALLVWindowMode {
        didSet {
            if loadingViewWindowMode == .fullscreen {
                cornerRadius = 0.0
            } else  {
                blurredBackground = false
                if cornerRadius == 0.0 {
                    cornerRadius = 10.0
                }
            }
        }
    }
    
    private var frameForView: CGRect {
        if loadingViewWindowMode == .fullscreen || windowRatio == 1.0 {
            return UIScreen.main.bounds
        } else {
            let bounds = UIScreen.main.bounds;
            let size = min(bounds.width, bounds.height)
            return CGRect(x: 0, y: 0, width: size * windowRatio, height: size * windowRatio)
        }
    }
    
    private var isUsingBlurEffect: Bool {
        return self.loadingViewWindowMode == .fullscreen && self.blurredBackground
    }
    
    //MARK: - Initialization
    public class var manager: ALLoadingView {
        struct Singleton {
            static let instance = ALLoadingView()
        }
        return Singleton.instance
    }
    
    override init() {
        loadingViewWindowMode = .fullscreen
        loadingViewProgress = .hidden
        loadingViewType = .basic
    }
    
    //MARK: - Public methods
    //MARK: Show loading view
    public func showLoadingView(ofType type: ALLVType, windowMode: ALLVWindowMode? = nil, completionBlock: ALLVCompletionBlock? = nil) {
        assert(loadingViewProgress == .hidden || loadingViewProgress == .hiding, "ALLoadingView Presentation Error. Trying to push loading view while there is one already presented")
        
        loadingViewProgress = .initializing
        loadingViewWindowMode = windowMode ?? .fullscreen
        loadingViewType = type
        
        let operationInit = BlockOperation { () -> Void in
            DispatchQueue.main.async {
                self.initializeLoadingView()
            }
        }
        
        let operationShow = BlockOperation { () -> Void in
            DispatchQueue.main.async {
                UIApplication.shared.windows[0].addSubview(self.loadingView)
                self.updateSubviewsTitles()
                self.animateLoadingViewAppearance(withCompletion: completionBlock)
            }
        }
        
        operationShow.addDependency(operationInit)
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.addOperations([operationInit, operationShow], waitUntilFinished: false)
    }
    
    private func animateLoadingViewAppearance(withCompletion completionBlock: ALLVCompletionBlock? = nil) {
        self.updateContentViewAlphaValue(0.0)
        UIView.animate(withDuration: self.animationDuration, animations: { () -> Void in
            self.updateContentViewAlphaValue(1.0)
        }) { finished -> Void in
            if finished {
                self.loadingViewProgress = .loaded
                completionBlock?()
            }
        }
    }
    
    //MARK: Hiding loading view
    public func hideLoadingView(withDelay delay: TimeInterval? = nil, completionBlock: ALLVCompletionBlock? = nil) {
        let delayValue : TimeInterval = delay ?? 0.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delayValue * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.loadingViewProgress = .hiding
            self.animateLoadingViewDisappearance(withCompletion: completionBlock)
        }
    }
    
    private func animateLoadingViewDisappearance(withCompletion completionBlock: ALLVCompletionBlock? = nil) {
        if isUsingBlurEffect {
            self.loadingViewProgress = .hidden
            self.loadingView.removeFromSuperview()
            completionBlock?()
            self.freeViewData()
        } else {
            UIView.animate(withDuration: self.animationDuration, animations: { () -> Void in
                self.loadingView.alpha = 0.0
            }) { finished -> Void in
                if finished {
                    self.loadingViewProgress = .hidden
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
        self.loadingView = UIView(frame: CGRect.zero);
    }
    
    //MARK: Reset to defaults
    public func resetToDefaults() {
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        self.textColor = UIColor(white: 1.0, alpha: 1.0)
        self.messageFont = UIFont.systemFont(ofSize: 25.0)
        self.blurredBackground = false
        self.animationDuration = 0.5
        self.messageText = "Loading"
        self.cornerRadius = 0.0
        self.windowRatio = 0.4
        //
        self.loadingViewWindowMode = .fullscreen
        self.loadingViewType = .basic
    }
    
    //MARK: Updating subviews data
    public func updateProgressLoadingView(withMessage message: String, forProgress progress: Float) {
        guard self.loadingViewProgress == .loaded else {
            return
        }
        assert(loadingViewType == .progress, "ALLoadingView Update Error. Set ALLVType to 'Progress' to access progress bar.")
        
        DispatchQueue.main.async {
            self.progress_updateProgressControls(withData: ["message": message, "progress" : progress])
        }
    }
    
    public func progress_updateProgressControls(withData data: NSDictionary) {
        let message = data["message"] as? String ?? ""
        let progress = data["progress"] as? Float ?? 0.0
        
        for view in self.loadingViewSubviews() {
            if view.responds(to: #selector(setter: UILabel.text)) {
                (view as! UILabel).text = message
            }
            if view.responds(to: #selector(setter: UIProgressView.progress)) {
                (view as! UIProgressView).progress = progress
            }
        }
    }
    
    public func updateMessageLabel(withText message: String) {
        assert(loadingViewType == .message ||
            loadingViewType == .messageWithIndicator ||
            loadingViewType == .messageWithIndicatorAndCancelButton, "ALLoadingView Update Error. Set .Message, .MessageWithIndicator and .MessageWithIndicatorAndCancelButton type to access message label.")
        
        DispatchQueue.main.async {
            self.progress_updateProgressControls(withData: ["message": message])
        }
    }
    
    private func updateSubviewsTitles() {
        let subviews: [UIView] = self.loadingViewSubviews()
        
        switch self.loadingViewType {
        case .message, .messageWithIndicator:
            for view in subviews {
                if view.responds(to: #selector(setter: UILabel.text)) {
                    (view as! UILabel).text = self.messageText
                }
            }
            break
        case .messageWithIndicatorAndCancelButton:
            for view in subviews {
                if view is UIButton {
                    (view as! UIButton).setTitle("Cancel", for: UIControlState())
                    (view as! UIButton).addTarget(self, action: #selector(ALLoadingView.cancelButtonTapped(_:)), for: .touchUpInside)
                }
                if view.responds(to: #selector(setter: UILabel.text)) {
                    (view as! UILabel).text = self.messageText
                }
            }
            break
        case .progress:
            for view in subviews {
                if view.responds(to: #selector(setter: UIProgressView.progress)) {
                    (view as! UIProgressView).progress = 0.0
                    
                }
                if view.responds(to: #selector(setter: UILabel.text)) {
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
    private func initializeLoadingView() {
        if isUsingBlurEffect {
            let lightBlur = UIBlurEffect(style: .dark)
            let lightBlurView = UIVisualEffectView(effect: lightBlur)
            loadingView = lightBlurView
            loadingView.frame = frameForView
        } else {
            loadingView = UIView(frame: frameForView)
            loadingView.backgroundColor = backgroundColor
        }
        loadingView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        loadingView.layer.cornerRadius = cornerRadius
        
        // View has been created. Add subviews according to selected type.
        createSubviewsForLoadingView()
    }
    
    private func createSubviewsForLoadingView() {
        let viewTypes = getSubviewsTypes()
        
        // calculate frame for each view
        let viewsCount: Int = viewTypes.count
        let elementHeight: CGFloat = frameForView.height / CGFloat(viewsCount)
        
        for (index, type) in viewTypes.enumerated() {
            let frame: CGRect = CGRect(x: 0, y: elementHeight * CGFloat(index), width: frameForView.width, height: elementHeight)
            let view = initializeView(withType: type, andFrame: frame)
            
            addSubviewToLoadingView(view)
        }
        
        self.loadingViewProgress = .viewReady
    }
    
    private func getSubviewsTypes() -> [ALLVViewType] {
        switch self.loadingViewType {
        case .basic:
            return [.activityIndicator]
        case .message:
            return [.messageLabel]
        case .messageWithIndicator:
            return [.messageLabel, .activityIndicator]
        case .messageWithIndicatorAndCancelButton:
            if self.loadingViewWindowMode == ALLVWindowMode.windowed {
                return [.messageLabel, .activityIndicator, .cancelButton]
            } else {
                return [.blankSpace, .blankSpace, .messageLabel, .activityIndicator, .blankSpace, .cancelButton]
            }
        case .progress:
            return [.messageLabel, .blankSpace, .progressBar]
        }
    }
    
    //MARK: Loading view accessors & methods
    private func addSubviewToLoadingView(_ subview: UIView) {
        if isUsingBlurEffect {
            // Add subview to content view of UIVisualEffectView
            if let asVisualEffectView = loadingView as? UIVisualEffectView {
                asVisualEffectView.contentView.addSubview(subview)
                asVisualEffectView.contentView.bringSubview(toFront: subview)
            }
        } else {
            loadingView.addSubview(subview)
            loadingView.bringSubview(toFront: subview)
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
    
    private func updateContentViewAlphaValue(_ alpha: CGFloat) {
        if isUsingBlurEffect {
            if let asVisualEffectView = loadingView as? UIVisualEffectView {
                asVisualEffectView.contentView.alpha = alpha
            }
        } else {
            loadingView.alpha = alpha
        }
    }
    
    //MARK: Initializing subviews
    private func initializeView(withType type: ALLVViewType, andFrame frame: CGRect) -> UIView {
        switch type {
        case .messageLabel:
            return view_messageLabel(frame)
        case .activityIndicator:
            return view_activityIndicator(frame)
        case .cancelButton:
            return view_cancelButton(frame)
        case .blankSpace:
            return UIView(frame: frame)
        case .progressBar:
            return view_standardProgressBar(frame)
        }
    }
    
    private func view_activityIndicator(_ frame: CGRect) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.center = CGPoint(x: frame.midX, y: frame.midY)
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    private func view_messageLabel(_ frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.textColor = textColor
        label.font = messageFont
        return label
    }
    
    private func view_cancelButton(_ frame: CGRect) -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = frame
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = UIColor.clear
        return button
    }
    
    private func view_standardProgressBar(_ frame: CGRect) -> UIProgressView {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.frame = frame
        return progressView
    }
    
    //MARK: Subviews actions
    public func cancelButtonTapped(_ sender: AnyObject?) {
        if let _ = sender as? UIButton {
            cancelCallback?()
        }
    }
}
