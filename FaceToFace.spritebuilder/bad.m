//
//  bad.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "bad.h"

@implementation bad
-(instancetype) initBad: (int) width andHeight: (int) height{
    self = [super initWithImageNamed:@"badGreen.png"];
    [self resizeSprite: self toWidth:width toHeight:height];
    return self;
}
-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}
-(void) moveMonster {
    //get monster's position
    int a = self.position.x;
    // get the index of array
    // check if it is movable in certain position and generate random place to move
}

@end
