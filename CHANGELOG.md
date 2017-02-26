## [1.1.3](https://github.com/ALoginov/ALLoadingView/releases/tag/1.1.3)
Released on 26/02/2017

#### Added
- Implementation example for `.progressWithCancelButton` loading view type

#### Updated
- Message for content size assert check. It will inform you about aggregate content size and stack view size
- Documentation updated

#### Removed
- Couple of assert checks for loading view state, prevented UI updates during apperance/disappearance animation. 

## [1.1.2](https://github.com/ALoginov/ALLoadingView/releases/tag/1.1.2)
Released on 27/01/2017

#### Added
- Documentation added (check `index.html` in /docs folder)

## [1.1.1](https://github.com/ALoginov/ALLoadingView/releases/tag/1.1.1)
Released on 24/01/2017

#### Added
- `isPresented` read-only flag for checking loading view state
- `.progressWithCancelButton` added to the list of available `ALLVTypes` [iFreedive](https://github.com/iFreedive) [#0003](https://github.com/ALoginov/ALLoadingView/issues/3)

#### Updated
- Readme file updated with more examples of ALLV usage

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