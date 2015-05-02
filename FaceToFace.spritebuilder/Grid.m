//
//  Grid.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#include <stdlib.h>
#import "Grid.h"
#import "DEMazeGenerator.h"
#import "Block.h"
#import "Player.h"
#import "destination.h"
#import "Monster.h"
#import "door.h"
#import "Direction.h"
#import "LevelChosen.h"

static  int GRID_ROWS = 8;
static  int GRID_COLUMNS = 5;
static const int BLOCK_LENGTH = 24;
static const int SCORE_LIMIT = 10000;
static const int ONE_MOVE_SCORE = 100;

@implementation Grid {
    // char _gridArray[GRID_ROWS*2+1][GRID_COLUMNS*2+1];
    float _cellWidth;
    float _cellHeight;
    CGPoint firstLocation;
    CGPoint lastLocation;
    NSMutableArray *mazeArray;
    NSMutableArray *monsters;
    CCNode *player;
    NSTimer *timer;
    CCNode *des;
    OALSimpleAudio *bgMusic;
};

+ (Direction) getReverseDirection:(Direction) direction {
    switch (direction) {
        case North:
            return South;
        case South:
            return North;
        case West:
            return East;
        case East:
            return West;
        default:
            NSAssert(NO, @"impossible");
            return -1;
    }
}

- (void) onEnter{
    [super onEnter];
    NSLog(@"onenter grid");
    monsters = [NSMutableArray array];
    
    self.userInteractionEnabled = YES;
    _currentScore = SCORE_LIMIT;
    _level = [self getCurrentLevel];
    _highScore = [self getHighestScoreByLevel:_level];
    [self setMonsterAmount];
    [self setMonsterSpeed];
    [self setupGrid];
    [self playbg:@"soundeffect/backgrounMusic.mp3" Loop:YES];
    NSLog(@"current level: %d",_level);
    
}
-(int) getCurrentLevel{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"];
}
-(int) getHighestScoreByLevel: (int) level{
    NSString *tmp = [NSString stringWithFormat:@"level%dHighscore",level];
    if([[NSUserDefaults standardUserDefaults] integerForKey:tmp] != (NSInteger)nil)
    {
        return (int)[[NSUserDefaults standardUserDefaults] integerForKey:tmp];
    }else{
        return 0;
    }
    
}

-(void) setMonsterSpeed {
    NSInteger currentlvl = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel" ];
    NSLog(@"currentlvl: %ld", (long)currentlvl);

    float speed = 0.65 - currentlvl*0.05;
    [[NSUserDefaults standardUserDefaults] setFloat:speed forKey:@"monsterSpeed"];
}
-(void) setMonsterAmount{
    NSInteger currentlvl = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel" ];
    NSLog(@"currentlvl: %ld", (long)currentlvl);
    NSInteger amount = currentlvl >= 5? 2:1;
    [[NSUserDefaults standardUserDefaults] setInteger:amount forKey:@"monsterAmount"];
}
/*=============================================================================================
 
                                Game state control functions
 
 =============================================================================================*/


- (void)stopGame: (BOOL)win {
    [timer invalidate];
    timer = nil;
    if (win) {
        // store the high score
        _highScore = _highScore > _currentScore ? _highScore:_currentScore;
        
        NSString *tmp = [NSString stringWithFormat:@"level%dHighscore",_level];
        [[NSUserDefaults standardUserDefaults] setInteger:_highScore forKey:tmp];
        
        // pop up the window to next level/back home
        [self playSoundEffect:@"soundeffect/Winner.mp3" Loop:NO];
        [bgMusic stopBg];

        CCScene *win = [CCBReader loadAsScene:@"Win" owner:self.parent];
        NSInteger highestlvl = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentHighestLevel"];
        [[NSUserDefaults standardUserDefaults] setInteger:highestlvl>_level+1? highestlvl:_level+1 forKey:@"currentHighestLevel"];
        [self.parent addChild:win z:1 name:@"win"];
        // play the winner sound (dunno how to make it easy)
    }else{
        //pop up the loser window( I am so mean >_<) replay or quit
        [self playSoundEffect:@"soundeffect/Loser.mp3" Loop:NO];
        [bgMusic stopBg];
        CCScene *lose = [CCBReader loadAsScene:@"Lose" owner:self.parent];
        [self.parent addChild:lose z:1 name:@"lose"];
        //play the loser sound effect
    }
    CCLOG(@"you %@", win ? @"won" : @"lost");
}

