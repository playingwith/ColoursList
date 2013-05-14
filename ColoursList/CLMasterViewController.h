//
//  CLMasterViewController.h
//  ColoursList
//
//  Created by Tatsuya Tobioka on 13/05/14.
//  Copyright (c) 2013年 Tatsuya Tobioka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLDetailViewController;

@interface CLMasterViewController : UITableViewController

@property (strong, nonatomic) CLDetailViewController *detailViewController;

@end
