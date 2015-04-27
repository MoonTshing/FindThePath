//
//  bgSound.h
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface bgSound : AVPlayer
-(void) playSoundwithName: (NSString *)fileName;
@end
