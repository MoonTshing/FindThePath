//
//  bad.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Monster.h"

@implementation Monster

+ (Monster *)newMonsterWithWidth:(NSInteger)width andHeight:(NSInteger)height {
    Monster *monster = [[Monster alloc] initWithImageNamed:@"badGreen.png"];
    monster.monsterSize = CGSizeMake(width, height);
    return monster;
}

- (void)onEnter {
    [self resizeToWidth:self.monsterSize.width toHeight:self.monsterSize.height];
    [super onEnter];
}

-(void)resizeToWidth:(float)width toHeight:(float)height {
    self.scaleX = width / self.contentSize.width;
    self.scaleY = height / self.contentSize.height;
}

-(void) moveMonster {
    //get monster's position
    // get the index of array
    // check if it is movable in certain position and generate random place to move
}

@end
