#import "MainScene.h"
#import "Grid.h"


@implementation MainScene{
    Grid *_grid;
    CCLabelTTF *_currentScore;
    CCLabelTTF *_highestScore;
}


-(void) play{
    CCLOG(@"play button pressed");
    
    CCScene* scene = [CCBReader loadAsScene:@"LevelChosen"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];

}
@end
