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

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    pen = [[Pen alloc] init];
    marker = [[Marker alloc] init];
    eraser = [[Eraser alloc] init];
    marker.color = [redButton backgroundColor];
    pen.color = [blackButton backgroundColor];
    textureActive = false;
    
    // Custom MOD. marker default settings
    pen.minSize = 26.0;
    pen.maxSize = 50.0;
    marker.minSize = 26.0;
    marker.maxSize = 50.0;
    
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

        [self tappedColorButton:blackButton];
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

    [self updatePenTickers];
}

- (IBAction)toggleOptionsPane:(id)sender {
    additionalOptionsView.hidden = !additionalOptionsView.hidden;
}

- (IBAction)tappedColorButton:(UIButton*)sender {
    for (UIButton *button in [NSArray arrayWithObjects:blueButton, redButton, greenButton, blackButton, nil]) {
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

- (void)saveImageAndSendWithImageStyleTransfer:(BOOL)withStyle {
    // TODO: Do this in the SubmitViewController
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
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.220.171.72:3000/images"]];
    
    // UIImage to data for our server
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *imageDataBase64 = [[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    // TODO: Get server to allow no-style-transfer and send it here.
    
    NSString *postBodyData = [NSString stringWithFormat:@"image[ios_data]=%@",imageDataBase64];
    
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
            // TODO: Send a proper Notification to the view saying it's all done.
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Look up!"
                                                                           message:@"Your image is ready."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            NSLog(@"Error");
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
