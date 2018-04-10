//
//  ViewController.m
//  jotuiexample
//
//  Created by Adam Wulf on 12/8/12.
//  Copyright (c) 2012 Milestone Made. All rights reserved.
//

#import "ViewController.h"
#import <JotUI/JotUI.h>
#import "HelpViewController.h"

@interface ViewController () <JotViewStateProxyDelegate>

@end


@implementation ViewController

float initialSize;
float scaleFactorForMinimumSize;
float initialAlpha;

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    pen = [[Pen alloc] init];
    marker = [[Marker alloc] init];
    eraser = [[Eraser alloc] init];
    marker.color = [redButton backgroundColor];
    pen.color = [blackButton backgroundColor];
    textureActive = true;
    [textureToggleButton setTitle:@"Texture on" forState:UIControlStateNormal];
    
    // Custom MOD. marker default settings
    initialSize = 55.0;
    scaleFactorForMinimumSize = 2.0;
    initialAlpha = 0.25;
    [self resetBrushToDefaults];
    
    // Round colour pickers
    [self roundColourPickers];
    
    // Show/hide settings button
    [settingsButton removeFromSuperview];
    // Remove MOD. colour options
    [self removeColours];
    
    [penVsMarkerControl setSelectedSegmentIndex:1];
    [pressureVsVelocityControl setSelectedSegmentIndex:1];
    
    // Set ourselves up for notifications when the users submission has happened.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveSubmitNotification:)
                                                 name:@"SubmitNotification"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    // Present the help by default at first load
    [self performSegueWithIdentifier:@"helpSegue" sender:nil];
}

