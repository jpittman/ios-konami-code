//
//  CheatCode.m
//
//  Created by Johnnie Pittman on 1/15/11.
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

#import "CheatCode.h"

@interface CheatCode ()

- (void) resetProgress;
- (BOOL) checkProgress;

@end


@implementation CheatCode

@synthesize codeSequence = _codeSequence;
@synthesize delegate;
@synthesize actionsTaken;

#pragma mark -

+ (CheatCode *) cheatCodeForSequence:(NSArray *)sequence
{
	return [[[CheatCode alloc] initWithCodeSequence:sequence] autorelease];
}

- (id) initWithCodeSequence:(NSArray *)sequence
{
    self = [super init];
    if (self) {
		self.codeSequence = sequence;
		self.actionsTaken = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void) dealloc
{
	self.codeSequence = nil;
	self.delegate = nil;
	self.actionsTaken = nil;
	
	[super dealloc];
}

#pragma mark -

- (void) setCodeSequence:(NSArray *)sequence
{
	if (sequence != _codeSequence) {
		[_codeSequence release];
		_codeSequence = [sequence retain];
	}
}

- (NSArray *) codeSequence
{
	return _codeSequence;
}

#pragma mark -

- (void) addAction:(NSString *)action
{
	[self.actionsTaken addObject:action];
	[self checkProgress];
}

#pragma mark -
#pragma mark Private Methods

- (void) resetProgress 
{
	self.actionsTaken = nil;
	self.actionsTaken = [NSMutableArray arrayWithCapacity:1];
}


/*
 checkProgress validates the current array of actions against the initialized
 sequence.
 */
- (BOOL) checkProgress
{
	// get the count of these arrays, because we will use them often.
	float actionCount = [self.actionsTaken count];
	float sequenceCount = [self.codeSequence count];
	
	// create a subset array of the code sequence for testing, 
	NSRange testRange = NSMakeRange(0, actionCount);
	NSArray *testArray = [self.codeSequence subarrayWithRange:testRange];
	
	// Validate the actions taken against the testing array
	if ([self.actionsTaken isEqualToArray:testArray]) {
		if (actionCount == sequenceCount) {
			// we've got the correct sequence and the correct count.  Fire off 
			// delegate methods.
			if ([self.delegate respondsToSelector:@selector(didEnterCodeSuccessfully)]) {
				[self.delegate didEnterCodeSuccessfully];
			}
			if ([self.delegate respondsToSelector:@selector(didResetProgress:)]) {
				[self.delegate didResetProgress:YES];
			}
			// reset the current array of actions.
			[self resetProgress];
			return YES;
		}
		if ([self.delegate respondsToSelector:@selector(didUpdateProgress:)]) {
			// User is doing good so far.  Fire off the delegate method so that
			// app can handle progress.
			float progress =  actionCount / sequenceCount;
			[self.delegate didUpdateProgress:progress];
		}		
		return YES;
	} else {
		//NSLog(@"Reseting the gestures array.  Not the correct sequence: %@", 
		//	  self.actionsTaken);
		[self resetProgress];
		if ([self.delegate respondsToSelector:@selector(didResetProgress:)]) {
			[self.delegate didResetProgress:NO];
		}				
		return NO;
	}
}


@end
