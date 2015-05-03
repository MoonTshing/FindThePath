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
#import "LevelChosen.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@implementation GameScene{
    CCLabelTTF *_highestScore;
    CCLabelTTF *_currentScore;
    OALSimpleAudio *bgMusic;
    int level;
    Grid *_grid;
    Pause *_pause;
}

- (void)onEnter {
    [super onEnter];
    
    _currentScore.string = [NSString stringWithFormat:@"%d", _grid.currentScore];
    _highestScore.string = [NSString stringWithFormat:@"%d", _grid.highScore];
    
    [self hidePause];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"needTutorial"] == YES) {
        CCNode *tutorial = [CCBReader loadAsScene:@"Tutorial" owner:self];
        tutorial.opacity = 0.6;
        [self addChild:tutorial z: 5 name:@"tutorial"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"needTutorial"];
    }
    NSLog(@"level is %d",level);
   // [self playbg:@"soundeffect/backgrounMusic.mp3" Loop:YES];
    //bg = [[bgSound alloc] init];
    //[bg playSoundwithName:@"soundeffect/backgrounMusic" RunNumberOfLoop:10];
    
    self.userInteractionEnabled = YES;
}

-(void)endTutorialButtonPressed{
    CCLOG(@"call endTutorialbButtonPressed");
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    [self removeChildByName:@"tutorial"];
}

-(void) pauseButtonPressed
{
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    [_grid pauseGame];
    [self showPause];
}

-(void)resumeButtonPressed {
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    [self hidePause];
    [_grid resumeGame];
}

-(void) restartButtonPressed {
    [self removeChildByName:@"Pause"];
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    GameScene * newScene = (GameScene *)[CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:newScene];
}

-(void)homeButtonPressed {
    CCLOG(@"call resumeButtonPressed");
    LevelChosen *levelScene = (LevelChosen*)[CCBReader loadAsScene:@"LevelChosen"];
    [[CCDirector sharedDirector] replaceScene:levelScene];
    //TODO: game pause
}

-(void)nextLevelButtonPressed{
    CCLOG(@"next level button pressed");
    NSInteger highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentHighestLevel"];
    if (highestLevel <= 9) {
        NSInteger tmp =[[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"];
        if ( tmp<= highestLevel && tmp < 9) {
            [[NSUserDefaults standardUserDefaults] setInteger:tmp+1 forKey:@"currentLevel"];
            CCScene *nextLevel = [CCBReader loadAsScene:@"GameScene"];
            [[CCDirector sharedDirector]replaceScene:nextLevel];
        }
    }else{
        NSLog(@"currentlevel: %ld, highestlevel: %ld", [[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"], highestLevel);
        CCLOG(@"no higher level");
    }
}

-(void) playSoundEffect:(NSString *)fileName Loop: (BOOL) isLoop{
    NSLog(@"enter play sound effect");
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playEffect:fileName volume:(1) pitch:1 pan:0 loop:isLoop];
    NSLog(@"after play music");
}


-(void)update:(CCTime)delta {
    _currentScore.string = [NSString stringWithFormat:@"%d", _grid.currentScore];
}

- (void)shareToFacebook {
    CCLOG(@"Begin to share to Facebook.");
    //Deliberate no image for now.
    UIImage *img = [UIImage imageNamed:@"abc"];
    
    FBSDKSharePhoto *screen = [[FBSDKSharePhoto alloc] init];
    screen.image = img;
    screen.userGenerated = YES;
    //[screen setImageURL:[NSURL URLWithString:@""]];
    
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[screen];
    
    
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = [CCDirector sharedDirector];
    
    [dialog setShareContent:content];
    dialog.mode = FBSDKShareDialogModeShareSheet;
    [dialog show];
}

#pragma mark - pausing scene

- (void)hidePause {
    CCLOG(@"%@", _pause);
    _pause.zOrder = -100;
    _pause.visible = NO;
}

- (void)showPause {
    CCLOG(@"%@", _pause);
    _pause.zOrder = 100;
    _pause.visible = YES;
}

@end
