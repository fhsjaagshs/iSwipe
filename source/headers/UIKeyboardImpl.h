@interface UIKeyboardImpl : UIView

+ (UIKeyboardImpl*)sharedInstance;
+ (UIKeyboardImpl*)activeInstance;

- (id)delegate;
- (void)handleDelete;
- (void)handleStringInput:(id)input fromVariantKey:(BOOL)variantKey;
- (BOOL)isShifted;
- (void)addInputString:(id)arg1;
- (id)layoutForKeyHitTest;
- (void)insertText:(id)arg1;

@end
