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
        
        mazeArray=[[NSUserDefaults standardUserDefaults] objectForKey:@"level1maze"];
        NSLog(@"%@", mazeArray);
    }else{
        
        DEMazeGenerator *maze = [[DEMazeGenerator alloc] initWithRow:GRID_ROWS andCol:GRID_COLUMNS withStartingPoint:DEIntegerPointMake(1, 1)];
        
        [maze arrayMaze:^(bool **item) {
            
            mazeArray = [[NSMutableArray alloc] init];
            for (int r = 0; r < GRID_ROWS*2+1; r++)
            {
                
                NSMutableArray *inner = [[NSMutableArray alloc] init];
                for (int c = 0; c < GRID_COLUMNS*2+1; c++)
                {
                    
                    
                    
                    if(item[r][c] == 1)
                    {
                        [inner addObject: [NSString stringWithFormat:@"b"]];
                    }else{
                        [inner addObject: [NSString stringWithFormat:@"e"]];
                    }
                }
                [mazeArray addObject: inner];
                
                
                
            }
            
            NSString *level = [NSString stringWithFormat:@"level%dmaze",1];
            [[NSUserDefaults standardUserDefaults] setObject:mazeArray forKey:level];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
         ];
        NSLog(@"%@", mazeArray);
    }
}

-(void) setupGrid{
   
    _cellWidth = self.contentSize.width/(GRID_COLUMNS*2+1);
    _cellHeight = self.contentSize.height/(GRID_ROWS*2+1);
    
    float x = 0;
    float y = 0;
    
    for(int row = 0; row < [mazeArray count]; row++){
        
        x = 0;
        
        for (int column = 0; column < [[mazeArray objectAtIndex: row] count]; column++) {
            NSMutableArray *tmp = [mazeArray objectAtIndex:row];
            
            if ([[tmp objectAtIndex:column]  isEqual: @"b"]) {
                printf("* ");
                Block *block = [[Block alloc] initBlock:24];
                block.anchorPoint= ccp(0,0);
                block.position = ccp(x,y);
                [self addChild:block];
            }else{
                printf("  ");
            }
            
            if(column == 1 && row == 1){
                player *p = [[player alloc] initPlayer:24];
                p.anchorPoint = ccp(0,0);
                p.position = ccp(x,y);
                [self addChild:p z:1];
            }
            
            if(row == GRID_ROWS*2-1 && column == GRID_COLUMNS*2-1)
            {
                destination *des = [[destination alloc] initDest: 24];
                des.anchorPoint = ccp(0,0);
                des.position = ccp(x,y);
                [self addChild:des];
            }
            x += _cellWidth;
            
        }
        printf("\n");
        y += _cellHeight;
    }
}

/*
- (void) setupGrid
{
    
    _cellWidth = self.contentSize.width/(GRID_COLUMNS*2+1);
    _cellHeight = self.contentSize.height/(GRID_ROWS*2+1);
    NSLog(@"setup grid");
    
    
    DEMazeGenerator *maze = [[DEMazeGenerator alloc] initWithRow:GRID_ROWS andCol:GRID_COLUMNS withStartingPoint:DEIntegerPointMake(1, 1)];
    
    [maze arrayMaze:^(bool **item) {
        
        float x = 0;
        float y = 0;
        
        NSMutableString *rowString = [NSMutableString string];
        
        for (int r = 0; r < GRID_ROWS*2+1; r++)
        {
            [rowString setString:[NSString stringWithFormat:@"%d: ", r]];
            x = 0;
            
            for (int c = 0; c < GRID_COLUMNS*2+1; c++)
            {
                Block *block = [[Block alloc] initBlock:24];
                block.anchorPoint= ccp(0,0);
                block.position = ccp(x,y);
                if(item[r][c] == 1)
                {
                    [self addChild:block];
                }
                if(r==1 && c ==1)
                {
                    player *p = [[player alloc] initPlayer:24];
                    p.anchorPoint = ccp(0,0);
                    p.position = ccp(x,y);
                    [self addChild:p z:1];
                }
                
                //   NSLog(@"r == %d and item == %d ",r, item[r][c]);
                if(r == GRID_ROWS*2-1 && c == GRID_COLUMNS*2-1)
                {
                    destination *des = [[destination alloc] initDest: 24];
                    des.anchorPoint = ccp(0,0);
                    des.position = ccp(x,y);
                    [self addChild:des];
                }
                if((r == GRID_ROWS*2-1 && c == GRID_COLUMNS*2-2) || (r == 2 && c == 1))
                {
                    door *Dor = [[door alloc] initDoor: 24];
                    Dor.anchorPoint = ccp(0,0);
                    Dor.position = ccp(x,y);
                    [self addChild:Dor];
                }
                
                if(r == GRID_ROWS*2-1 && c == 1)
                {
                    bad *b = [[bad alloc] initBad: 16 andHeight: 24];
                    b.anchorPoint = ccp(0,0);
                    b.position = ccp(x,y);
                    [self addChild:b];
                }
                [rowString appendFormat:@"%@ ", item[r][c] == 1 ? @"*" : @" "];
                x += _cellWidth;
                //      NSLog(@"%d", item[r][c]);
            }
            
            y += _cellHeight;
            //   NSLog(@"%@", rowString);
            
        }
        
        [self convertMazeToGrid: item];
        
        
    }
     ];
    
    
    NSLog(@"setup grid finished");
}*/


-(void) moveToTransporter{
    
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
    if([[[mazeArray objectAtIndex:indexY] objectAtIndex:indexX] isEqualToString:@"e"]){
        return true;
    }else return false;
}
-(void)screenWasSwipedUp
{
    
    for( CCNode* node in self.children){
        if (node.zOrder == 1) {
            CGPoint tmp = ccp(node.position.x, node.position.y + BLOCK_LENGTH);
            if ([self ableToMove:tmp]) {
                
                node.position = tmp;
            }
        }
    }
    
    
}

-(void)screenWasSwipedDown{
    for( CCNode* node in self.children){
        if (node.zOrder == 1) {
            CGPoint tmp = ccp(node.position.x, node.position.y - BLOCK_LENGTH);
            if ([self ableToMove:tmp]) {
                
                node.position = tmp;
            }
            
        }
    }
}
-(void)screenWasSwipedRight{
    for( CCNode* node in self.children){
        if (node.zOrder == 1) {
            
            CGPoint tmp = ccp(node.position.x+BLOCK_LENGTH, node.position.y);
            if ([self ableToMove:tmp]) {
                
                node.position = tmp;
            }
            
        }
    }
}
-(void)screenWasSwipedLeft{
    for( CCNode* node in self.children){
        if (node.zOrder == 1) {
            
            CGPoint tmp = ccp(node.position.x-BLOCK_LENGTH, node.position.y);
            if ([self ableToMove:tmp]) {
                
                node.position = tmp;
            }
            
        }
    }
}


@end
