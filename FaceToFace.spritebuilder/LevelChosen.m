//
//  LevelChosen.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 3/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelChosen.h"

@implementation LevelChosen

-(void) exitButtonPressed {
    NSLog(@"exit button is pressed");
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

- (void) onLevelButtonPressed:(id)sender {
    
    CCButton *butten = (CCButton *)sender;
    NSString *name = butten.name;
    NSLog(@"level name :%@", name);
    
}

-(void) levelOnePressed
{

    NSLog(@"level 1 button is pressed");
    [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"currentLevel"];
    
    [self.delegate onLevelChosen:1];
    
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void) levelTwoPressed
{
    
    NSLog(@"level 2 button is pressed");
    [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"currentLevel"];

    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void) levelThreePressed
{
    
    NSLog(@"level 3 button is pressed");
    [[NSUserDefaults standardUserDefaults]setInteger:3 forKey:@"currentLevel"];

    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}
-(void) levelFourPressed
{
    
    NSLog(@"level 4 button is pressed");
    [[NSUserDefaults standardUserDefaults]setInteger:4 forKey:@"currentLevel"];

    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void) levelFivePressed
{
    
    NSLog(@"level 5 button is pressed");
    [[NSUserDefaults standardUserDefaults]setInteger:5 forKey:@"currentLevel"];
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}
-(void) levelSixPressed
{
    
    NSLog(@"level 6 button is pressed");
    [self.delegate onLevelChosen:6];
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}
-(void) levelSevenPressed: (id)sender
{
    
    NSLog(@"level 7 button is pressed");
    [self.delegate onLevelChosen:7];
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}
-(void) levelEightPressed
{
    
    NSLog(@"level 8 button is pressed");
    [self.delegate onLevelChosen:8];
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}
-(void) levelNinePressed
{
    
    NSLog(@"level 9 button is pressed");
    [self.delegate onLevelChosen:9];
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
