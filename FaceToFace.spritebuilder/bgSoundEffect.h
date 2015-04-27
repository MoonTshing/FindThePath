//
//  bgSoundEffect.h
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <OALSimpleAudio.h>

@interface bgSoundEffect : OALSimpleAudio

-(void) playSoundEffect:(NSString *)fileName Loop: (BOOL) isLoop;
@end
