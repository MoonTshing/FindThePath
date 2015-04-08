//
//  GameScene.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "Grid.h"

@implementation GameScene{
    Grid *_grid;
    CCLabelTTF *_currentScore;
    CCLabelTTF *_highestScore;
}

-(id) init{
    self = [super init];
    
    if(self)
    {
        _currentScore = 0;
        // get the higest score from the userdefault data
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(defaults != nil){
             _highestScore = [defaults integerForKey:@/* Need a key */];
        }else{
            _highestScore = 0;
        }
    }
}


@end
