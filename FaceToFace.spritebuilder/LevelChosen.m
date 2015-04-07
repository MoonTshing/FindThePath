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
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:1.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void) levelOnePressed
{
    NSLog(@"level 1 button is pressed");
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:1.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}
@end
