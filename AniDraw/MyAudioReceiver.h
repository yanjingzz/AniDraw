//
//  MyAudioReceiver.h
//  audioTest
//
//  Created by Mike on 7/13/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

#import <Foundation/Foundation.h>
@import TheAmazingAudioEngine;

#ifndef MyAudioReceiver_h
#define MyAudioReceiver_h

@interface ReceiverData : NSObject;

@property float pitch;
@property float bpm;
@property float onset;
@property bool isSinging;
@property float decibel;
@property double time;
@property NSArray *mfcc;

@end

@class MyAudioReceiver;
@protocol MyAudioReceiverDelegate <NSObject>
- (void)receiverDidReceiveData: (ReceiverData *) data;
@end


@interface MyAudioReceiver : NSObject <AEAudioReceiver>
+ (id <MyAudioReceiverDelegate>)  delegate;
+ (void) setDelegate: (id <MyAudioReceiverDelegate>) newDelegate;
+ (int) mfcc_n_coeff;
@end


#endif /* MyAudioReceiver_h */
