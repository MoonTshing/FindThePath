//
//  Block.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Block.h"

@implementation Block

-(instancetype) initBlock: (int) width{
    self = [super initWithImageNamed:@"Assets/block.png"];
    self.opacity = 0.8;
    [self resizeSprite: self toWidth:width toHeight:width];
    return self;
}
-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}
@end
