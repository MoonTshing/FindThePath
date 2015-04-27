#import "MainScene.h"
#import "Grid.h"
#import "bgSoundEffect.h"

@implementation MainScene
-(void) onEnter{
    [self playSoundEffect:@"soundeffect/backgrounMusic.mp3" Loop:YES];
}
-(void) play{
    
    [self playSoundEffect:@"soundeffect/clickButton.mp3" Loop: NO];
    CCScene* scene = [CCBReader loadAsScene:@"LevelChosen"];
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
