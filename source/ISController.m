#import "ISController.h"
#import "headers/UIKBKeyplaneView.h"
#import "headers/UIKeyboardLayoutStar.h"
#import "headers/UIKBTree.h"

@interface ISController () <ISSuggestionsViewDelegate>

@property (nonatomic, strong) NSString *initialKey;
@property (nonatomic, strong) UITouch *startingTouch;

@end

@implementation ISController

+ (ISController *)sharedInstance {
  static ISController *shared = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    shared = [[ISController alloc]init];
  });
	return shared;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.suggestionsView = [[ISSuggestionsView alloc]init];
    _suggestionsView.delegate = self;
    self.scribbleView = [[ISScribbleView alloc]init];
  }
  return self;
}

- (void)forwardMethod:(id)sender sel:(SEL)cmd touches:(NSSet *)touches event:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint point = [touch locationInView:touch.view];
  
	UIKBTree *tree = [sender keyHitTest:point];
  NSString *key = tree.displayString.lowercaseString;

  if (cmd == @selector(touchesBegan:withEvent:)) {
		if (key.length == 1) {
	    self.initialKey = key;
	    self.swipe = [[ISData alloc]init];
	    [self.suggestionsView hideAnimated:YES];
	    self.startingTouch = touch;
		}
  } else if (cmd == @selector(touchesMoved:withEvent:)) {
    if (_initialKey && ![_initialKey isEqualToString:key]) {
      self.initialKey = nil;
      [_scribbleView show];
      self.startingTouch = nil;
    } else {
      if (key.length == 1) {
        [_swipe addPoint:point forKeyTree:tree];
        //[_swipe addData:point forKey:key];
      }
		}
		[_scribbleView drawToTouch:touch];
	} else if (cmd == @selector(touchesEnded:withEvent:)) {
		self.initialKey = nil;
    [_swipe end];

    if (_swipe.keys.count >= 2) {
      NSArray *matches = [_swipe findMatches];
			
      if (matches.count > 0) {
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
          [self deleteChar];
        }
        
        [self addInput:[matches.firstObject word]];
				
        if (matches.count > 1) {
					_suggestionsView.suggestions = matches;
					[_suggestionsView showAnimated:YES];
        }
      } else {
        [self deleteChar];
      }
    }
    [self resetSwipe];
  }
}

- (void)resetSwipe {
	self.swipe = [[ISData alloc]init];
	[_scribbleView hide];
	[_scribbleView resetPoints];
}

- (BOOL)isSwyping {
  return _swipe.keys.count > 0;
}

- (void)deleteChar {
  [[UIKeyboardImpl activeInstance]handleDelete];
}

- (void)deleteLast {
  for (int i = 0; i < matchLength; i++) {
    [self deleteChar];
  }   
}

- (void)suggestionsView:(ISSuggestionsView *)suggestionsView didSelectSuggestion:(NSString *)suggestion {
  [self deleteLast];
  [self deleteChar];
  // - (void)replaceText:(id)arg1;
  [self addInput:suggestion];
  [_suggestionsView hideAnimated:YES];
}

- (void)addInput:(NSString *)input {
  UIKeyboardImpl *kb = [UIKeyboardImpl activeInstance];
    
  matchLength = input.length;
  if ([kb isShifted]) {
    char c = [input characterAtIndex:0];
    if (c <= 'z' && c >= 'a') {
      [self kbinput:[NSString stringWithFormat:@"%c",c-'a'+'A']];
      if (input.length > 1) {
        [self kbinput:[input substringFromIndex:1]];
      }
    } else {
      [self kbinput:input];
    }
  } else {
    [self kbinput:input];
  }
	
  [self kbinput:@" "];
}
    
- (void)kbinput:(NSString *)input {
  UIKeyboardImpl *kb = [UIKeyboardImpl activeInstance];
	/*if ([kb respondsToSelector:@selector(insertText:)] && ![input isEqualToString:@" "]) {
		[kb insertText:input];
	} else*/ if ([kb respondsToSelector:@selector(addInputString:)]) {
    [kb addInputString:input];
  }
}

@end