//
//  HelpViewController.m
//  modpain
//
//  Created by Simon Loffler on 5/2/18.
//  Copyright © 2018 Milestone Made. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissModalStack {
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)DismissHelpSheet:(UIStoryboardSegue *)unwindSegue {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissModalStack];
}
- (IBAction)TellMeMore:(id)sender {
    // TODO: Page controller here with more...
    NSLog(@"TODO: build the page controller...");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"TODO: 🤓"
                                                                   message:@"I'll build the full instructional pages once we've given this the green light."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"COOL" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
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
