//
//  Win.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Win.h"
#import "Grid.h"
@implementation Win

-(void) nextLevelButtonPressed{
    NSInteger tmp = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLevel"];
    tmp ++;
    [[NSUserDefaults standardUserDefaults]setInteger:tmp forKey:@"currentLevel"];
    CCScene * newScene =[CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:newScene];
    
}
@end
