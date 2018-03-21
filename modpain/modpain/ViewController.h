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

    IBOutlet UIView* additionalOptionsView;
    IBOutlet UIButton* palmRejectionButton;

    IBOutlet UIButton* settingsButton;
    
    IBOutlet UIButton* pushToServerButton;
    IBOutlet UIButton* textureToggleButton;
    
    IBOutlet UISlider* brushSizeSlider;
}

- (void)saveImageAndSendWithImageStyleTransfer: (BOOL) withStyle;

@end
