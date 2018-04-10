//
//  ViewController.h
//  jotuiexample
//
//  Created by Adam Wulf on 12/8/12.
//  Copyright (c) 2012 Milestone Made. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JotUI/JotUI.h>
#import "Pen.h"
#import "Marker.h"
#import "Eraser.h"

// Timeout before the app pops the home/help view
#define kApplicationTimeoutInMinutes 2

// The notification our AppDelegate needs to watch for in order to know that it has "timed out"
#define kApplicationDidTimeoutNotification @"AppTimeOut"

@interface ViewController : UIViewController <JotViewDelegate, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    IBOutlet JotView* jotView;
    Pen* pen;
    Marker* marker;
    Eraser* eraser;
    BOOL textureActive;

    UIViewController* popoverController;

    IBOutlet UISegmentedControl* pressureVsVelocityControl;
    IBOutlet UISegmentedControl* penVsMarkerControl;


    IBOutlet UILabel* minAlpha;
    IBOutlet UILabel* maxAlpha;
    IBOutlet UILabel* minWidth;
    IBOutlet UILabel* maxWidth;

    IBOutlet UISegmentedControl* minAlphaDelta;
    IBOutlet UISegmentedControl* maxAlphaDelta;
    IBOutlet UISegmentedControl* minWidthDelta;
    IBOutlet UISegmentedControl* maxWidthDelta;


    IBOutlet UIButton* blueButton;
    IBOutlet UIButton* redButton;
    IBOutlet UIButton* greenButton;
    IBOutlet UIButton* blackButton;
    
    IBOutlet UIButton* modPurpleButton;
    IBOutlet UIButton* modGreenButton;
    IBOutlet UIButton* modBlueButton;
    IBOutlet UIButton* modYellowButton;
    IBOutlet UIButton* modOrangeButton;
    IBOutlet UIButton* modRedButton;
    IBOutlet UIButton* modWhiteButton;
    IBOutlet UIButton* modBlackButton;

    IBOutlet UIView* additionalOptionsView;
    IBOutlet UIButton* palmRejectionButton;

    IBOutlet UIButton* settingsButton;
    
    IBOutlet UIButton* pushToServerButton;
    IBOutlet UIButton* textureToggleButton;
    
    IBOutlet UISlider* brushSizeSlider;
    IBOutlet UISlider* brushOpacitySlider;
    
    NSTimer* idleTimer;
}

- (void)saveImageAndSendWithImageStyleTransfer: (BOOL) withStyle;
- (void)resetIdleTimer;

@end
