## [1.1.0](https://github.com/ALoginov/ALLoadingView/releases/tag/v1.1.0)
Released on 12/01/2017

#### Added
- `itemSpacing` property is now responsible for spacing between items at UIStackView

#### Updated
- Autolayout mechanism is now in place replacing equal frames for subviews
- Subviews are placed into UIStackView to control their positioning
- Frame of subview (activity indicator, text view or button) is determined by its content size
- UILabel subview was replaced with UITextView

#### Fixed
- Loading view layout updated on rotation. [iFreedive](https://github.com/iFreedive) [#0004](https://github.com/ALoginov/ALLoadingView/issues/4)

## [1.0.2](https://github.com/ALoginov/ALLoadingView/releases/tag/1.0.2)
Released on 09/10/2016

#### Added
- Versions 1.0.0+ support Swift 3

#### Updated
- `default` ALLVType replaced with `basic`
- Method namings updated according to Swift 3 name conventions:
    - Before `.showLoadingViewOfType(.Default, windowMode: .Windowed, completionBlock: nil)`
    - After `.showLoadingView(ofType: .basic, windowMode: .windowed)`

#### Fixed
- Animation blocks are forced to be performed on main thread

## [0.1.4](https://github.com/ALoginov/ALLoadingView/releases/tag/0.1.4)
Released on 26/08/2016