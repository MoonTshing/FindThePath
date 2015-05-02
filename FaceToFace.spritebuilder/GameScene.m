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
  }



- (void)onEnter {
    [super onEnter];
    _currentScore.string = [NSString stringWithFormat:@"%d", _grid.currentScore];
    _highestScore.string = [NSString stringWithFormat:@"%d", _grid.highScore];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"needTutorial"] == nil){
        BOOL needTutorial = YES;
        [[NSUserDefaults standardUserDefaults] setBool:needTutorial forKey:@"needTutorial"];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"needTutorial"] == YES) {
        CCNode *tutorial = [CCBReader loadAsScene:@"Tutorial" owner:self];
        tutorial.opacity = 0.6;
        [self addChild:tutorial z: 5 name:@"tutorial"];
    }
    NSLog(@"level is %d",level);
   // [self playbg:@"soundeffect/backgrounMusic.mp3" Loop:YES];
    //bg = [[bgSound alloc] init];
    //[bg playSoundwithName:@"soundeffect/backgrounMusic" RunNumberOfLoop:10];
}

-(void)endTutorialButtonPressed{
    CCLOG(@"call endTutorialbButtonPressed");
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    [self removeChildByName:@"tutorial"];
}

-(void) pauseButtonPressed
{
    CCLOG(@"pause button pressed");
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    CCNode* scene = [CCBReader loadAsScene:@"Pause" owner:self];
    scene.opacity = 0.6;
    [self addChild:scene z:1 name:@"Pause"];
    [_grid pauseGame];
    //[self pauseButtonPressed];
    //TODO: game pause
}
-(void)resumeButtonPressed {
    CCLOG(@"call resumeButtonPressed");
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    [self removeChildByName:@"Pause"];
    [_grid resumeGame];
    //TODO: resume pause
}

-(void) restartButtonPressed {
    [self removeChildByName:@"Pause"];
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    GameScene * newScene = (GameScene *)[CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:newScene];
    
}

-(void) musicButtonPressed {
   
    [bgMusic stopBg];
        NSLog(@"music is muted");

    NSLog(@"music button is pressed");
}

-(void)homeButtonPressed {
    CCLOG(@"call resumeButtonPressed");
    LevelChosen *levelScene = (LevelChosen*)[CCBReader loadAsScene:@"LevelChosen"];
    [[CCDirector sharedDirector] replaceScene:levelScene];
    //TODO: game pause
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

@end
