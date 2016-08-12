//
//  SecondViewController.m
//  sample camera
//
//  Created by Lakshmi Subramanian on 7/8/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import "SecondViewController.h"
#import "Social/Social.h"
#import "Accounts/Accounts.h"

@interface SecondViewController ()


@end

@implementation SecondViewController
int flag = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    
    picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)tweetPhoto:(id)sender {
    
    if(flag == 1){
    
    /*mySLComposer=[[SLComposeViewController alloc]init];
    mySLComposer=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [mySLComposer setInitialText:@"Enter a Text"] ;
    [mySLComposer addImage: ImageView.image];
   */
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        
    {
        
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSDate *date = [[NSDate alloc]init];
        
        //Declare Date Formatter to format date according to problem
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
        
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        NSString *OSVersion = (NSString *)[[UIDevice currentDevice] systemVersion];
        
        NSString *DeviceInfo = (NSString *)[[UIDevice currentDevice] model];
        
        NSString *andrewID = @"lakshmis";
        
        [tweetSheet setInitialText: [NSString stringWithFormat:@"%@ %@ %@ %@",andrewID,dateString,DeviceInfo,OSVersion]];
        
        [tweetSheet addImage:ImageView.image];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    } else {
        
        [self twitterExceptionHandling:@"Please Sign in to Twitter to post the picture"];
    }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle :@"No image"
                              message:@"You need to take an image first inorder to tweet"
                              delegate:self
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil];
        
        [alert performSelectorOnMainThread:@selector
         (show) withObject:nil waitUntilDone:YES];
    }
    
}

-(void)twitterExceptionHandling:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!!!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"User pressed Cancel");
                                   }];
    
    UIAlertAction *settingsAction = [UIAlertAction
                                     actionWithTitle:NSLocalizedString(@"Settings", @"Settings action")
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
                                         NSLog(@"Settings Pressed");
                                         
                                         //code for opening settings app in iOS 8
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                         
                                     }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingsAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [ImageView setImage:image];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    flag = 1;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
