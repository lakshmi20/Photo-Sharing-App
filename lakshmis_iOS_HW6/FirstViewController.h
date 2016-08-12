//
//  FirstViewController.h
//  lakshmis_iOS_HW6
//
//  Created by Lakshmi Subramanian on 6/29/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *assetGroupArray;
@property (nonatomic, strong) IBOutlet UITableView *assetGroupTableView;
@property (nonatomic, strong) NSURL *selectedGroupURL;

- (void)setupAssetData;



@end

