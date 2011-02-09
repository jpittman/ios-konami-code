//
//  CheatCode.h
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


#import <Foundation/Foundation.h>

@protocol CheatCodeDelegate <NSObject>

@required

// When a user has successfully entered the code, this gets fired.
- (void) didEnterCodeSuccessfully;

@optional

// As a user enters the code, if the gesture is successful this gets fired.
- (void) didUpdateProgress:(float)progress;

// When the gestures array gets reset, this is fired.
- (void) didResetProgress:(BOOL)success;

@end

@interface CheatCode : NSObject {
	
	id <CheatCodeDelegate> delegate;
	
	NSArray *_codeSequence;
	NSMutableArray *actionsTaken;
}

@property(nonatomic, retain) id <CheatCodeDelegate> delegate;
@property(nonatomic, retain) NSArray *codeSequence;
@property(nonatomic, retain) NSMutableArray *actionsTaken;

+ (CheatCode *) cheatCodeForSequence:(NSArray *)sequence;
- (id) initWithCodeSequence:(NSArray *)sequence;
- (void) addAction:(NSString *)action;

@end
