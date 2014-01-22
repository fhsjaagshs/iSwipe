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
    /*int begin = [(data.keys)[0] letter]-'a';
    int end = [(data.keys)[data.keys.count-1] letter]-'a';
    NSString *path = [NSString stringWithFormat:@"%@/%c%c.plist", DPATH,  begin+'a', end+'a'];
    NSArray *words = [[NSArray alloc] initWithContentsOfFile:path ];

    NSMutableArray *iswords = [[NSMutableArray alloc] initWithCapacity:words.count];
    for(int i = 0; i<words.count; i++){
        NSDictionary * tmp = words[i];
        [iswords addObject:[ISWord word:tmp[@"Word"] match:tmp[@"Match"] weight:0 count:[tmp[@"Count"] integerValue]]];
    }*/
    
    [self.db open];
    
    NSMutableArray *iswords = [NSMutableArray array];
    
    NSString *like = [NSString stringWithFormat:@"%c%%%c",[data.keys[0] letter],[data.keys[data.keys.count-1] letter]];
    FMResultSet *s = [self.db executeQuery:@"SELECT word,match FROM dict_en WHERE match LIKE ?",like];
    while ([s next]) {
        NSString *word = [s stringForColumn:@"word"];
        NSString *match = [s stringForColumn:@"match"];
        [iswords addObject:[ISWord word:word match:match weight:0]];
    }
    
    [self.db close];

    id<ISAlgoProtocol> algo = [[ISAlgoAngleDiffGreedy alloc] init];
    NSArray * arr = [algo findMatch:data dict:iswords];
    
    arr = [arr sortedArrayUsingSelector:@selector(compare:)];
    
    if( arr.count == 0) return arr;

    NSMutableArray * ret = [NSMutableArray array];
    double best = [arr[0] weight];
    for(ISWord *word in arr)
        if( word.weight > best*.5 )
            [ret addObject:word];
    
    return ret;
}

@end
