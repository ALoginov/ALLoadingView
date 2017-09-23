# ALLoadingView

[![Version](https://img.shields.io/cocoapods/v/ALLoadingView.svg?style=flat)](http://cocoapods.org/pods/ALLoadingView)
![Min iOS Version](https://img.shields.io/badge/iOS%20version-9.0%2B-green.svg)
[![License](https://img.shields.io/cocoapods/l/ALLoadingView.svg?style=flat)](http://cocoapods.org/pods/ALLoadingView)
[![Platform](https://img.shields.io/cocoapods/p/ALLoadingView.svg?style=flat)](http://cocoapods.org/pods/ALLoadingView)
[![Language](https://img.shields.io/badge/Swift-3.0-orange.svg)](http://cocoapods.org/pods/ALLoadingView)

## Description
`ALLoadingView` is a class for displaying pop-up views to notify users that some work is in progress. Written in `Swift 3`

### Latest release [1.1.4]
- UIStackView is used for positioning subviews
- `itemSpacing` property introduced to edit spacing of elements in stack view
- `isPresented` read-only flag for checking loading view state
- For more information, see [Changelog](https://github.com/ALoginov/ALLoadingView/blob/master/CHANGELOG.md)

## Versions
- `1.1.4+` - Swift 4.x
- `1.0.0` - Swift 3.x
- `0.1.4` - Swift 2.2 

[![ALLV Screenshot 1](https://github.com/ALoginov/ALLoadingView/blob/master/images/ALLV-screenshot1-thumb.png)](https://github.com/ALoginov/ALLoadingView/blob/master/images/ALLV-screenshot1.png)
[![ALLV Screenshot 2](https://github.com/ALoginov/ALLoadingView/blob/master/images/ALLV-screenshot2-thumb.png)](https://github.com/ALoginov/ALLoadingView/blob/master/images/ALLV-screenshot2.png)
[![ALLV Screenshot 3](https://github.com/ALoginov/ALLoadingView/blob/master/images/ALLV-screenshot3-thumb.png)](https://github.com/ALoginov/ALLoadingView/blob/master/images/ALLV-screenshot3.png)

## Requirements

- iOS 9.0+
- Xcode 8.0+
- Swift 3.0+

## Testing the project
To test the project, just run `ALLoadingView.xcodeproj`

You can check the project on [CocoaControls project page](https://www.cocoacontrols.com/controls/alloadingview) or directly at [Appetize.io page](https://appetize.io/app/0p8hwrukfhq096bz8nzu29e5aw?device=iphone5s&scale=75&orientation=portrait&osVersion=8.4).

## Installation
### Manually
* Drag the `ALLoadingView.swift` file into your project

### CocoaPods
ALLoadingView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ALLoadingView'
```

## Available types of loading views
Currently there are 6 types available:
- `.basic`: small white activity indicator in the center
- `.message`: UITextView with text specified by `.messageText` property
- `.messageWithIndicator`: UITextView with activity indicator
- `.messageWithIndicatorAndCancelButton`: UITextView with activity indicat and button. Assign `.cancelCallback` property to edit button action.
- `.progress`: UITextView with default UIProgressView (2px height)
- `.progressWithCancelButton`: UITextView with default UIProgressView and cancel button

## Usage
> Following examples are working on version 1.0.0+.

#### Showing loading view 
For presenting ALLoadingView you should call `showLoadingView` function. At least you have to specify `ALLVType` of loading view. `ALLVWindowType` and `completionBlock` are optional.
```swift
// Specifying only type
ALLoadingView.manager.showLoadingView(ofType: .basic)
// Type and window mode
ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .fullscreen)
// Type, window mode, completion block
ALLoadingView.manager.showLoadingView(ofType: .basic) {
    finished in

}
```

#### Simple loading view with activity indicator 
```swift
ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .windowed)
ALLoadingView.manager.hideLoadingView(withDelay: 2.0)
```
#### Loading view with blurred background and button to cancel
```swift
ALLoadingView.manager.blurredBackground = true
ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicatorAndCancelButton, windowMode: .fullscreen)
ALLoadingView.manager.cancelCallback = {
    ALLoadingView.manager.hideLoadingView()
}
```

#### Adjusting apperance 
Size of loading view in windowed mode can be adjusted with `windowRatio` property. It takes values from `0.4` to `1.0` to represent
window sizes from 40% to 100% percent of screen.
```swift
ALLoadingView.manager.windowRatio = 0.6
```

Elements positions can be adjusted with `itemSpacing` property. Default value is 20. Bigger value will increase 
spacing between elements (text view, progress view etc). Negative value will lead to overlapping.
```swift
ALLoadingView.manager.itemSpacing = 50.0
```

#### Resetting values to defaults
Loading view manager class is made as a singleton, so you can set different settings for loading view at various parts of your application.
```swift
ALLoadingView.manager.resetToDefaults()
```

## Contact

- [GitHub](http://github.com/ALoginov)
- [Twitter](http://twitter.com/ibvene)
- [Email](mailto:artemloginov@dilarc.com)

## License

#### MIT License

Copyright (c) 2015-2017 Artem Loginov

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
