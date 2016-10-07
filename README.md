# ALLoadingView

[![Version](https://img.shields.io/cocoapods/v/ALLoadingView.svg?style=flat)](http://cocoapods.org/pods/ALLoadingView)
![Min iOS Version](https://img.shields.io/badge/iOS%20version-9.0%2B-green.svg)
[![License](https://img.shields.io/cocoapods/l/ALLoadingView.svg?style=flat)](http://cocoapods.org/pods/ALLoadingView)
[![Platform](https://img.shields.io/cocoapods/p/ALLoadingView.svg?style=flat)](http://cocoapods.org/pods/ALLoadingView)
[![Language](https://img.shields.io/badge/Swift-3.0-orange.svg)](http://cocoapods.org/pods/ALLoadingView)

### Description
`ALLoadingView` is a class for displaying pop-up views to notify users that some work is in progress. Written in `Swift 3`

### Versions
`1.0.0+` supports Swift 3 version, `0.1.4` - Swift 2.2 

[![ALLV Screenshot 1](http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot1-thumb.png)](http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot1.png)
[![ALLV Screenshot 2](http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot2-thumb.png)](http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot2.png)
[![ALLV Screenshot 3](http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot3-thumb.png)](http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot3.png)

### Requirements

- iOS 9.0+
- Xcode 8.0+
- Swift 3.0+

### Testing the project
To test the project, just run `ALLoadingView.xcodeproj`

You can check the project on [CocoaControls project page](https://www.cocoacontrols.com/controls/alloadingview) or directly at [Appetize.io page](https://appetize.io/app/0p8hwrukfhq096bz8nzu29e5aw?device=iphone5s&scale=75&orientation=portrait&osVersion=8.4).

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
> Following examples are working on version 1.0.0+.

#### Simple loading view with activity indicator 
```swift
ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .windowed)
ALLoadingView.manager.hideLoadingView(withDelay: 2.0)
```
#### Loading view with blurred background and button to cancel
```swift
ALLoadingView.manager.blurredBackground = true
ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator, windowMode: .fullscreen)
ALLoadingView.manager.cancelCallback = {
    ALLoadingView.manager.hideLoadingView()
}
```
#### Resetting values to defaults
Loading view manager class is made as a singleton, so you can set different settings for loading view at various parts of your application.
```swift
ALLoadingView.manager.resetToDefaults()
```

### Contact

- [GitHub](http://github.com/ALoginov)
- [Twitter](http://twitter.com/ibvene)
- [Email](mailto:artemloginov@dilarc.com)

### License

#### MIT License

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
