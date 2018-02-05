//
//  SubmitViewController.m
//  modpain
//
//  Created by Simon Loffler on 5/2/18.
//  Copyright © 2018 Milestone Made. All rights reserved.
//

#import "SubmitViewController.h"

@interface SubmitViewController ()

@end

@implementation SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)DismissSubmitPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)NoImageStyleTransfer:(id)sender {
    // COOL COOL, just send the raw image
    [self.submitPageTitle setText:@"Working..."];
    [self.submitPageBodyText setText:@"This should only take a second..."];
    [self.submitPageNoButton removeFromSuperview];
    [self.submitPageYesButton removeFromSuperview];
    
    // Submit raw image
    [self saveImageWithStyle: NO];
}
- (IBAction)YesImageStyleTransfer:(id)sender {
    // Image style transfer this thing.
    [self.submitPageTitle setText:@"Working..."];
    [self.submitPageBodyText setText:@"This might take up to ten seconds... it's hard work!"];
    [self.submitPageNoButton removeFromSuperview];
    [self.submitPageYesButton removeFromSuperview];
    
    // Submit image to image style transfer
    [self saveImageWithStyle: YES];
}

- (void)saveImageWithStyle: (BOOL) styleTransfer {
    // Send this message to ViewController to post the image.
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:styleTransfer] forKey:@"styleTransfer"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"SubmitNotification" object:nil userInfo:userInfo];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
