//
//  KonamiCodeViewController.m
//
//  Created by Johnnie Pittman on 1/13/11.
//  Copyright 2011 Johnnie Pittman. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "KonamiCodeViewController.h"

#define SWIPE_UP @"UP"
#define SWIPE_DOWN @"DOWN"
#define SWIPE_LEFT @"LEFT"
#define SWIPE_RIGHT @"RIGHT"
#define BUTTON_A @"BUTTON A"
#define BUTTON_B @"BUTTON B"

@interface KonamiCodeViewController ()

// Private methods
- (void) bButtonAction;
- (void) aButtonAction;
- (void) moveButtons;
- (void) updateLabel:(NSString *)actionText;

@end

@implementation KonamiCodeViewController

@synthesize textLabel;
@synthesize bButton;
@synthesize aButton;
@synthesize konamiCode;

/*
 The designated initializer.  Override if you create the controller programmatically 
 and want to perform customization that is not appropriate for viewDidLoad.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
		// Establish our sequence that we want to watch for on the view
        NSArray *swipeCode = [NSArray arrayWithObjects: SWIPE_UP, SWIPE_UP, 
							  SWIPE_DOWN, SWIPE_DOWN, SWIPE_LEFT, SWIPE_RIGHT, 
							  SWIPE_LEFT, SWIPE_RIGHT, BUTTON_B, BUTTON_A, nil];
		
		// create a new cheat code instance and give it our sequence to monitor
		self.konamiCode = [CheatCode cheatCodeForSequence:swipeCode];
		[self.konamiCode setDelegate:self];
    }
    return self;
}


/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically 
// from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	
	// This is a text label we can use to display each action taken in the sequence.
	// It's established but not visable.  Subclasses should set the alpha to 1.0.
	
	// set the label's location to the bottom of the view.
	float xLocLabel = self.view.bounds.size.width / 2 - 100;
	float yLocLabel = self.view.bounds.size.height - 80;
	self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xLocLabel, yLocLabel, 200, 80)];
	[self.textLabel setTextAlignment:UITextAlignmentCenter];
	[self.textLabel setText:@""];
	// label is going to need to grow.
	[self.textLabel setNumberOfLines:0];
	// making the label not visable. It's up the subclass to make it visable.
	[self.textLabel setAlpha:0.0];
	//[self.textLabel setAutoresizingMask:5];
 	[self.view addSubview:textLabel];
	
	// creating our gesture recognizers
	UISwipeGestureRecognizer *recognizer;
	
	// add our swiping up recognizer.
	recognizer = [[UISwipeGestureRecognizer alloc] 
				  initWithTarget:self action:@selector(handleSwipeFrom:)];
	recognizer.direction = UISwipeGestureRecognizerDirectionUp;
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
	
	// add our swiping down recognizer.
	recognizer = [[UISwipeGestureRecognizer alloc] 
				  initWithTarget:self action:@selector(handleSwipeFrom:)];
	recognizer.direction = UISwipeGestureRecognizerDirectionDown;
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
	
	// add our swiping left recognizer.
	recognizer = [[UISwipeGestureRecognizer alloc] 
				  initWithTarget:self action:@selector(handleSwipeFrom:)];
	recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
	
	// add our swiping right recognizer.
	recognizer = [[UISwipeGestureRecognizer alloc] 
				  initWithTarget:self action:@selector(handleSwipeFrom:)];
	recognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
	
	self.bButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	float xLoc = self.view.bounds.size.width / 2 - 80;
	float yLoc = self.view.bounds.size.height / 2 - 60;
	[self.bButton setFrame:CGRectMake(xLoc, yLoc, 160.0, 50.0)];
	[self.bButton setTitle:@"B" forState:UIControlStateNormal];
	[self.bButton addTarget:self action:@selector(bButtonAction)
		   forControlEvents:UIControlEventTouchUpInside];
	//[self.bButton setAutoresizingMask:5];
	[self.view addSubview:self.bButton];
	[self.bButton setHidden:YES];
	
	
	self.aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	float xLocA = self.view.bounds.size.width / 2 - 80;
	float yLocA = self.view.bounds.size.height / 2;
	[self.aButton setFrame:CGRectMake(xLocA, yLocA, 160.0, 50.0)];
	[self.aButton setTitle:@"A" forState:UIControlStateNormal];
	[self.aButton addTarget:self action:@selector(aButtonAction)
		   forControlEvents:UIControlEventTouchUpInside];
	//[self.aButton setAutoresizingMask:5];
	[self.view addSubview:self.aButton];
	[self.aButton setHidden:YES];
	
}

#pragma mark -
#pragma mark Interface Orientation Handling

 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	 return YES;
 }


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self moveButtons];
}

#pragma mark -
#pragma mark Handling Gestures

/*
 In response to a swipe gesture, show the image view appropriately then move the 
 image view in the direction of the swipe as it fades out.
 */
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
	
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
		[self updateLabel:SWIPE_UP];
		[self.konamiCode addAction:SWIPE_UP];
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
		[self updateLabel:SWIPE_DOWN];
		[self.konamiCode addAction:SWIPE_DOWN];
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
		[self updateLabel:SWIPE_LEFT];
		[self.konamiCode addAction:SWIPE_LEFT];
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
		[self updateLabel:SWIPE_RIGHT];
		[self.konamiCode addAction:SWIPE_RIGHT];
    }
}

#pragma mark -
#pragma mark Button Actions

-(void) bButtonAction
{
	[self updateLabel:BUTTON_B];
	[self.konamiCode addAction:BUTTON_B];
}

-(void) aButtonAction
{
	[self updateLabel:BUTTON_A];
	[self.konamiCode addAction:BUTTON_A];

}


#pragma mark -
#pragma mark Private Methods

- (void) moveButtons
{
	float xLocA = self.view.bounds.size.width / 2 - 80;
	float yLocA = self.view.bounds.size.height / 2;
	[self.aButton setFrame:CGRectMake(xLocA, yLocA, 160.0, 50.0)];
	
	float xLoc = self.view.bounds.size.width / 2 - 80;
	float yLoc = self.view.bounds.size.height / 2 - 60;
	[self.bButton setFrame:CGRectMake(xLoc, yLoc, 160.0, 50.0)];

	float xLocLabel = self.view.bounds.size.width / 2 - 100;
	float yLocLabel = self.view.bounds.size.height - 80;
	[self.textLabel setFrame:CGRectMake(xLocLabel, yLocLabel, 200, 80)];
		
}

- (void) updateLabel:(NSString *)actionText
{
	if ([self.konamiCode.actionsTaken count] == 0) {
		[self.textLabel setText:actionText];
	} else {
		self.textLabel.text = [self.textLabel.text 
							   stringByAppendingFormat:@", %@", actionText];
	}
}

#pragma mark -
#pragma mark CheatCodeDelegates

- (void) didEnterCodeSuccessfully 
{
}

// !!!: Implementation note
// If you implement either of the two methods below in your subclass, please 
// make sure to call: [super <delegate method>]

- (void) didResetProgress:(BOOL)success
{
	[self.bButton setHidden:YES];
	[self.aButton setHidden:YES];
	[self.textLabel setText:@"Reset"];
}

- (void) didUpdateProgress:(float)progress
{
	float limit = 0.7;
	if (progress > limit) {
		if (self.bButton.hidden == YES) {
			[self.bButton setHidden:NO];
			[self.aButton setHidden:NO];
		}
	}
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[textLabel release];
	[bButton release];
	[aButton release];
	[konamiCode release];
	
    [super dealloc];
}


@end
