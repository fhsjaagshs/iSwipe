//
//  ISAlgoAngleDiffDP.m
//  iSwipe
//
//  Created by Andrew Liu on 6/11/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import "ISAlgoAngleDiffDP.h"
#import "ISDefines.h"

@implementation ISAlgoAngleDiffDP

static double getValue(ISData *data, ISWord* iword, double** mat){
    NSArray *keys = data.keys;
    NSString *word = iword.word;
    
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

+ (NSArray *)findMatch:(ISData *)data fromWords:(NSArray *)words {
    NSMutableArray *matches = [NSMutableArray array];

    int max = 0;
    for (ISWord *word in words) {
        max = MAX(max, word.match.length);
    }
    max++;
    
    double** mat = new double*[max];
    
    for (int i = 0; i < max; i++) {
        mat[i] = new double[data.keys.count+1];
    }
    
    for (ISWord *word in words) {
        double val = getValue(data, word, mat);
        word.weight = val;
        if (val != BAD) [matches addObject:word];
    }
    
    for (int i = 0; i < max; i++) {
        delete[] mat[i];
    }
    delete[] mat;
    
    return [matches sortedArrayUsingSelector:@selector(:compare)];
}

@end