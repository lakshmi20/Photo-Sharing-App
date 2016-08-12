//
//  SecondViewController.h
//  lakshmis_iOS_HW6
//
//  Created by Lakshmi Subramanian on 6/29/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Accounts/Accounts.h"
#import "Social/Social.h"


@interface SecondViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate >
{
    
    IBOutlet UIImageView *ImageView;
    UIImagePickerController *picker;
    UIImage *image;
    
    SLComposeViewController *mySLComposer;
}

- (IBAction)tweetPhoto:(id)sender;
- (IBAction)takePhoto:(id)sender;


@end

