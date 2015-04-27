//
//  GameScene.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "Grid.h"
#import <UIKit/UIKit.h>
#import "player.h"
#import "Pause.h"
#import "Grid.h"
@implementation GameScene{
    //    NSNumber *_highScore;
    //    NSNumber *_currentScore;
    Grid *_grid;
    //
}


//-(id) init{
// self = [super init];
// 
// if(self)
// {
// _currentScore = 0;
// _highScore = 0;
// // get the higest score from the userdefault data
// NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
// if(defaults != nil){
// _highScore = [defaults integerForKey:@Need a key];
// }else{
// _highScore = 0;
// }
// }
// return self;
// }

- (void)onEnter {
    [super onEnter];
    
}

-(void) pauseButtonPressed
{
    CCLOG(@"pause button pressed");
    CCNode* scene = [CCBReader loadAsScene:@"Pause" owner:self];
    scene.opacity = 0.6;
    [self addChild:scene z:1 name:@"Pause"];
    [_grid pauseGame];
    //[self pauseButtonPressed];
    //TODO: game pause
}
-(void)resumeButtonPressed {
    CCLOG(@"call resumeButtonPressed");
    [self removeChildByName:@"Pause"];
    [_grid resumeGame];
    //TODO: resume pause
}

-(void) restartButtonPressed {
    [self removeChildByName:@"Pause"];
    GameScene * newScene = (GameScene *)[CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:newScene
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void) musicButtonPressed {
    
}

-(void)homeButtonPressed {
    CCLOG(@"call resumeButtonPressed");
    
    //TODO: game pause
}

-(void)pauseGamePlayScene{
   //[[CCDirector sharedDirector] pause];
}





@end
