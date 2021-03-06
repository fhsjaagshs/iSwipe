#import <UIKit/UIKit.h>
#import "headers/UIKeyboardLayoutStar.h"
#import "headers/UIKeyboardImpl.h"
#import "headers/UIKeyboard.h"
#import "headers/UIKBTree.h"
#import "headers/UIKBKeyView.h"
#import "ISScribbleView.h"
#import "ISSuggestionsView.h"
#import "ISData.h"

@class ISSuggestionsView;
@interface ISController : NSObject

@property (nonatomic, strong) ISSuggestionsView *suggestionsView;
@property (nonatomic, strong) ISScribbleView *scribbleView;
@property (nonatomic, strong) ISData *swipe;
@property (nonatomic, readonly) BOOL isSwyping;

+ (ISController *)sharedInstance;

- (void)forwardMethod:(id)sender sel:(SEL)cmd touches:(NSSet *)touches event:(UIEvent *) event;

- (void)addInput:(NSString *)input;
- (void)kbinput:(NSString *)input;

- (void)deleteChar;
- (void)deleteLast;

@end