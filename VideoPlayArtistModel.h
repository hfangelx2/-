//
//  VideoPlayArtistModel.h
//  CCMV
//
//  Created by zd on 15/4/22.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoPlayArtistModel : NSObject

@property(nonatomic,strong)NSNumber *artistId;
@property(nonatomic,strong)NSString *artistName;
@property(nonatomic,strong)NSString *artistAvatar;

- (instancetype)initWithDictionary:(NSDictionary *)dic;



@end
