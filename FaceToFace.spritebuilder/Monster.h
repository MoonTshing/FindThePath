//
//  bad.h
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Direction.h"

@interface Monster : CCSprite

+ (Monster *)newMonsterWithWidth:(NSInteger)width andHeight:(NSInteger)height;

@property (nonatomic, assign) Direction direction;
@property (nonatomic, assign) CGSize monsterSize;

@end
