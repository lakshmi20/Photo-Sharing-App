//
//  TwitterFeed.m
//  lakshmis_iOS_HW6
//
//  Created by Lakshmi Subramanian on 7/9/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import "TwitterFeed.h"
#import "TweetDisplay.h"

@interface TwitterFeed()

@end

@implementation TwitterFeed


-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self getTweets];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tweetTableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *tweet = _dataSource[[indexPath row]];
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setText: tweet[@"text"]];
    
    NSString *string = cell.textLabel.text;
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [linkDetector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if ((matches.count == 1)) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    matches = nil;
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *string = cell.textLabel.text;
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [linkDetector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypeLink) {
            NSURL *url = [match URL];
            self->_imageURL = url;
            
            // Perform Segue to webview with URL data
            [self performSegueWithIdentifier:@"display" sender:self->_imageURL];
            
        } else if(!([matches count] != 1)){
            [self timelineNoImageExeptionThrow];
        }
        matches = nil;
    }
    
}


- (void)getTweets {
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        [account requestAccessToAccountsWithType:accountType
                                         options:nil completion:^(BOOL granted, NSError *error)
         {
             if (granted == YES)
             {
                 NSArray *arrayOfAccounts = [account
                                             accountsWithAccountType:accountType];
                 
                 if ([arrayOfAccounts count] > 0)
                 {
                     ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                     
                     NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                     
                     NSMutableDictionary *parameters =
                     [[NSMutableDictionary alloc] init];
                     [parameters setObject:@"50" forKey:@"count"];
                     [parameters setObject:@"1" forKey:@"include_entities"];
                     
                     SLRequest *postRequest = [SLRequest
                                               requestForServiceType:SLServiceTypeTwitter
                                               requestMethod:SLRequestMethodGET
                                               URL:requestURL parameters:parameters];
                     
                     postRequest.account = twitterAccount;
                     
                     [postRequest performRequestWithHandler:
                      ^(NSData *responseData, NSHTTPURLResponse
                        *urlResponse, NSError *error)
                      {
                          self.dataSource = [NSJSONSerialization
                                             JSONObjectWithData:responseData
                                             options:NSJSONReadingMutableLeaves
                                             error:&error];
                          
                          if (self.dataSource.count != 0) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self.tweetTableView reloadData];
                              });
                          }
                      }];
                 }
             } else {
                 // Handle failure to get account access
                 NSString *message = @"You are not allowed to access twitter account. Please allow access in your Settings ";
                 [self twitterExceptionHandling:message];
                 
             }
         }];
    } else {
        
        // Handle failure to get account access
        NSString *message = @"You have added your twitter account . Please add your twitter account in your settings";
        [self twitterExceptionHandling:message];
        
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

/*
 Throw a message when the user selects a tweet with no media to show
 */

-(void)timelineNoImageExeptionThrow {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Image" message:@"This tweet has no image to display" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"User pressed OK");
                                   }];
    
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 Bundle the media URL data to display in the Webview
 */
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    TwitterDisplay *view = [segue destinationViewController];
    view.imageURL = self->_imageURL;
    
    //NSLog(@"url,%@",self->_imageURL);
}


@end