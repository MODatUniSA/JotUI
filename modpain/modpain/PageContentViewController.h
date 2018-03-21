//
//  PageContentViewController.h
//  modpain
//
//  Created by Simon Loffler on 20/3/18.
//  Copyright © 2018 Milestone Made. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *pageEmoji;

@property NSUInteger pageIndex;
@property NSString *imageFile;
@property NSString *pageEmojiString;

@end