-(void) pauseGame{
    [timer invalidate];
    timer = nil;
    
}
-(void) resumeGame{
    [self startMyTimer];
}



/*=============================================================================================
 
                                    Button functions
 
 =============================================================================================*/



-(void)homButtonPressed {
    CCLOG(@"call resumeButtonPressed");
    LevelChosen *levelScene = (LevelChosen*)[CCBReader loadAsScene:@"LevelChosen"];
    [[CCDirector sharedDirector] replaceScene:levelScene];
    //TODO: game pause
}


/*=============================================================================================
 
                                    Movement functions
 
 =============================================================================================*/

-(void) startMyTimer {
    float tmp = [[NSUserDefaults standardUserDefaults] floatForKey:@"monsterSpeed"];
    NSLog(@"current speed: %f", tmp);
    timer = [NSTimer scheduledTimerWithTimeInterval:tmp
                                             target:self
                                           selector:@selector(fireTimer:)
                                           userInfo:nil
                                            repeats:YES];
    
}


-(void) fireTimer:(NSTimer *) timer{
    //    CCLOG(@"timer fired, start to move monsters %lu", monsters.count);
    for (Monster *monster in monsters) {
        [self moveMonster:monster];
    }
}

- (int) currentPositionToRow: (CCNode *)node {
    return (int) node.position.y/BLOCK_LENGTH;
}

- (int) currentPositionToColumn: (CCNode *)node {
    return (int) node.position.x/BLOCK_LENGTH;
}

- (CGPoint) getPositionForRow: (NSUInteger)row andColumn:(NSUInteger)column {
    return ccp(column * BLOCK_LENGTH, row * BLOCK_LENGTH);
}

- (Direction) getNextDirectionForNode: (Monster *)monster {
    return [self generateRandomDirectionForMonster:monster];
}

- (void) moveMonster: (Monster*) monster {
    //    CCLOG(@"moving monster %@, direct is : %lu\n", monster, monster.direction);
    NSUInteger row = [self getRowForPosition:monster.position];
    NSUInteger column = [self getColumnForPosition:monster.position];
    switch (monster.direction) {
        case North:
            // move up
            if ([mazeArray[row+1][column] isEqualToString:@"e"]||[mazeArray[row+1][column] isEqualToString:@"door"]) {
                monster.position = [self getPositionForRow:row+1 andColumn:column];
            }
            break;
        case South:
            // move down
            if ([mazeArray[row-1][column] isEqualToString:@"e"]||[mazeArray[row-1][column] isEqualToString:@"door"]) {
                monster.position = [self getPositionForRow:row-1 andColumn:column];
            }
            break;
        case West:
            //move left
            if ([mazeArray[row][column-1] isEqualToString:@"e"]||[mazeArray[row][column-1] isEqualToString:@"door"]) {
                monster.position = [self getPositionForRow:row andColumn:column-1];
                
            }
            break;
        case East:
            //  move right
            if ([mazeArray[row][column+1] isEqualToString:@"e"]||[mazeArray[row][column+1] isEqualToString:@"door"]) {
                monster.position = [self getPositionForRow:row andColumn:column+1];
            }
            break;
        default:
            NSAssert(NO, @"impossible");
    }
    monster.direction = [self getNextDirectionForNode:monster];
    if (YES == [self detectRendezvous:monster andAnotherNode:player]) {
        [self stopGame:NO];
    }
}

- (BOOL) detectRendezvous: (CCNode*)nodeA andAnotherNode: (CCNode *)nodeB {
    if ([self getRowForPosition:nodeA.position] == [self getRowForPosition:nodeB.position] &&
        [self getColumnForPosition:nodeA.position] == [self getColumnForPosition:nodeB.position]) {
        return YES;
    }
    return NO;
}



