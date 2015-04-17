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

static const int GRID_ROWS = 16;
static const int GRID_COLUMNS = 10;
static const int BLOCK_LENGTH = 12;
@implementation Grid {
    char _gridArray[GRID_ROWS*2+1][GRID_COLUMNS*2+1];
    float _cellWidth;
    float _cellHeight;
    CGPoint firstLocation;
    CGPoint lastLocation;

}


- (void) onEnter{
    [super onEnter];
     NSLog(@"onenter grid");
    [self setupGrid];
    [[CCDirector sharedDirector] view];
    
    self.userInteractionEnabled = YES;
}

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
                Block *block = [[Block alloc] initBlock];
                block.anchorPoint= ccp(0,0);
                block.position = ccp(x,y);
                if(item[r][c] == 1)
                {
                     [self addChild:block];
                }
                if(r==1 && c ==1)
                {
                    player *p = [[player alloc] initPlayer];
                    p.anchorPoint = ccp(0,0);
                    p.position = ccp(x,y);
                    [self addChild:p z:1];
                }
               
                
                [rowString appendFormat:@"%@ ", item[r][c] == 1 ? @"*" : @" "];
                x += _cellWidth;
           //      NSLog(@"%d", item[r][c]);
            }
           
            y += _cellHeight;
            NSLog(@"%@", rowString);
           
        }
        
       [self convertMazeToGrid: item];


    }
     ];
    
    
    NSLog(@"setup grid finished");
}

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
     NSLog(@"[%d][%d]%c",indexY,indexX,_gridArray[indexY][indexX]);
    if(_gridArray[indexY][indexX] == 'e'){
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