- (void) receiveSubmitNotification:(NSNotification *) notification {
    
    NSDictionary *userInfo = notification.userInfo;
    BOOL styleTransfer = [[userInfo objectForKey:@"styleTransfer"] boolValue];
    [self saveImageAndSendWithImageStyleTransfer:styleTransfer];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!jotView) {
        jotView = [[JotView alloc] initWithFrame:self.view.bounds];
        jotView.delegate = self;
        [self.view insertSubview:jotView atIndex:0];

        JotViewStateProxy* paperState = [[JotViewStateProxy alloc] initWithDelegate:self];
        paperState.delegate = self;
        [paperState loadJotStateAsynchronously:NO withSize:jotView.bounds.size andScale:[[UIScreen mainScreen] scale] andContext:jotView.context andBufferManager:[JotBufferManager sharedInstance]];
        [jotView loadState:paperState];

        [self changePenType:nil];

        [self tappedColorButton:modWhiteButton];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Helpers

- (Pen*)activePen {
    if (penVsMarkerControl.selectedSegmentIndex == 0) {
        return pen;
    } else if (penVsMarkerControl.selectedSegmentIndex == 1) {
        return marker;
    } else {
        return eraser;
    }
}

- (void)updatePenTickers {
    minAlpha.text = [NSString stringWithFormat:@"%.2f", [self activePen].minAlpha];
    maxAlpha.text = [NSString stringWithFormat:@"%.2f", [self activePen].maxAlpha];
    minWidth.text = [NSString stringWithFormat:@"%d", (int)[self activePen].minSize];
    maxWidth.text = [NSString stringWithFormat:@"%d", (int)[self activePen].maxSize];
}

- (void)removeColours {
    for (UIButton *button in [NSArray arrayWithObjects: modRedButton, modBlueButton, modGreenButton, modOrangeButton, modPurpleButton, modYellowButton, nil]) {
        [button removeFromSuperview];
    }
}

#pragma mark - IBAction


- (IBAction)changePenType:(id)sender {
    if ([[self activePen].color isEqual:blackButton.backgroundColor])
        [self tappedColorButton:blackButton];
    if ([[self activePen].color isEqual:redButton.backgroundColor])
        [self tappedColorButton:redButton];
    if ([[self activePen].color isEqual:greenButton.backgroundColor])
        [self tappedColorButton:greenButton];
    if ([[self activePen].color isEqual:blueButton.backgroundColor])
        [self tappedColorButton:blueButton];
    if ([[self activePen].color isEqual:modRedButton.backgroundColor])
        [self tappedColorButton:modRedButton];
    if ([[self activePen].color isEqual:modBlueButton.backgroundColor])
        [self tappedColorButton:modBlueButton];
    if ([[self activePen].color isEqual:modGreenButton.backgroundColor])
        [self tappedColorButton:modGreenButton];
    if ([[self activePen].color isEqual:modWhiteButton.backgroundColor])
        [self tappedColorButton:modWhiteButton];
    if ([[self activePen].color isEqual:modOrangeButton.backgroundColor])
        [self tappedColorButton:modOrangeButton];
    if ([[self activePen].color isEqual:modPurpleButton.backgroundColor])
        [self tappedColorButton:modPurpleButton];
    if ([[self activePen].color isEqual:modYellowButton.backgroundColor])
        [self tappedColorButton:modYellowButton];
    if ([[self activePen].color isEqual:modBlackButton.backgroundColor])
        [self tappedColorButton:modBlackButton];

    [self updatePenTickers];
}

- (IBAction)toggleOptionsPane:(id)sender {
    additionalOptionsView.hidden = !additionalOptionsView.hidden;
}

- (IBAction)tappedColorButton:(UIButton*)sender {
    for (UIButton *button in [NSArray arrayWithObjects:blueButton, redButton, greenButton, blackButton, modRedButton, modBlueButton, modGreenButton, modWhiteButton, modOrangeButton, modPurpleButton, modYellowButton, modBlackButton, nil]) {
        if (sender == button) {
            [button setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
            button.selected = YES;
        } else {
            [button setBackgroundImage:nil forState:UIControlStateNormal];
            button.selected = NO;
        }
    }

    [self activePen].color = [sender backgroundColor];
}

- (IBAction)changeWidthOrSize:(UISegmentedControl*)sender {
    if (sender == minAlphaDelta) {
        if (sender.selectedSegmentIndex == 0) {
            [self activePen].minAlpha -= .1;
        } else if (sender.selectedSegmentIndex == 1) {
            [self activePen].minAlpha -= .01;
        } else if (sender.selectedSegmentIndex == 2) {
            [self activePen].minAlpha += .01;
        } else if (sender.selectedSegmentIndex == 3) {
            [self activePen].minAlpha += .1;
        }
    }
    if (sender == maxAlphaDelta) {
        if (sender.selectedSegmentIndex == 0) {
            [self activePen].maxAlpha -= .1;
        } else if (sender.selectedSegmentIndex == 1) {
            [self activePen].maxAlpha -= .01;
        } else if (sender.selectedSegmentIndex == 2) {
            [self activePen].maxAlpha += .01;
        } else if (sender.selectedSegmentIndex == 3) {
            [self activePen].maxAlpha += .1;
        }
    }
    if (sender == minWidthDelta) {
        if (sender.selectedSegmentIndex == 0) {
            [self activePen].minSize -= 5;
        } else if (sender.selectedSegmentIndex == 1) {
            [self activePen].minSize -= 1;
        } else if (sender.selectedSegmentIndex == 2) {
            [self activePen].minSize += 1;
        } else if (sender.selectedSegmentIndex == 3) {
            [self activePen].minSize += 5;
        }
    }
    if (sender == maxWidthDelta) {
        if (sender.selectedSegmentIndex == 0) {
            [self activePen].maxSize -= 5;
        } else if (sender.selectedSegmentIndex == 1) {
            [self activePen].maxSize -= 1;
        } else if (sender.selectedSegmentIndex == 2) {
            [self activePen].maxSize += 1;
        } else if (sender.selectedSegmentIndex == 3) {
            [self activePen].maxSize += 5;
        }
    }


    if ([self activePen].minAlpha < 0)
        [self activePen].minAlpha = 0;
    if ([self activePen].minAlpha > 1)
        [self activePen].minAlpha = 1;

    if ([self activePen].maxAlpha < 0)
        [self activePen].maxAlpha = 0;
    if ([self activePen].maxAlpha > 1)
        [self activePen].maxAlpha = 1;

    if ([self activePen].minSize < 0)
        [self activePen].minSize = 0;
    if ([self activePen].maxSize < 0)
        [self activePen].maxSize = 0;

    [self updatePenTickers];
}


- (IBAction)saveImage {
    [jotView exportImageTo:[self jotViewStateInkPath] andThumbnailTo:[self jotViewStateThumbPath] andStateTo:[self jotViewStatePlistPath] withThumbnailScale:1.0 onComplete:^(UIImage* ink, UIImage* thumb, JotViewImmutableState* state) {
        UIImageWriteToSavedPhotosAlbum(thumb, nil, nil, nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Saved" message:@"The JotView's state has been saved to disk, and a full resolution image has been saved to the photo album." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
}
- (IBAction)toggleTexture:(id)sender {
    if (textureActive) {
        textureActive = false;
        [textureToggleButton setTitle:@"Texture off" forState:UIControlStateNormal];
    } else {
        textureActive = true;
        [textureToggleButton setTitle:@"Texture on" forState:UIControlStateNormal];
    }
}

- (IBAction)undoLastEvent:(id)sender {
    [jotView undo];
}

- (IBAction)redoLastEvent:(id)sender {
    [jotView redo];
}

- (IBAction)sendToServer:(id)sender {
    // Send to server button pressed
    
}
- (IBAction)sliderDidChange:(id)sender {
    // Set brush to slider size
    UISlider *slider = sender;
    float sliderValue = [slider value];
    if ([slider.restorationIdentifier isEqualToString:@"brushSizeSlider"]) {
        pen.maxSize = sliderValue;
        pen.minSize = sliderValue/scaleFactorForMinimumSize;
        marker.maxSize = sliderValue;
        marker.minSize = sliderValue/scaleFactorForMinimumSize;
    } else if ([slider.restorationIdentifier isEqualToString:@"brushOpacitySlider"]) {
        pen.minAlpha = sliderValue;
        pen.maxAlpha = sliderValue;
        marker.minAlpha = sliderValue;
        marker.maxAlpha = sliderValue;
    }
}

- (void)saveImageAndSendWithImageStyleTransfer:(BOOL)withStyle {
    // Send image to the server
    [jotView exportImageTo:[self jotViewStateInkPath] andThumbnailTo:[self jotViewStateThumbPath] andStateTo:[self jotViewStatePlistPath] withThumbnailScale:1.0 onComplete:^(UIImage* ink, UIImage* thumb, JotViewImmutableState* state) {
        UIImageWriteToSavedPhotosAlbum(thumb, nil, nil, nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            // Image saved
            NSLog(@"Image saved. Sending to server...");
            [self sendImageToServer: thumb withStyle: withStyle];
        });
    }];
}

- (void)sendImageToServer: (UIImage *) image withStyle: (BOOL) styleTransfer {
    // Send UIImage to slideshow server
//    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.220.171.72:3000/images"]];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:3000/images"]];
    
    // UIImage to data for our server
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *imageDataBase64 = [[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *postBodyData = [NSString stringWithFormat:@"image[ios_data]=%@&image[style_transfer]=%s",imageDataBase64, styleTransfer ? "true" : "false"];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    //Convert the String to Data
    NSData *data1 = [postBodyData dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
//            NSError *parseError = nil;
//            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//            NSLog(@"The response is - %@",responseDictionary);
//            NSInteger success = [[responseDictionary objectForKey:@"success"] integerValue];
//            if(success == 1)
//            {
//                NSLog(@"Login SUCCESS");
//            }
//            else
//            {
//                NSLog(@"Login FAILURE");
//            }
            // Let the user know how it's all going.
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Look up!"
//                                                                           message:@"Your image is ready."
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
//            [self presentViewController:alert animated:YES completion:nil];
            
            // Send a proper Notification to the view saying it's all done.
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:1] forKey:@"complete"];
            [[NSNotificationCenter defaultCenter] postNotificationName:
             @"ProcessingCompleteNotification" object:nil userInfo:userInfo];
        }
        else
        {
            NSLog(@"Error");
            // Send an error notification
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:0] forKey:@"complete"];
            [[NSNotificationCenter defaultCenter] postNotificationName:
             @"ProcessingCompleteNotification" object:nil userInfo:userInfo];
        }
    }];
    [dataTask resume];
}

