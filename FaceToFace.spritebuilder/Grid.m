//
//  Grid.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Grid.h"
#import "DEMazeGenerator.h"
#import "Block.h"
#import "player.h"
#import "destination.h"
#import "bad.h"
#import "door.h"
#include <stdlib.h>

typedef NS_ENUM(NSUInteger, Direction) {
    North = 0,
    South = 1,
    East = 2,
    West = 3
};

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
    Direction currentDirection;
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
    [self setupGrid];
    [[CCDirector sharedDirector] view];
    
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
        [self genMonster];
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
-(void) genMonster {
    int x = 0;
    int y = 0;
    do{
        x = [ self genRandIndex:1 To: (int)[[mazeArray objectAtIndex:1] count]];
        y = [self genRandIndex:10 To: (int)([mazeArray count]-1)];
        
    }while(![mazeArray[y][x] isEqualToString:@"e"]);
    printf("x= %d; y: %d\n", x, y);
    mazeArray[y][x] = @"m";
    
}

-(void) startMyTimer: (CCSprite *) monster {
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(fireTimer:) userInfo:monster repeats:YES];
    
}

-(void) fireTimer: (NSTimer *) timer{
    
    // int d = (int)[[[timer userInfo] objectAtIndex:1] integerValue];
    [self moveMonster:[timer userInfo]];
    //[[timer userInfo] setObject: [NSNumber numberWithInt:d] atIndex:1];
}

- (int) currentPositionToRow: (CCNode *)monster {
    return (int) monster.position.y/BLOCK_LENGTH;
}

- (int) currentPositionToColumn: (CCNode *)monster {
    return (int) monster.position.x/BLOCK_LENGTH;
}

- (void) updateNextDirection: (CCNode *)monster {
    int row = [self currentPositionToRow:monster];
    int column = [self currentPositionToColumn:monster];
    currentDirection = [self genRandDirect:row and:column];
}

- (void) moveMonster: (CCSprite *) monster {
    printf("direct is : %lu\n", currentDirection);
    
    int row = [self currentPositionToRow:monster];
    int column = [self currentPositionToColumn:monster];
    
    switch (currentDirection) {
        case North:
            // move up
            if ([mazeArray[row+1][column] isEqualToString:@"e"]) {
                monster.position = ccp(monster.position.x, monster.position.y+BLOCK_LENGTH);
            }
            break;
        case South:
            // move down
            if ([mazeArray[row-1][column] isEqualToString:@"e"]) {
                monster.position = ccp(monster.position.x, monster.position.y-BLOCK_LENGTH);
            }
            break;
        case West:
            //move left
            if ([mazeArray[row][column-1] isEqualToString:@"e"]) {
                monster.position = ccp(monster.position.x-BLOCK_LENGTH, monster.position.y);
                
            }
            break;
        case East:
            //  move right
            if ([mazeArray[row][column+1] isEqualToString:@"e"]) {
                monster.position = ccp(monster.position.x+BLOCK_LENGTH, monster.position.y);
            }
            break;
        default:
            NSAssert(NO, @"impossible");
    }
    
    [self updateNextDirection:monster];
}

-(Direction) genRandDirect: (int) row and: (int) column{
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
        NSNumber *reverseDirection = [NSNumber numberWithUnsignedInteger:[Grid getReverseDirection:currentDirection]];
        [directArray removeObject:reverseDirection];
        
        int randDirect = arc4random_uniform((u_int32_t) directArray.count);
        Direction newDirection = [directArray.allObjects[randDirect] unsignedIntegerValue];
        
        NSLog(@"current direction %lu, reverse direction: %lu, now size is cut: %lu, chose new direction %lu",
              currentDirection, reverseDirection.unsignedIntegerValue, directArray.count, newDirection);
        
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
                bad *monster = [[bad alloc] initBad: 24 andHeight: 24];
                monster.anchorPoint = ccp(0,0);
                monster.position = ccp(x,y);
                [self addChild:monster z:2];
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
    
    for( CCSprite* node in self.children){
        if (node.zOrder == 2) {
            NSLog(@"Before the timer");
            [self startMyTimer: node];
        }
    }
    
}


-(void) moveToTransporter: (CCSprite *) node{
    NSLog(@"%f,%f",node.position.x,node.position.y);
    int row = (int)(node.position.y/BLOCK_LENGTH);
    int col = (int)(node.position.x/BLOCK_LENGTH);
    if ([mazeArray[row][col] isEqualToString:@"door"]) {
        
        for(int r = 0; r < [mazeArray count]; r ++)
        {
            for (int c = 0; c < [[mazeArray objectAtIndex: r] count]; c++) {
                if ((r != row || c != col) && [mazeArray[r][c] isEqualToString: @"door"]) {
                    [NSThread sleepForTimeInterval:2.0f];
                    node.position = ccp(c*BLOCK_LENGTH, r*BLOCK_LENGTH);
                    
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
