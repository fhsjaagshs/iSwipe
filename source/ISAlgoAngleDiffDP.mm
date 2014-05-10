//
//  ISAlgoAngleDiffDP.m
//  iSwipe
//
//  Created by Andrew Liu on 6/11/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import "ISAlgoAngleDiffDP.h"
#import "ISDefines.h"
#import "ISKey.h"
#import "ISWord.h"

@implementation ISAlgoAngleDiffDP

static double calcWeight(NSArray *keys, NSString *word, double** mat){
    for (int i = 0; i <= word.length; i++) {
        mat[i][0] = BAD;
    }
    
    for (int j = 0; j <= keys.count; j++) {
        mat[0][j] = BAD;
    }
    mat[0][0] = BASE;
    
    for (int i = 1; i <= word.length; i++) {
        for (int j = 1; j <= keys.count; j++) {
            mat[i][j] = BAD;
            if ([word characterAtIndex:i-1] == [keys[j-1] letter] && (mat[i-1][j-1] != -1 || mat[i-1][j] != BAD)) { //matches
                    ISKey *kk = keys[j-1];
                    mat[i][j] = MAX(mat[i-1][j-1] + kk.angle , mat[i-1][j] + BONUS);
                }
            if (mat[i][j-1] != BAD) {
                mat[i][j] = MAX(mat[i][j], mat[i][j-1]);
            }
        }
    }
    
    return mat[word.length][keys.count];
}

+ (NSArray *)findMatch:(NSArray *)keys fromWords:(NSArray *)words {
    NSMutableArray *matches = [NSMutableArray array];

    int max = 0;
    for (ISWord *word in words) {
        max = MAX(max, word.match.length); // real WTF moment here
    }
    max++;
    
    double** mat = new double*[max];
    
    for (int i = 0; i < max; i++) {
        mat[i] = new double[keys.count+1];
    }
    
    for (ISWord *isword in words) {
        double val = calcWeight(keys, isword.word, mat);
        isword.weight = val;
        if (val != BAD) [matches addObject:isword];
    }
    
    for (int i = 0; i < max; i++) {
        delete[] mat[i];
    }
    delete[] mat;
    
    return [matches sortedArrayUsingSelector:@selector(compare:)];
}

@end