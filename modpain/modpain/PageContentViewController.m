//
//  PageContentViewController.m
//  modpain
//
//  Created by Simon Loffler on 20/3/18.
//  Copyright © 2018 Milestone Made. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    [self.pageEmoji setText:self.pageEmojiString];
    
    // Set a 2 minute time-out
    [self performSelector:@selector(dismissHelpPage:) withObject:nil afterDelay:120.0];
}

- (void)dismissHelpPage:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetTimerNotification" object:nil];
    [self closePageController:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closePageController:(id)sender {
    // Go back to the help view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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
