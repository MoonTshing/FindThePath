//
//  Grid.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Grid.h"

static const int GRID_ROWS = 16;
static const int GRID_COLUMNS = 10;

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
    _cellWidth = self.contentSize.width/GRID_COLUMNS;
    _cellHeight = self.contentSize.height/GRID_ROWS;
   
    float x = 0;
    float y = 0;
    NSLog(@"setup grid");
    _gridArray = [NSMutableArray array];
    
    for(int i = 0; i < GRID_ROWS; i++)
    {
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for( int j = 0; j < GRID_COLUMNS; j++)
        {
            
            
            
            x += _cellWidth;
        }
        
        y +=_cellHeight;
    }
}

@end
