//
//  GroupViewController.h
//  lakshmis_iOS_HW6
//
//  Created by Lakshmi Subramanian on 7/5/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface GroupViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *assetArray;
@property (nonatomic, strong) NSURL *assetGroupURL;
@property (nonatomic, strong) NSString *assetGroupName;
@property (nonatomic, strong) IBOutlet UITableView *assetTableView;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;



@end
