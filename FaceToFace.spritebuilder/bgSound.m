//
//  bgSound.m
//  FaceToFace
//
//  Created by Chanjuan Tshing on 4/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "bgSound.h"

@implementation bgSound{
    AVPlayer *player;
}

-(void) playSoundwithName: (NSString *)fileName RunNumberOfLoop: (int) numOfLoop{
    NSLog(@"enters the play sound func");

    
    player = [[AVPlayer alloc] init];
     NSString *soundPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
    NSURL *url=[NSURL URLWithString:soundPath];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    [player play];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    NSLog(@"leaves the play sound func");

}

@end