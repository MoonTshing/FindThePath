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
@implementation GameScene{
    Pause *_pause;
}

/*-(id) init{
 self = [super init];
 
 if(self)
 {
 _currentScore = 0;
 _highestScore = 0;
 // get the higest score from the userdefault data
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 if(defaults != nil){
 _highestScore = [defaults integerForKey:@Need a key];
 }else{
 _highestScore = 0;
 }
 }
 return self;
 }*/

- (void)onEnter {
    [super onEnter];
    _pause.zOrder = -1;
    _pause.visible = NO;
}

-(void) pauseButtonPressed
{
    CCLOG(@"pause button pressed");
    _pause.visible = YES;
    _pause.zOrder = 1;
   /* CCScene* scene = [CCBReader loadAsScene:@"Pause"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];*/
}



/*-(void) moveTheNode
 {
 UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(screenWasSwipedUp)];
 
 swipeUp.numberOfTouchesRequired = 1;
 swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
 [self.view addGestureRecognizer: swipeUp];
 
 }
 */
@end
