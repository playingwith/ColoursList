//
//  CLDetailViewController.h
//  ColoursList
//
//  Created by Tatsuya Tobioka on 13/05/14.
//  Copyright (c) 2013年 Tatsuya Tobioka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
