//
//  Lose.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Lose.h"

@implementation Lose
-(void)homeButtonPressed{
    NSLog(@"homebutton pressed");
    CCScene *home = [CCBReader loadAsScene:@"LevelChosen"];
    [[CCDirector sharedDirector] replaceScene:home];
}
@end
