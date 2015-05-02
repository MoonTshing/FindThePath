//
//  Grid.h
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "LevelChosen.h"

@interface Grid : CCSprite <LevelChooseDelegate>

@property(nonatomic, assign) int level;
@property(nonatomic, assign) int currentScore;
@property(nonatomic, assign) int highScore;

-(void) resumeGame;
-(void) pauseGame;

//-(void) restartGame: (CCScene*)replay;
@end
