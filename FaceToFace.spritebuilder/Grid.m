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

static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 5;

@implementation Grid {
    NSMutableArray *_gridArray;
    float _cellWidth;
    float _cellHeight;
}

- (void) onEnter{
    [super onEnter];
     NSLog(@"onenter grid");
    [self setupGrid];
    
    self.userInteractionEnabled = NO;
}

- (void) setupGrid
{

    _cellWidth = self.contentSize.width/(GRID_COLUMNS*2);
    _cellHeight = self.contentSize.height/(GRID_ROWS*2);
     NSLog(@"setup grid");
    _gridArray = [NSMutableArray array];
    
    
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
               
                
                [rowString appendFormat:@"%@ ", item[r][c] == 1 ? @"*" : @" "];
                x += _cellWidth;
            }
            y += _cellHeight;
            NSLog(@"%@", rowString);
        }
        
    }];
       NSLog(@"setup grid finished");
}

@end
