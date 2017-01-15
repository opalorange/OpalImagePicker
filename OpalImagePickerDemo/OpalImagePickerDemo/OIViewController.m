//
//  OIViewController.m
//  OpalImagePickerDemo
//
//  Created by Kris Katsanevas on 1/15/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

#import "OIViewController.h"
@import OpalImagePicker;

@interface OIViewController () <OpalImagePickerControllerDelegate>

@end

@implementation OIViewController

- (IBAction)photoLibraryTapped:(id)sender {
    //Example instantiating OpalImagePickerController with delegate
    OpalImagePickerController *imagePicker = [[OpalImagePickerController alloc] init];
    imagePicker.imagePickerDelegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

-(void)imagePicker:(OpalImagePickerController *)picker didFinishPickingAssets:(NSArray<PHAsset *> *)assets {
    //TODO: Save Images, update UI
    
    //Dismiss Controller
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerDidCancel:(OpalImagePickerController *)picker {
    //TODO: Cancel action?
    
}

@end
