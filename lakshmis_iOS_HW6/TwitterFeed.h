//
//  TwitterFeed.h
//  lakshmis_iOS_HW6
//
//  Created by Lakshmi Subramanian on 7/9/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface TwitterFeed : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tweetTableView;
@property (strong, nonatomic) NSArray *dataSource;

@property (weak,nonatomic) NSURL *imageURL;

@end