-(void) moveToTheOtherDoor: (CCSprite *) node {
    NSLog(@"%f,%f",node.position.x,node.position.y);
    int row = [self currentPositionToRow:node];
    int col = [self currentPositionToColumn:node];
    
    if ([mazeArray[row][col] isEqualToString:@"door"]) {
        for(int r = 0; r < [mazeArray count]; r ++) {
            for (int c = 0; c < [[mazeArray objectAtIndex: r] count]; c++) {
                if ((r != row || c != col) && [mazeArray[r][c] isEqualToString: @"door"]) {
                    CGPoint newPosition = [self getPositionForRow:r andColumn:c];
                    id fadeOut = [CCActionFadeOut actionWithDuration:0.5];
                    id move = [CCActionCallBlock actionWithBlock:^{
                        node.position = newPosition;
                    }];
                    id fadeIn = [CCActionFadeIn actionWithDuration:0.5];
                    id sequence = [CCActionSequence actions:fadeOut, move, fadeIn, nil];
                    [node runAction:sequence];
                }
            }
        }
    }
}

/*=============================================================================================
 
                                Objects generate functions
 
 =============================================================================================*/
-(void) genMonsters {
    NSLog(@"current amount: %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"monsterAmount"]);
    
    for (int i = 0; i < [[NSUserDefaults standardUserDefaults] integerForKey:@"monsterAmount"]; i++) {
    int x = 0;
    int y = 0;
    do{
        x = [self genRandIndex:1 To: (int)[[mazeArray objectAtIndex:1] count]];
        y = [self genRandIndex:10 To: (int)([mazeArray count]-1)];
    } while(![mazeArray[y][x] isEqualToString:@"e"]);
    printf("x= %d; y: %d\n", x, y);
    mazeArray[y][x] = @"m";
    }
}

- (NSUInteger) getRowForPosition: (CGPoint) position {
    return position.y / BLOCK_LENGTH;
}

- (NSUInteger) getColumnForPosition: (CGPoint) position {
    return position.x / BLOCK_LENGTH;
}

-(Direction) generateRandomDirectionForMonster: (Monster *)monster {
    NSUInteger row = [self getRowForPosition:monster.position];
    NSUInteger column = [self getColumnForPosition:monster.position];
    
    NSMutableSet* directArray = [NSMutableSet set];
    if ([mazeArray[row+1][column] isEqualToString:@"e"]||[mazeArray[row+1][column] isEqualToString:@"door"]) {
        // can go up
        [directArray addObject:[NSNumber numberWithUnsignedInteger:North]];
    }
    if ([mazeArray[row-1][column] isEqualToString:@"e"]||[mazeArray[row-1][column] isEqualToString:@"door"]) {
        // can go down
        [directArray addObject:[NSNumber numberWithUnsignedInteger:South]];
    }
    if ([mazeArray[row][column-1] isEqualToString:@"e"]||[mazeArray[row][column-1] isEqualToString:@"door"]) {
        // can go left
        [directArray addObject:[NSNumber numberWithUnsignedInteger:West]];
    }
    if ([mazeArray[row][column+1] isEqualToString:@"e"]||[mazeArray[row][column+1] isEqualToString:@"door"]) {
        // can go right
        [directArray addObject:[NSNumber numberWithUnsignedInteger:East]];
    }
    
    if (directArray.count > 1) {
        NSNumber *reverseDirection = [NSNumber numberWithUnsignedInteger:[Grid getReverseDirection:monster.direction]];
        [directArray removeObject:reverseDirection];
        
        int randDirect = arc4random_uniform((u_int32_t) directArray.count);
        Direction newDirection = [directArray.allObjects[randDirect] unsignedIntegerValue];
        
        return newDirection;
    } else {
        return [directArray.allObjects.firstObject unsignedIntegerValue];
    }
}

-(int) genRandIndex: (int)min To: (int)max{
    int a = 0;
    while ((a =arc4random_uniform(max)) <= min) {
        ;
    }
    return a;
}


-(void) genDoors {
    int x = 0;
    int y = 0;
    int i = 0;
    while (i < 2) {
        x = [ self genRandIndex:(int)arc4random_uniform(8) To: (int)[[mazeArray objectAtIndex:1] count]-2];
        y = [self genRandIndex:(int)arc4random_uniform(8) To: (int)([mazeArray count]-2)];
        if ([mazeArray[y][x] isEqualToString:@"e"] || ([mazeArray[y][x] isEqualToString:@"b"] && [self isValidplaceForDoorwithRow:y WithColumn:x]) ){
            mazeArray[y][x] = @"door";
            i++;
        }
        
    }
}
-(BOOL) isValidplaceForDoorwithRow: (int) row WithColumn: (int) column {
    
    if(row == ([mazeArray count]-1)){
        if ([mazeArray[row][column+1] isEqual: @"b"] &&
            [mazeArray[row][column-1] isEqual: @"b"] &&
            [mazeArray[row-1][column] isEqual: @"b"]) {
            return NO;
        }
        return YES;
    } else if( row== 0){
        if ([mazeArray[row][column+1] isEqual: @"b"] &&
            [mazeArray[row][column-1] isEqual: @"b"] &&
            [mazeArray[row+1][column] isEqual: @"b"]) {
            return NO;
        }
        return YES;
    }
    if(column == ([mazeArray[0] count]-1)){
        if ([mazeArray[row+1][column] isEqual: @"b"] &&
            [mazeArray[row-1][column] isEqual: @"b"] &&
            [mazeArray[row][column-1] isEqual: @"b"]) {
            return NO;
        }
        return YES;
    } else if( column== 0){
        if ([mazeArray[row+1][column] isEqual: @"b"] &&
            [mazeArray[row-1][column] isEqual: @"b"] &&
            [mazeArray[row][column+1] isEqual: @"b"]) {
            return NO;
        }
        return YES;
    }
    return YES;
}


/*=============================================================================================
 
                                    Maze Setup functions
 
 =============================================================================================*/

-(void) setMazeArray {
    NSString *tmp = [NSString stringWithFormat:@"level%dmaze",_level];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:tmp] != nil) {
        //NSLog(@"already exist: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"level1maze"]);
        //NSArray *s = [[NSArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"level1maze"] copyItems:YES ];
        
        mazeArray = [self loadCustomObjectWithKey:tmp];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:tmp];
      // [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"level1maze"];
        // NSLog(@"%@", mazeArray);
    }else{
    
    
    DEMazeGenerator *maze = [[DEMazeGenerator alloc] initWithRow:GRID_ROWS andCol:GRID_COLUMNS withStartingPoint:DEIntegerPointMake(1, 1)];
    
    [maze arrayMaze:^(bool **item) {
        
        mazeArray = [[NSMutableArray alloc] init];
        for (int r = 0; r < GRID_ROWS*2+1; r++)
        {
            
            NSMutableArray *inner = [[NSMutableArray alloc] init];
            for (int c = 0; c < GRID_COLUMNS*2+1; c++)
            {
                
                if (r == 1 && c == 1) {
                    // add player node
                    
                    [inner addObject:[NSString stringWithFormat:@"p"]];
                }else if(r == GRID_ROWS*2 && c == GRID_COLUMNS*2-1){
                    
                    // add destination node
                    [inner addObject:[NSString stringWithFormat:@"d"]];
                    
                }else{
                    
                    if(item[r][c] == 1)
                    {
                        // add block node in the maze
                        [inner addObject: [NSString stringWithFormat:@"b"]];
                    }else{
                        // add empty path node in the maze
                        [inner addObject: [NSString stringWithFormat:@"e"]];
                    }
                }
                
                
            }
            [mazeArray addObject: inner];
            
            
            
        }
        // Place the initial position of monsters
        [self genMonsters];
        [self genDoors];
        [self genPath];
        [self saveCustomObject:mazeArray key:tmp];
        //[[NSUserDefaults standardUserDefaults] setObject:mazeArray forKey:level];
         NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:tmp]);
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
     ];
    // NSLog(@"%@", mazeArray);
      }
}

