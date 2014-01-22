#import "ISModel.h"
#import "fmdb/FMDatabase.h"

@interface ISModel ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation ISModel

+ (ISModel *)sharedInstance {
    static ISModel *shared = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared = [[ISModel alloc]init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.db = [FMDatabase databaseWithPath:@"/usr/share/iSwipe/dictionaries.db"];
        
    }
    return self;
}

- (NSArray *)findMatch:(ISData *)data{
    NSMutableArray *iswords = [NSMutableArray array];
    
    int first = [(data.keys)[0] letter];
    int last = [(data.keys)[data.keys.count-1] letter];
    
    NSString *like = [NSString stringWithFormat:@"%c%%%c",first,last];
    
    [self.db open];

    FMResultSet *s = [self.db executeQuery:@"SELECT word,match FROM dict_en WHERE match LIKE ?",like];
    while ([s next]) {
        NSString *word = [s stringForColumn:@"word"];
        NSString *match = [s stringForColumn:@"match"];
        [iswords addObject:[ISWord word:word match:match weight:0]];
    }
	
	[s close];
    
    [self.db close];

	NSMutableArray *arr = [ISAlgoAngleDiffGreedy findMatch:data dict:iswords];
	[arr sortUsingSelector:@selector(compare:)];
	
    if (arr.count == 0) return arr;

    NSMutableArray * ret = [NSMutableArray array];
    double best = [arr[0] weight];
    for (ISWord *word in arr) {
        if (word.weight > best*.5) {
            [ret addObject:word];
		}
    }
	
    return ret;
}

@end
