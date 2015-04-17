//
//  Block.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Block.h"

@implementation Block

-(instancetype) initBlock{
    self = [super initWithImageNamed:@"block.png"];
    [self resizeSprite: self toWidth:12 toHeight:12];
    return self;
}
-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}
@end
