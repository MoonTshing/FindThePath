//
//  LevelChosen.h
//  FaceToFace
//
//  Created by Chanjuan Tshing on 3/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@protocol LevelChooseDelegate <NSObject>

- (void)onLevelChosen:(NSUInteger)level;

@end

@interface LevelChosen : CCScene
@property (nonatomic, assign) int level;
@property (nonatomic, weak) id<LevelChooseDelegate> delegate;

@end
