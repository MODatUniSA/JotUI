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
//    [self.permissionPageDescriptionText setText:@"You're welcome to delete your image using the trash can on the top right."];
    [self.permissionPageDescriptionText setText:@""];
    [self performSelector:@selector(showHowDoesThisHelpMe:) withObject:nil afterDelay:5.0];
}
- (IBAction)DismissPermissionPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidTimeoutNotification object:nil];
}
- (IBAction)PermissionGiven:(id)sender {
    // Do we need to do anything here?
}

- (void)showHowDoesThisHelpMe:(NSNotification *)notification {
    // TODO: Refactor - also in permission view controller
    // Show research text
    if (self.permissionPageTitle) {
        [self.permissionPageTitle setText:@"How does this help me?"];
        [self.permissionPageBodyText setText:@"Research suggests that drawings of pain can help to bring some elements of pain experience out of unconscious and into more conscious dialogue and control. By discovering and dissecting the meanings of these elements, their significance to, and impact on, pain experience can emerge."];
    }
    
    // Pause, then dismiss & reset.
    [self performSelector:@selector(DismissPermissionPage:) withObject:nil afterDelay:30.0];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
