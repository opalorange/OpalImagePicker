//
//  OpalImagePickerRootViewControllerTest.swift
//  OpalImagePicker
//
//  Created by Kristos Katsanevas on 1/16/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import XCTest
import Photos
@testable import OpalImagePicker

class OpalImagePickerRootViewControllerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetCustomUI() {
        let image = UIImage()
        let imagePicker = OpalImagePickerRootViewController()
        imagePicker.selectionTintColor = UIColor.brown
        imagePicker.selectionImageTintColor = UIColor.yellow
        imagePicker.selectionImage = image
        
        XCTAssertEqual(UIColor.brown, imagePicker.selectionTintColor)
        XCTAssertEqual(UIColor.yellow, imagePicker.selectionImageTintColor)
        XCTAssert(imagePicker.selectionImage === image)
    }
    
    func testGetCollectionViewLayout() {
        let imagePicker = OpalImagePickerRootViewController()
        if #available(iOS 9.0, *) {
            imagePicker.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
            imagePicker.loadView()
        }
        XCTAssertNotNil(imagePicker.collectionViewLayout)
    }
    
    func testGetFetchOptions() {
        let imagePicker = OpalImagePickerRootViewController()
        if #available(iOS 9.0, *) {
            imagePicker.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
            imagePicker.loadView()
        }
        let fetchOptions = imagePicker.fetchOptions
        let sortDescriptors = fetchOptions.sortDescriptors?.filter { $0.key == "creationDate" }
        XCTAssertEqual(sortDescriptors?.count, 1)
        XCTAssertEqual(sortDescriptors?.first?.ascending, false)
    }
    
    func testGetFetchLimit() {
        let imagePicker = OpalImagePickerRootViewController()
        if #available(iOS 9.0, *) {
            imagePicker.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
            imagePicker.loadView()
        }
        
        if #available(iOS 9.0, *) {
            imagePicker.fetchLimit = 5
            XCTAssertEqual(imagePicker.fetchOptions.fetchLimit, 5)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func testSetFetchLimit() {
        let imagePicker = OpalImagePickerRootViewController()
        if #available(iOS 9.0, *) {
            imagePicker.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
            imagePicker.loadView()
        }
        
        if #available(iOS 9.0, *) {
            imagePicker.fetchLimit = 5
            XCTAssertEqual(imagePicker.fetchOptions.fetchLimit, 5)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func testInit() {
        let imagePicker = OpalImagePickerRootViewController()
        XCTAssertNotNil(imagePicker)
    }
    
    func testSetup() {
        let imagePicker = OpalImagePickerRootViewController()
        if #available(iOS 9.0, *) {
            imagePicker.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
            imagePicker.loadView()
        }
        
        XCTAssertNotNil(imagePicker.collectionView)
        XCTAssertNotNil(imagePicker.collectionViewLayout)
        XCTAssertEqual(imagePicker.fetchLimit, imagePicker.pageSize)
    }
    
    func testDoneTapped() {
        let mockDelegate = MockOpalImagePickerControllerDelegate()
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = mockDelegate
        let rootVC = imagePicker.viewControllers[0] as! OpalImagePickerRootViewController
        rootVC.doneTapped()
        XCTAssertFalse(mockDelegate.isDidFinishPickingAssetsCalled)
        
        if #available(iOS 9.0, *) {
            imagePicker.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
            imagePicker.loadView()
        }
        rootVC.doneTapped()
        XCTAssertTrue(mockDelegate.isDidFinishPickingAssetsCalled)
    }
    
    func testCollectionViewDidSelectItem() {
        let imagePicker = OpalImagePickerController()
        let rootVC = imagePicker.viewControllers[0] as! OpalImagePickerRootViewController
        if #available(iOS 9.0, *) {
            imagePicker.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
            imagePicker.loadView()
        }
        let indexPath = IndexPath(item: 0, section: 0)
        
        rootVC.doneButton!.isEnabled = true
        rootVC.collectionView(rootVC.collectionView!, didSelectItemAt: indexPath)
        XCTAssertFalse(rootVC.doneButton!.isEnabled)
        
        rootVC.doneButton!.isEnabled = true
        rootVC.collectionView(rootVC.collectionView!, didDeselectItemAt: indexPath)
        XCTAssertFalse(rootVC.doneButton!.isEnabled)
    }
}
