//
//  player.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Player.h"
#import "Block.h"

@implementation Player

-(instancetype) initPlayer:(int) width{
    self = [super initWithImageNamed:@"Assets/player.png"];
    [self resizeSprite: self toWidth:width toHeight:width];
    return self;
}

-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}


@end