- (void) genPath{
    
    int empty = 2;
    int k = 0;
    while (k < empty) {
        int c = [self genRandIndex:2 To:(int)[mazeArray[1] count]-1];
        int r = [self genRandIndex:2 To:(int)mazeArray.count-1];
        if ([mazeArray[r][c] isEqualToString:@"b"]) {
            if (([mazeArray[r-1][c] isEqualToString:@"b"] && [mazeArray[r+1][c] isEqualToString:@"b"]) ||
                ([mazeArray[r][c+1] isEqualToString:@"b"] && [mazeArray[r][c-1] isEqualToString:@"b"]) ) {
                mazeArray[r][c] = @"e";
                k++;
            }
        }
    }
}



- (void)saveCustomObject:(NSMutableArray *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (NSMutableArray *)loadCustomObjectWithKey:(NSString *)key {
    NSLog(@"in %@",key);
    
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSLog(@"out");
    NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
     NSLog(@"out");
    return object;
}

-(void) setupGrid{
    [self setMazeArray];
    _cellWidth = self.contentSize.width/(GRID_COLUMNS*2+1);
    _cellHeight = self.contentSize.height/(GRID_ROWS*2+1);
    
    float x = 0;
    float y = 0;
    
  //  NSLog(@"%@",mazeArray);
    
    for(int row = 0; row < [mazeArray count]; row++){
        
        x = 0;
        
        for (int column = 0; column < [[mazeArray objectAtIndex: row] count]; column++) {
            //NSMutableArray *tmp = [mazeArray objectAtIndex:row];
            
            if ([mazeArray[row][column]  isEqual: @"b"]) {
                printf("* ");
                Block *block = [[Block alloc] initBlock:24];
                block.anchorPoint= ccp(0,0);
                block.position = ccp(x,y);
                [self addChild:block];
            }else if([mazeArray[row][column] isEqual: @"e"]){
                printf("  ");
            }else if([mazeArray[row][column] isEqual: @"p"]){
                player = [[Player alloc] initPlayer:24];
                player.anchorPoint = ccp(0,0);
                player.position = ccp(x,y);
                [self addChild:player z:1];
            }else if([mazeArray[row][column] isEqual: @"d"]){
                des = [[destination alloc] initDest: 24];
                des.anchorPoint = ccp(0,0);
                des.position = ccp(x,y);
                [self addChild:des];
            }else if([mazeArray[row][column] isEqual: @"m"]){
                CCLOG(@"loaded moster at %d %d", row, column);
                Monster *monster = [Monster newMonsterWithWidth:24 andHeight:24];
                monster.anchorPoint = ccp(0,0);
                monster.position = ccp(x,y);
                [self addChild:monster z:2];
                [monsters addObject:monster];
                mazeArray[row][column] = @"e";
            }else if([mazeArray[row][column] isEqualToString:@"door"])
            {
                door *Door = [[door alloc] initDoor:24];
                Door.anchorPoint = ccp(0,0);
                Door.position = ccp(x,y);
                [self addChild:Door];
                //mazeArray[row][column] = @"e";
            }
            
            x += _cellWidth;
            
        }
        printf("\n");
        y += _cellHeight;
    }
    [self startMyTimer];
}










/*=============================================================================================
 
                                    Touch helper functions
 
 =============================================================================================*/
-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    firstLocation = [touch locationInNode:self];
}

