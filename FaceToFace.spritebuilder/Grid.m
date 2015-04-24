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
#import "player.h"
#import "destination.h"
#import "Monster.h"
#import "door.h"
#import "Direction.h"

static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 5;
static const int BLOCK_LENGTH = 24;

@implementation Grid {
    // char _gridArray[GRID_ROWS*2+1][GRID_COLUMNS*2+1];
    float _cellWidth;
    float _cellHeight;
    CGPoint firstLocation;
    CGPoint lastLocation;
    NSMutableArray *mazeArray;
    NSMutableArray *monsters;
}

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
    [self setupGrid];
    self.userInteractionEnabled = YES;
}

-(void) setMazeArray {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"level1maze"] != nil) {
        
        // mazeArray=[[NSUserDefaults standardUserDefaults] objectForKey:@"level1maze"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"level1maze"];
        // NSLog(@"%@", mazeArray);
    }//else{
    
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
                }else if(r == GRID_ROWS*2-1 && c == GRID_COLUMNS*2-1){
                    
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
        NSString *level = [NSString stringWithFormat:@"level%dmaze",1];
        [[NSUserDefaults standardUserDefaults] setObject:mazeArray forKey:level];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
     ];
    // NSLog(@"%@", mazeArray);
    //  }
}
-(void) genDoors {
    int x = 0;
    int y = 0;
    int i = 0;
    while (i < 2) {
        x = [ self genRandIndex:1 To: (int)[[mazeArray objectAtIndex:1] count]];
        y = [self genRandIndex:1 To: 3/*(int)([mazeArray count]-1)*/];
        if ([mazeArray[y][x] isEqualToString:@"e"] || [mazeArray[y][x] isEqualToString:@"b"]) {
            mazeArray[y][x] = @"door";
            i++;
        }
        
    }
}

-(void) genMonsters {
    int x = 0;
    int y = 0;
    do{
        x = [self genRandIndex:1 To: (int)[[mazeArray objectAtIndex:1] count]];
        y = [self genRandIndex:10 To: (int)([mazeArray count]-1)];
    } while(![mazeArray[y][x] isEqualToString:@"e"]);
    printf("x= %d; y: %d\n", x, y);
    mazeArray[y][x] = @"m";
}

-(void) startMyTimer {
    [NSTimer scheduledTimerWithTimeInterval:0.1f
                                     target:self
                                   selector:@selector(fireTimer:)
                                   userInfo:nil
                                    repeats:YES];
}

-(void) fireTimer:(NSTimer *) timer{
    CCLOG(@"timer fired, start to move monsters %lu", monsters.count);
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
    CCLOG(@"moving monster %@, direct is : %lu\n", monster, monster.direction);
    NSUInteger row = [self getRowForPosition:monster.position];
    NSUInteger column = [self getColumnForPosition:monster.position];
    switch (monster.direction) {
        case North:
            // move up
            if ([mazeArray[row+1][column] isEqualToString:@"e"]) {
                monster.position = [self getPositionForRow:row+1 andColumn:column];
            }
            break;
        case South:
            // move down
            if ([mazeArray[row-1][column] isEqualToString:@"e"]) {
                monster.position = [self getPositionForRow:row-1 andColumn:column];
            }
            break;
        case West:
            //move left
            if ([mazeArray[row][column-1] isEqualToString:@"e"]) {
                monster.position = [self getPositionForRow:row andColumn:column-1];
                
            }
            break;
        case East:
            //  move right
            if ([mazeArray[row][column+1] isEqualToString:@"e"]) {
                monster.position = [self getPositionForRow:row andColumn:column+1];
            }
            break;
        default:
            NSAssert(NO, @"impossible");
    }
    monster.direction = [self getNextDirectionForNode:monster];
    [self detectRendezvous];
}

