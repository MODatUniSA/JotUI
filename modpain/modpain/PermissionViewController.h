//
//  PermissionViewController.h
//  modpain
//
//  Created by Simon Loffler on 5/2/18.
//  Copyright © 2018 Milestone Made. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PermissionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *permissionPageEmoji;
@property (weak, nonatomic) IBOutlet UILabel *permissionPageTitle;
@property (weak, nonatomic) IBOutlet UILabel *permissionPageBodyText;
@property (weak, nonatomic) IBOutlet UIButton *permissionPageNoButton;
@property (weak, nonatomic) IBOutlet UIButton *permissionPageYesButton;
@property (weak, nonatomic) IBOutlet UILabel *permissionPageDescriptionText;

@end
