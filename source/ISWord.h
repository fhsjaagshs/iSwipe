//
//  ISWord.h
//  iSwipe
//
//  Created by Andrew Liu on 6/5/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISWord : NSObject/*{
    NSString *word;
    NSString *match;
    double weight;
}*/
@property(nonatomic, strong) NSString *word;
@property(nonatomic, strong) NSString *match;
@property(nonatomic, assign) double weight;

+ (ISWord *)word:(NSString *)word match:(NSString *)m weight:(double)wei;

@end
