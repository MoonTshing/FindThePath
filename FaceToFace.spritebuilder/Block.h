//
//  Block.h
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Block : CCSprite

-(id) initBlock:(int) width;
-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height;
@end
