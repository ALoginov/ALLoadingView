# ALLoadingView

[![Version](https://img.shields.io/cocoapods/v/ALLoadingView.svg?style=flat)](http://cocoapods.org/pods/ALLoadingView)
[![License](https://img.shields.io/cocoapods/l/ALLoadingView.svg?style=flat)](http://cocoapods.org/pods/ALLoadingView)
[![Platform](https://img.shields.io/cocoapods/p/ALLoadingView.svg?style=flat)](http://cocoapods.org/pods/ALLoadingView)
[![Language](https://img.shields.io/badge/Swift-2.2-orange.svg)](http://cocoapods.org/pods/ALLoadingView)

`ALLoadingView` is a class for displaying pop-up views to notify users that some work is in progress. Written in `Swift 2.2`

[![ALLV Screenshot 1](http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot1-thumb.png)](http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot1.png)
[![ALLV Screenshot 2](http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot2-thumb.png)](http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot2.png)
[![ALLV Screenshot 3](http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot3-thumb.png)](http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot3.png)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation
### Manually
* Drag the `ALLoadingView.swift` file into your project

### CocoaPods
ALLoadingView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ALLoadingView"
```

## Usage
### Simple loading view with activity indicator 
```swift
ALLoadingView.manager.showLoadingViewOfType(.Default, windowMode: .Windowed, completionBlock: nil)
ALLoadingView.manager.hideLoadingViewWithDelay(2.0)
```
### Loading view with blurred background and button to cancel
```swift
ALLoadingView.manager.blurredBackground = true
ALLoadingView.manager.showLoadingViewOfType(.MessageWithIndicatorAndCancelButton, windowMode: .Fullscreen, completionBlock: nil)
ALLoadingView.manager.cancelCallback = {
    ALLoadingView.manager.hideLoadingView()
}
```
### Resetting values to defaults
Loading view manager class is made as a singleton, so you can set different settings for loading view at various parts of your application. To drop settings, call `-resetToDefaults()`

## Contact

- [GitHub](http://github.com/ALoginov)
- [Twitter](http://twitter.com/ibvene)
- [Email](mailto:artemloginov@dilarc.com)

## License

### MIT License

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