- (void) detectRendezvous {
    
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
    if ([mazeArray[row+1][column] isEqualToString:@"e"]) {
        // can go up
        [directArray addObject:[NSNumber numberWithUnsignedInteger:North]];
    }
    if ([mazeArray[row-1][column] isEqualToString:@"e"]) {
        // can go down
        [directArray addObject:[NSNumber numberWithUnsignedInteger:South]];
    }
    if ([mazeArray[row][column-1] isEqualToString:@"e"]) {
        // can go left
        [directArray addObject:[NSNumber numberWithUnsignedInteger:West]];
    }
    if ([mazeArray[row][column+1] isEqualToString:@"e"]) {
        // can go right
        [directArray addObject:[NSNumber numberWithUnsignedInteger:East]];
    }
    NSLog(@"[mazeArray[row+1][column]: %@",mazeArray[row+1][column]);
    NSLog(@"[mazeArray[row-1][column]: %@",mazeArray[row-1][column]);
    NSLog(@"[mazeArray[row][column-1]: %@",mazeArray[row][column-1]);
    NSLog(@"[mazeArray[row][column+1]: %@",mazeArray[row][column+1]);
    
    NSLog(@"direct array:  %@",directArray);
    
    if (directArray.count > 1) {
        NSNumber *reverseDirection = [NSNumber numberWithUnsignedInteger:[Grid getReverseDirection:monster.direction]];
        [directArray removeObject:reverseDirection];
        
        int randDirect = arc4random_uniform((u_int32_t) directArray.count);
        Direction newDirection = [directArray.allObjects[randDirect] unsignedIntegerValue];
        
        NSLog(@"current direction %lu, reverse direction: %lu, now size is cut: %lu, chose new direction %lu",
              monster.direction, reverseDirection.unsignedIntegerValue, directArray.count, newDirection);
        
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

-(void) setupGrid{
    [self setMazeArray];
    _cellWidth = self.contentSize.width/(GRID_COLUMNS*2+1);
    _cellHeight = self.contentSize.height/(GRID_ROWS*2+1);
    
    float x = 0;
    float y = 0;
    
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
            }else if([mazeArray[row][column]  isEqual: @"e"]){
                printf("  ");
            }else if([mazeArray[row][column]  isEqual: @"p"]){
                player *p = [[player alloc] initPlayer:24];
                p.anchorPoint = ccp(0,0);
                p.position = ccp(x,y);
                [self addChild:p z:1];
            }else if([mazeArray[row][column]  isEqual: @"d"]){
                destination *des = [[destination alloc] initDest: 24];
                des.anchorPoint = ccp(0,0);
                des.position = ccp(x,y);
                [self addChild:des];
            }else if([mazeArray[row][column]  isEqual: @"m"]){
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
            }
            
            x += _cellWidth;
            
        }
        printf("\n");
        y += _cellHeight;
    }
    [self startMyTimer];
}

-(void) moveToTransporter: (CCSprite *) node {
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

/*
 -(void) convertMazeToGrid: (bool **) maze {
 
 //  NSLog(@"%d",maze);
 
 for (int i = 0; i < GRID_ROWS*2+1; i++) {
 for (int j = 0; j < GRID_COLUMNS*2+1; j++) {
 
 if(maze[i][j] == 1)
 {
 _gridArray[i][j] = 'b';
 }else{
 _gridArray[i][j] = 'e';
 }
 printf("%c ", _gridArray[i][j]);
 }
 printf("\n");
 }
 
 }
 */











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
    if(distance > 30)
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
    NSLog(@"[%d][%d]%@",indexY,indexX,[[mazeArray objectAtIndex:indexY] objectAtIndex:indexX]);
    if(![[[mazeArray objectAtIndex:indexY] objectAtIndex:indexX] isEqualToString:@"b"]){
        return true;
    }else return false;
}
-(void)screenWasSwipedUp
{
    
    for( CCSprite* node in self.children){
        if (node.zOrder == 1) {
            CGPoint tmp = ccp(node.position.x, node.position.y + BLOCK_LENGTH);
            if ([self ableToMove:tmp]) {
                NSLog(@"%f,%f",node.position.x,node.position.y);
                node.position = tmp;
                
            }
            [self moveToTransporter:node];
        }
    }
    
    
}

-(void)screenWasSwipedDown{
    for( CCSprite* node in self.children){
        if (node.zOrder == 1) {
            CGPoint tmp = ccp(node.position.x, node.position.y - BLOCK_LENGTH);
            if ([self ableToMove:tmp]) {
                
                node.position = tmp;
                
                
            }
            [self moveToTransporter:node];
            
        }
    }
}
-(void)screenWasSwipedRight{
    for( CCSprite* node in self.children){
        if (node.zOrder == 1) {
            
            CGPoint tmp = ccp(node.position.x+BLOCK_LENGTH, node.position.y);
            if ([self ableToMove:tmp]) {
                
                node.position = tmp;
                
                
            }[self moveToTransporter:node];
            
        }
    }
}
-(void)screenWasSwipedLeft{
    for( CCSprite* node in self.children){
        if (node.zOrder == 1) {
            
            CGPoint tmp = ccp(node.position.x-BLOCK_LENGTH, node.position.y);
            if ([self ableToMove:tmp]) {
                
                node.position = tmp;
                
            }
            [self moveToTransporter:node];
            
        }
    }
}


@end
