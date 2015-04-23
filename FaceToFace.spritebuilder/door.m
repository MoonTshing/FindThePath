//
//  door.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "door.h"

@implementation door
-(instancetype) initDoor: (int) width{
    self = [super initWithImageNamed:@"door.png"];
    self.opacity = 0.6;
    [self resizeSprite: self toWidth: width toHeight:width];
    return self;
}

-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}
@end
