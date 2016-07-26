//
//  MyAudioReceiver.m
//  audioTest
//
//  Created by Mike on 7/13/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyAudioReceiver.h"
@import aubio;
@implementation ReceiverData

@end

@implementation MyAudioReceiver

const uint_t _mfcc_n_coeff = 13;
aubio_pitch_t *pitch_o;
aubio_tempo_t *tempo_o;
aubio_onset_t *onset_o;
aubio_mfcc_t *mfcc_o;
aubio_fft_t *fft_o;
bool isSinging = false;
float lastPitch = 0;
int currentCounter = 0;
const float silentThreshold = -50;
float current_time;
const float halfToneFactor = 1.059463094359295;
const int sampleRate = 44100;
dispatch_queue_t audioQueue;
__weak id <MyAudioReceiverDelegate> delegate;

-(void)setupWithAudioController:(AEAudioController *)audioController {
    @autoreleasepool {
        audioQueue = dispatch_queue_create("audioQueue", DISPATCH_QUEUE_SERIAL);
    }
}

-(void)teardown {
    if(pitch_o != NULL) {
        del_aubio_pitch(pitch_o);
    }
    if (tempo_o != NULL) {
        del_aubio_tempo(tempo_o);
    }
    if (onset_o != NULL) {
        del_aubio_onset(onset_o);
    }
    if (mfcc_o != NULL) {
        del_aubio_mfcc(mfcc_o);
    }
    if (fft_o != NULL) {
        del_aubio_fft(fft_o);
    }
    aubio_cleanup();
}
+(int)mfcc_n_coeff {
    return (int)_mfcc_n_coeff;
}
+(id<MyAudioReceiverDelegate>)delegate {
    return delegate;
}
+(void)setDelegate:(id<MyAudioReceiverDelegate>)newDelegate {
    delegate = newDelegate;
}

static void receiverCallback(__unsafe_unretained MyAudioReceiver *THIS,
                             __unsafe_unretained AEAudioController *audioController,
                             void *source,
                             const AudioTimeStamp *time,
                             UInt32 frames,
                             AudioBufferList *audio) {
    AudioBuffer buffer = audio->mBuffers[0];
    
//    NSLog(@"%d", (unsigned int)time->mFlags);
//    NSLog(@"%f %d %d %d", time->mSampleTime, (unsigned int)frames, (unsigned int)buffer.mDataByteSize, (unsigned int)buffer.mNumberChannels);
    
    
    double this_time = time->mSampleTime / sampleRate;
    current_time = this_time;
    dispatch_async(audioQueue, ^{
        if (pitch_o == NULL) {
            pitch_o = new_aubio_pitch("default", frames, frames, sampleRate);
            aubio_pitch_set_silence(pitch_o, silentThreshold);
        }
        
        if (tempo_o == NULL) {
            tempo_o = new_aubio_tempo("default", frames, frames, sampleRate);
            aubio_tempo_set_silence(tempo_o, silentThreshold);
        }
        
        if (onset_o == NULL) {
            onset_o = new_aubio_onset("complex", frames, frames, sampleRate);
            aubio_onset_set_silence(onset_o, silentThreshold);
        }
        if (fft_o == NULL) {
            fft_o = new_aubio_fft(frames);
        }
        if (mfcc_o == NULL) {
            mfcc_o = new_aubio_mfcc(frames, 40, _mfcc_n_coeff, sampleRate);
        }
        float *data = (float *)buffer.mData;
        fvec_t input;
        
        input.length = frames;
        input.data = data;
        
        fvec_t *output = new_fvec(1);
        
        // pitch
        aubio_pitch_do(pitch_o, &input, output);
        float pitch_data = output->data[0];
        if (pitch_data > 1000 || pitch_data < 65) {
            pitch_data = 0;
        }
        
        //onset
        aubio_onset_do(onset_o, &input, output);
        
        float decibel = aubio_db_spl(&input);
        float onset_data = output->data[0];
        
        
        if (onset_data != 0 && pitch_data != 0) {
            isSinging = true;
            currentCounter = 1;
            lastPitch = pitch_data;
        }
        
        if (pitch_data == 0 || (pitch_data / lastPitch) > halfToneFactor ||
            (lastPitch / pitch_data) > halfToneFactor) {
            isSinging = false;
            lastPitch = 0;
            currentCounter = 0;
        } else {
            lastPitch = (lastPitch * currentCounter + pitch_data) / (currentCounter + 1);
            currentCounter += 1;
        }
      
//        NSLog(@"%d", isSinging);
        
        del_fvec(output);
        
        //    cvec_t *spectrum = new_cvec(frames);
        //    aubio_fft_do(fft_o, &input, spectrum);
        
        @autoreleasepool {
            ReceiverData *receiverData = [[ReceiverData alloc] init];
            [receiverData setIsSinging: isSinging];
            [receiverData setOnset: onset_data];
            [receiverData setPitch: pitch_data];
//            [receiverData setBpm: bpm_data];
            [receiverData setDecibel: decibel];
            [receiverData setTime: this_time];
            //mfcc
            cvec_t *spectrum = new_cvec(frames);
            aubio_fft_do(fft_o, &input, spectrum);
            fvec_t *mfcc_result = new_fvec(_mfcc_n_coeff);
            aubio_mfcc_do(mfcc_o, spectrum, mfcc_result);
            NSMutableArray *mfccArray = [[NSMutableArray alloc] initWithCapacity:_mfcc_n_coeff];
            for(int i=0; i<_mfcc_n_coeff; i++) {
                [mfccArray addObject: @(mfcc_result->data[i])];
            }
            [receiverData setMfcc: mfccArray];
            del_cvec(spectrum);
            del_fvec(mfcc_result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (delegate != NULL && this_time >= current_time) {
                    [delegate receiverDidReceiveData: receiverData];
                    
                } else {
//                    NSLog(@"Abandon! this time: %f  current time %f", this_time, current_time);
                }
            });
        }
    });
    
        
    

    
    
    
}
-(AEAudioReceiverCallback)receiverCallback {
    return receiverCallback;
}
@end

