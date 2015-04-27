//
//  bgSound.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "bgSound.h"

@implementation bgSound

-(void) playSoundwithName: (NSString *)fileName{
    NSString *soundPath = fileName;
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundPath];
    NSError * err;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&err];
    if (nil == audioPlayer) {
        NSLog(@"Failed to play %@, Error: %@",soundFileURL,err);
        return;
    }
    [audioPlayer prepareToPlay];
    [audioPlayer setVolume:3];
    [audioPlayer setDelegate:nil];
    audioPlayer.numberOfLoops = 100;
    [audioPlayer play];
}

@end