- (IBAction)loadImageFromLibary:(UIButton*)sender {
    [[jotView state] setIsForgetful:YES];
    JotViewStateProxy* state = [[JotViewStateProxy alloc] initWithDelegate:self];
    [state loadJotStateAsynchronously:NO withSize:jotView.bounds.size andScale:[[UIScreen mainScreen] scale] andContext:jotView.context andBufferManager:[JotBufferManager sharedInstance]];
    [jotView loadState:state];

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Loaded" message:@"The JotView's state been loaded from disk." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Jot Stylus Button Callbacks

- (void)nextColor {
    // double the blue button, so that if the black is selected,
    // we'll cycle back to the beginning
    NSArray* buttons = [NSArray arrayWithObjects:blackButton, redButton, greenButton, blueButton, blackButton, nil];
    for (UIButton* button in buttons) {
        if (button.selected) {
            [self tappedColorButton:[buttons objectAtIndex:[buttons indexOfObject:button inRange:NSMakeRange(0, [buttons count] - 1)] + 1]];
            break;
        }
    }
}
- (void)previousColor {
    NSArray* buttons = [NSArray arrayWithObjects:blueButton, greenButton, redButton, blackButton, blueButton, nil];
    for (UIButton* button in buttons) {
        if (button.selected) {
            [self tappedColorButton:[buttons objectAtIndex:[buttons indexOfObject:button inRange:NSMakeRange(0, [buttons count] - 1)] + 1]];
            break;
        }
    }
}

- (void)increaseStrokeWidth {
    [self activePen].minSize += 1;
    [self activePen].maxSize += 1.5;
    [self updatePenTickers];
}
- (void)decreaseStrokeWidth {
    [self activePen].minSize -= 1;
    [self activePen].maxSize -= 1.5;
    [self updatePenTickers];
}

- (void)undo {
    [jotView undo];
}

- (void)redo {
    [jotView redo];
}

- (IBAction)clearScreen:(id)sender {
    [jotView clear:YES];
    // reset slider and brush sizes to defaults
    [self resetBrushToDefaults];
}

- (void)resetBrushToDefaults {
    pen.color = [blackButton backgroundColor];
    marker.color = [blackButton backgroundColor];
    pen.minSize = initialSize/scaleFactorForMinimumSize;
    pen.maxSize = initialSize;
    marker.minSize = initialSize/scaleFactorForMinimumSize;
    marker.maxSize = initialSize;
    pen.minAlpha = initialAlpha;
    pen.maxAlpha = initialAlpha;
    marker.minAlpha = initialAlpha;
    marker.maxAlpha = initialAlpha;
    [brushSizeSlider setValue: initialSize];
    [brushOpacitySlider setValue:initialAlpha];
    [self tappedColorButton:modWhiteButton];
    [self whiteBorderForBlackColorButton];
}

- (void)whiteBorderForBlackColorButton {
    modBlackButton.layer.borderWidth = 1.0f;
    modBlackButton.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)roundedCornersWithRadius:(float)radius forButton:(UIButton *)button {
    // Rounded corners for any imageView
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = radius;
}

- (void)roundColourPickers {
    for (UIButton *button in [NSArray arrayWithObjects:modRedButton, modBlueButton, modGreenButton, modWhiteButton, modOrangeButton, modPurpleButton, modYellowButton, modBlackButton, nil])
    {
        [self roundedCornersWithRadius:(button.bounds.size.width / 2.) forButton:button];
    }
}

#pragma mark - JotViewDelegate

- (JotBrushTexture*)textureForStroke {
    if (textureActive) {
        return [JotHighlighterBrushTexture sharedInstance];
    } else {
        return [[self activePen] textureForStroke];
    }
}

- (CGFloat)stepWidthForStroke {
    return [[self activePen] stepWidthForStroke];
}

- (BOOL)supportsRotation {
    return [[self activePen] supportsRotation];
}

- (NSArray*)willAddElements:(NSArray*)elements toStroke:(JotStroke*)stroke fromPreviousElement:(AbstractBezierPathElement*)previousElement {
    return [[self activePen] willAddElements:elements toStroke:stroke fromPreviousElement:previousElement];
}

- (BOOL)willBeginStrokeWithCoalescedTouch:(UITouch*)coalescedTouch fromTouch:(UITouch*)touch {
    [[self activePen] willBeginStrokeWithCoalescedTouch:coalescedTouch fromTouch:touch];
    return YES;
}

- (void)willMoveStrokeWithCoalescedTouch:(UITouch*)coalescedTouch fromTouch:(UITouch*)touch {
    [[self activePen] willMoveStrokeWithCoalescedTouch:coalescedTouch fromTouch:touch];
}

- (void)willEndStrokeWithCoalescedTouch:(UITouch*)coalescedTouch fromTouch:(UITouch*)touch shortStrokeEnding:(BOOL)shortStrokeEnding {
    // noop
}

- (void)didEndStrokeWithCoalescedTouch:(UITouch*)coalescedTouch fromTouch:(UITouch*)touch {
    [[self activePen] didEndStrokeWithCoalescedTouch:coalescedTouch fromTouch:touch];
}

- (void)willCancelStroke:(JotStroke*)stroke withCoalescedTouch:(UITouch*)coalescedTouch fromTouch:(UITouch*)touch {
    [[self activePen] willCancelStroke:stroke withCoalescedTouch:coalescedTouch fromTouch:touch];
}

- (void)didCancelStroke:(JotStroke*)stroke withCoalescedTouch:(UITouch*)coalescedTouch fromTouch:(UITouch*)touch {
    [[self activePen] didCancelStroke:stroke withCoalescedTouch:coalescedTouch fromTouch:touch];
}

- (UIColor*)colorForCoalescedTouch:(UITouch*)coalescedTouch fromTouch:(UITouch*)touch {
    [[self activePen] setShouldUseVelocity:!pressureVsVelocityControl || pressureVsVelocityControl.selectedSegmentIndex];
    return [[self activePen] colorForCoalescedTouch:coalescedTouch fromTouch:touch];
}

- (CGFloat)widthForCoalescedTouch:(UITouch*)coalescedTouch fromTouch:(UITouch*)touch {
    [[self activePen] setShouldUseVelocity:!pressureVsVelocityControl || pressureVsVelocityControl.selectedSegmentIndex];
    return [[self activePen] widthForCoalescedTouch:coalescedTouch fromTouch:touch];
}

- (CGFloat)smoothnessForCoalescedTouch:(UITouch*)coalescedTouch fromTouch:(UITouch*)touch {
    return [[self activePen] smoothnessForCoalescedTouch:coalescedTouch fromTouch:touch];
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIViewController*)_popoverController {
    popoverController = nil;
}

#pragma mark - JotViewStateProxyDelegate

- (NSString*)documentsDir {
    NSArray<NSString*>* userDocumentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [userDocumentsPaths objectAtIndex:0];
}

- (NSString*)jotViewStateInkPath {
    return [[self documentsDir] stringByAppendingPathComponent:@"ink.png"];
}

- (NSString*)jotViewStateThumbPath {
    return [[self documentsDir] stringByAppendingPathComponent:@"thumb.png"];
}

- (NSString*)jotViewStatePlistPath {
    return [[self documentsDir] stringByAppendingPathComponent:@"state.plist"];
}

- (void)didLoadState:(JotViewStateProxy*)state {
}

- (void)didUnloadState:(JotViewStateProxy*)state {
}


@end