-(float) angleBetweenPoints: (CGPoint ) endPoint andStart: (CGPoint)startPoint {
    float dis = ccpDistance(endPoint, startPoint);
    return (endPoint.x - startPoint.x)/dis;
    
}
-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    lastLocation = [touch locationInNode:self];
    float distance = ccpDistance(lastLocation, firstLocation);
    float angle = [self angleBetweenPoints: lastLocation andStart:firstLocation];
    if(distance > 10)
    {
        if(angle < 0.12 && angle > -0.12)
        {
            if(lastLocation.y > firstLocation.y)
            {
                [self screenWasSwipedUp];
            }else if (lastLocation.y < firstLocation.y)
            {
                [self screenWasSwipedDown];
            }
        } else if (ABS(angle) > 0.88){
            if(lastLocation.x < firstLocation.x )
            {
                [self screenWasSwipedLeft];
            } else if(lastLocation.x > firstLocation.x)
            {
                [self screenWasSwipedRight];
            }
        }
        
        
        
    }
}

-(BOOL) ableToMove: (CGPoint ) node{
    int indexX = node.x/_cellWidth;
    int indexY = node.y/_cellHeight;
    if(indexY < [mazeArray count] && indexX < [mazeArray[0] count])
    {
        NSLog(@"[%d][%d]%@",indexY,indexX,[[mazeArray objectAtIndex:indexY] objectAtIndex:indexX]);
        if(![[[mazeArray objectAtIndex:indexY] objectAtIndex:indexX] isEqualToString:@"b"]){
            return true;
        }else return false;
    }
    return false;
}
-(void)screenWasSwipedUp
{
    
    for( CCSprite* node in self.children){
        if (node.zOrder == 1) {
            CGPoint tmp = ccp(node.position.x, node.position.y + BLOCK_LENGTH);
            if ([self ableToMove:tmp]) {
                NSLog(@"%f,%f",node.position.x,node.position.y);
                node.position = tmp;
                if (_currentScore >= 100) {
                    _currentScore -= ONE_MOVE_SCORE;
                }else{
                    [self stopGame:NO];
                }
                
            }
            [self moveToTheOtherDoor:node];
            if (YES == [self detectRendezvous:node andAnotherNode:des]) {
                [self stopGame:YES];
            }
        }
    }
    
    
}

