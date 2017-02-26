![OpalImagePicker](https://github.com/opalorange/OpalImagePicker/blob/master/Resources/OpalImagePickerPresentation.jpg)

[![Version](https://img.shields.io/cocoapods/v/OpalImagePicker.svg?style=flat)](http://cocoadocs.org/docsets/OpalImagePicker)
[![License](https://img.shields.io/cocoapods/l/OpalImagePicker.svg?style=flat)](http://cocoadocs.org/docsets/OpalImagePicker)
![Swift](https://img.shields.io/badge/%20in-swift%203.0-orange.svg)



## Description

**OpalImagePicker** is a multiple selection Image Picker for iOS written in Swift. Meant to be a drop in replacement for UIImagePickerController. Compatible with both Swift and Objective-C.

## Requirements
- Xcode 8
- iOS 8.0+

## Usage

**OpalImagePicker** is presented much like UIImagePickerController. As a normal View Controller.

```swift
let imagePicker = OpalImagePickerController()   
presentOpalImagePickerController(imagePicker, animated: true, 
	select: { (assets) in
		//Select Assets
	}, cancel: {
		//Cancel
	})
```

Or

```swift
let imagePicker = OpalImagePickerController()
imagePicker.imagePickerDelegate = self        
present(imagePicker, animated: true, completion: nil)
```
**OpalImagePicker** has three delegate methods to notify you when images have been selected, or the picker has been cancelled. This is only necessary if you choose not to use the **presentOpalImagePickerController(_:animated:select:cancel:completion:)** function.

```swift
optional func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage])
optional func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset])
optional func imagePickerDidCancel(_ picker: OpalImagePickerController)
```

**OpalImagePicker** supports allowing users to customize user interface features

```swift
let imagePicker = OpalImagePickerController()

//Change color of selection overlay to white
imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)

//Change color of image tint to black
imagePicker.selectionImageTintColor = UIColor.black

//Change image to X rather than checkmark
imagePicker.selectionImage = UIImage(named: "x_image")

//Change status bar style
imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
```

## Installation

**OpalImagePicker** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'OpalImagePicker'
```

## Author

[OpalOrange](http://opalorange.com) made this with ❤

## Contribute

We would love you to contribute to **OpalImagePicker**

## License

**OpalImagePicker** is available under the MIT license. See the [LICENSE](https://github.com/opalorange/OpalImagePicker/blob/master/LICENSE.md) file for more info.
