@class NSMutableDictionary, NSString, UIKBCacheToken, UIKBKeyView, UIKBRenderConfig, UIKBTree, UIView, UIKBSplitImageView;

@interface UIKBKeyplaneView : UIView

@property (readonly) BOOL cacheDeferable;
@property (readonly) NSString *cacheKey;
@property (retain) UIKBCacheToken *cacheToken;
@property (readonly) float cachedWidth;
@property (retain) UIKBTree *defaultKeyplane;
@property (readonly) BOOL keepNonPersistent;
@property (retain) UIKBTree *keyplane;
@property (retain) UIKBRenderConfig *renderConfig;

- (id)_setupSplitImageViewIfNeeded:(id)arg1 withImage:(id)arg2;
- (BOOL)_shouldDrawLowResBackground;
- (void)activateKeys;
- (void)addKeyToDelayedDeactivationSet:(id)arg1;
- (BOOL)cacheDeferable;
- (id)cacheIdentifierForKey:(id)arg1 withState:(int)arg2;
- (id)cacheIdentifierForKey:(id)arg1;
- (id)cacheKey;
- (id)cacheKeysForRenderFlags:(id)arg1;
- (UIKBCacheToken *)cacheToken;
- (float)cachedWidth;
- (void)cancelDelayedDeactivation;
- (Class)classForKey:(id)arg1;
- (id)containingViewForKey:(id)arg1 withState:(int)arg2;
- (int)cornerMaskForKey:(id)arg1 recursive:(BOOL)arg2;
- (void)deactivateAdaptiveKey:(id)arg1;
- (void)deactivateKey:(id)arg1 previousState:(int)arg2;
- (void)deactivateKeys;
- (void)dealloc;
- (UIKBTree *)defaultKeyplane;
- (void)dimKeyCaps:(float)arg1 duration:(float)arg2;
- (void)displayLayer:(id)arg1;
- (void)drawContentsOfRenderers:(id)arg1;
- (void)drawRect:(CGRect)arg1;
- (id)hitTest:(CGPoint)arg1 withEvent:(id)arg2;
- (id)initWithFrame:(CGRect)arg1 keyplane:(id)arg2;
- (BOOL)keepNonPersistent;
- (UIKBTree *)keyplane;
- (void)performDelayedDeactivation:(id)arg1;
- (void)purgeKeyViews;
- (void)purgeSubviews;
- (void)removeFromSuperview;
- (void)removeKeyFromDelayedDeactivationSet:(id)arg1;
- (id)renderConfig;
- (void)scheduleDelayedDeactivation;
- (void)setCacheToken:(UIKBCacheToken *)arg1;
- (void)setDefaultKeyplane:(UIKBTree *)arg1;
- (void)setKeyplane:(UIKBTree *)arg1;
- (void)setRenderConfig:(UIKBRenderConfig *)arg1;
- (void)setState:(int)arg1 forKey:(id)arg2;
- (int)stateForKey:(id)arg1;
- (void)updateDecorationViewsIfNeeded;
- (BOOL)validForKeyplane:(id)arg1 withVisualStyle:(int)arg2;
- (id)viewForKey:(id)arg1 state:(int)arg2;
- (id)viewForKey:(id)arg1;

@end