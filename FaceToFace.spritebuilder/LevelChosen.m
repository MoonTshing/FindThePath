//
//  LevelChosen.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 3/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelChosen.h"

@implementation LevelChosen
-(void) exitButtonPressed
{
    NSLog(@"exit button is pressed");
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void) levelOnePressed
{

    NSLog(@"level 1 button is pressed");
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}


-(void) playSoundEffect:(NSString *)fileName Loop: (BOOL) isLoop{
    NSLog(@"enter play sound effect");
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:fileName volume:1 pan:0 loop:isLoop];
    NSLog(@"after play music");
}
@end
