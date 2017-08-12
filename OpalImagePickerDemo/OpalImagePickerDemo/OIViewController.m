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
    imagePicker.maximumSelectionsAllowed = 10;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

-(void)imagePickerDidCancel:(OpalImagePickerController *)picker {
    //TODO: Cancel action?
    
}

-(void)imagePicker:(OpalImagePickerController *)picker didFinishPickingImages:(NSArray<UIImage *> *)images {
    //TODO: Save Images, update UI
    
    //Dismiss Controller
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
}

-(NSInteger)imagePickerNumberOfExternalItems:(OpalImagePickerController *)picker {
    return 100;
}

-(NSString *)imagePickerTitleForExternalItems:(OpalImagePickerController *)picker {
    return NSLocalizedString(@"External", @"External (title for UISegmentedControl)");
}

-(NSURL *)imagePicker:(OpalImagePickerController *)picker imageURLforExternalItemAtIndex:(NSInteger)index {
    return [NSURL URLWithString:@"https://placeimg.com/500/500/nature"];
}

@end
