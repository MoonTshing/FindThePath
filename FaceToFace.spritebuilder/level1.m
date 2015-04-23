//
//  level1.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "level1.h"
#import "Grid.h"
#import "DEMazeGenerator.h"

@implementation level1{
    NSUserDefaults *mazeDB;
}


-(void) createMazes {
    mazeDB = [NSUserDefaults standardUserDefaults];
    for (int levelIndex =1 ; levelIndex <= 100; levelIndex ++) {
        
        int GRID_ROWS;
        int GRID_COLUMNS;
        
        if (levelIndex <= 50) {
            
            GRID_ROWS = 8;
            GRID_COLUMNS = 5;
        }else{
            
            GRID_ROWS = 16;
            GRID_COLUMNS = 10;
        }
    
   
    
    DEMazeGenerator *maze = [[DEMazeGenerator alloc] initWithRow:GRID_ROWS andCol:GRID_COLUMNS withStartingPoint:DEIntegerPointMake(1, 1)];
    
    [maze arrayMaze:^(bool **item) {
         NSMutableArray *mazeArray = [[NSMutableArray alloc] init];
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
            
            NSLog(@"%@", inner);
            
        }
        
        NSString *level = [NSString stringWithFormat:@"level%dmaze",levelIndex];
        [mazeDB setObject:mazeArray forKey:level];
        [mazeDB synchronize];
    }
     ];
       
    }
    
}

@end
