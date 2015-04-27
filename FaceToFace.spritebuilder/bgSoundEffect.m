//
//  bgSoundEffect.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "bgSoundEffect.h"

@implementation bgSoundEffect{
    OALSimpleAudio *audio;
}

-(void) playSoundEffect:(NSString *)fileName Loop: (BOOL) isLoop{
    NSLog(@"enter play sound effect");
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:fileName volume:1 pan:1 loop:isLoop];
    NSLog(@"after play music");
}@end
