//
//  OpalImagePickerControllerTest.swift
//  OpalImagePicker
//
//  Created by Kristos Katsanevas on 1/16/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import XCTest
import OpalImagePicker

class OpalImagePickerControllerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetImagePickerDelegate() {
        let mockDelegate = MockOpalImagePickerControllerDelegate()
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = mockDelegate
        
        let rootVC = imagePicker.viewControllers[0] as? OpalImagePickerRootViewController
        XCTAssert(mockDelegate === rootVC?.delegate)
    }
    
    func testSetSelectionTintColor() {
        let tintColor = UIColor.brown
        let imagePicker = OpalImagePickerController()
        imagePicker.selectionTintColor = tintColor
        
        let rootVC = imagePicker.viewControllers[0] as? OpalImagePickerRootViewController
        XCTAssertEqual(tintColor, rootVC?.selectionTintColor)
    }
    
    func testSetSelectionImageTintColor() {
        let tintColor = UIColor.brown
        let imagePicker = OpalImagePickerController()
        imagePicker.selectionImageTintColor = tintColor
        
        let rootVC = imagePicker.viewControllers[0] as? OpalImagePickerRootViewController
        XCTAssertEqual(tintColor, rootVC?.selectionImageTintColor)
    }
    
    func testSetSelectionImage() {
        let image = UIImage()
        let imagePicker = OpalImagePickerController()
        imagePicker.selectionImage = image
        
        let rootVC = imagePicker.viewControllers[0] as? OpalImagePickerRootViewController
        XCTAssertEqual(image, rootVC?.selectionImage)
    }
    
    func testInit() {
        let imagePicker = OpalImagePickerController()
        XCTAssert(imagePicker.viewControllers[0] is OpalImagePickerRootViewController)
    }
    
    func testInitNib() {
        let imagePicker = OpalImagePickerController(nibName: "", bundle: nil)
        XCTAssertNotNil(imagePicker)
    }
}
