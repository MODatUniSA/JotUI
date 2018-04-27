//
//  HelpViewController.h
//  modpain
//
//  Created by Simon Loffler on 5/2/18.
//  Copyright © 2018 Milestone Made. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface HelpViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) NSArray *pageEmoji;
@property (weak, nonatomic) IBOutlet UILabel *helpPageEmoji;
@property (weak, nonatomic) IBOutlet UILabel *helpPageTitle;
@property (weak, nonatomic) IBOutlet UILabel *helpPageBody;
@property (weak, nonatomic) IBOutlet UIButton *helpPageTellMeMore;
@property (weak, nonatomic) IBOutlet UIButton *helpPageLetMeDraw;

@end
