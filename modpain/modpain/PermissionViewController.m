//
//  PermissionViewController.m
//  modpain
//
//  Created by Simon Loffler on 5/2/18.
//  Copyright © 2018 Milestone Made. All rights reserved.
//

#import "PermissionViewController.h"

@interface PermissionViewController ()

@end

@implementation PermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Remove Emoji?
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"removeEmoji"]) {
        // leave them there.
    } else {
        [self.permissionPageEmoji setText:@""];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)PermissionNotGiven:(id)sender {
    // Remove Emoji?
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"removeEmoji"]) {
        [self.permissionPageEmoji setText:@"😎"];
    }
    [self.permissionPageTitle setText:@"Thank you!"];
    [self.permissionPageBodyText setText:@"Thanks for drawing. We haven't saved your image so won't use it anywhere in the gallery."];
    [self.permissionPageNoButton removeFromSuperview];
    [self.permissionPageYesButton removeFromSuperview];
    [self.permissionPageDescriptionText setText:@"You're welcome to delete your image using the trash can on the top right."];
}
- (IBAction)DismissPermissionPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)PermissionGiven:(id)sender {
    // Do we need to do anything here?
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