-(void)screenWasSwipedDown{
    for( CCSprite* node in self.children){
        if (node.zOrder == 1) {
            CGPoint tmp = ccp(node.position.x, node.position.y - BLOCK_LENGTH);
            if ([self ableToMove:tmp]) {
                
                node.position = tmp;
                if (_currentScore >= 100) {
                    _currentScore -= ONE_MOVE_SCORE;
                }else{
                    [self stopGame:NO];
                }
                
            }
            [self moveToTheOtherDoor:node];
            if (YES == [self detectRendezvous:node andAnotherNode:des]) {
                [self stopGame:YES];
            }
        }
    }
}
-(void)screenWasSwipedRight{
    for( CCSprite* node in self.children){
        if (node.zOrder == 1) {
            
            CGPoint tmp = ccp(node.position.x+BLOCK_LENGTH, node.position.y);
            if ([self ableToMove:tmp]) {
                
                node.position = tmp;
                
                if (_currentScore >= 100) {
                    _currentScore -= ONE_MOVE_SCORE;
                }else{
                    [self stopGame:NO];
                }
            }[self moveToTheOtherDoor:node];
            if (YES == [self detectRendezvous:node andAnotherNode:des]) {
                [self stopGame:YES];
            }
            
        }
    }
}
-(void)screenWasSwipedLeft{
    for( CCSprite* node in self.children){
        if (node.zOrder == 1) {
            
            CGPoint tmp = ccp(node.position.x-BLOCK_LENGTH, node.position.y);
            if ([self ableToMove:tmp]) {
                
                node.position = tmp;
                if (_currentScore >= 100) {
                    _currentScore -= ONE_MOVE_SCORE;
                }else{
                    [self stopGame:NO];
                }
            }
            [self moveToTheOtherDoor:node];
            if (YES == [self detectRendezvous:node andAnotherNode:des]) {
                [self stopGame:YES];
            }
            
        }
    }
}

#pragma mark - level chose

- (void)onLevelChosen:(NSUInteger)level {
    _level = (int)level;
    NSLog(@"saaaaaaaaaaaaaaaaa");
}

-(void) playSoundEffect:(NSString *)fileName Loop: (BOOL) isLoop{
    NSLog(@"enter play sound effect");
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playEffect:fileName volume:(1) pitch:1 pan:0 loop:isLoop];
    NSLog(@"after play music");
}

-(void) nextLevelButtonPressed{
    _level ++;
    CCScene * newScene = [CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:newScene];
    
}

-(void) playbg:(NSString *)fileName Loop: (BOOL) isLoop{
    NSLog(@"enter play sound effect");
    // access audio object
    bgMusic = [OALSimpleAudio sharedInstance];
    // play background sound
    [bgMusic playBg:fileName volume:1 pan:0 loop:isLoop];
    NSLog(@"after play music");
}
@end
