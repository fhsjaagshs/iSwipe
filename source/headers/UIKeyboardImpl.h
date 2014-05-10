@interface UIKeyboardImpl : UIView

+ (UIKeyboardImpl*)sharedInstance;
+ (UIKeyboardImpl*)activeInstance;

- (id)delegate;
- (void)handleDelete;
- (BOOL)isShifted;
- (void)addInputString:(id)arg1;
- (id)layoutForKeyHitTest;
- (void)insertText:(id)arg1;
- (void)setChanged;

@end
