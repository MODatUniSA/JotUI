//
//  SubmitViewController.h
//  modpain
//
//  Created by Simon Loffler on 5/2/18.
//  Copyright © 2018 Milestone Made. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *submitPageTitle;
@property (weak, nonatomic) IBOutlet UILabel *submitPageBodyText;
@property (weak, nonatomic) IBOutlet UIButton *submitPageNoButton;
@property (weak, nonatomic) IBOutlet UIButton *submitPageYesButton;

@end
