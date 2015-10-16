#import "macros.h"
#import "SBDisplayItem.h"

static void toggle_klct() {
    // Toggle the CommandTab according to the 'isVisible' property.
	if ([klct_commandTabController isVisible])
		[klct_commandTabController dismiss];
	else
		[klct_commandTabController _activateWithForwardDirection:YES];
}

@interface KLCTGestureDelegate : NSObject

+ (instancetype)sharedInstance;
- (void)handleIconViewPressed:(UITapGestureRecognizer *)gestureRecognizer;

@end

@implementation KLCTGestureDelegate

+ (instancetype)sharedInstance {
	static id __sharedInstance;
    
    // Create a thread safe singleton.
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		__sharedInstance = [[self alloc] init];
	});

	return __sharedInstance;
}

- (void)handleIconViewPressed:(UITapGestureRecognizer *)gestureRecognizer {
    // An app icon is pressed, so let's put some nice animation and open it.
	[UIView animateWithDuration:.6f delay:0.f usingSpringWithDamping:.3f initialSpringVelocity:.3f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        // Move the selection square to the pressed icon.
		UIImageView *selectionSquareView = [klct_commandTabViewController _selectionSquareView];
		selectionSquareView.center = gestureRecognizer.view.center;
	} completion:^(BOOL finish) {
        // Get the BundleID of the newly selected app
		SBDisplayItem *displayItem = klct_switcherDisplayItems[[klct_IconViews indexOfObject:gestureRecognizer.view]];
        
        // And launch it.
		[klct_commandTabController viewController:klct_commandTabController selectedApplicationWithBundleID:displayItem.displayIdentifier];
	}];
}

@end

%hook SBMainSwitcherViewController

// Hook the regular "double-press home button" app switcher activation method (leaves the 4-finger iPad gesture as-is).
- (BOOL)toggleSwitcherNoninteractively {
	toggle_klct();
	return YES;
}

%end

%hook SBCommandTabController

- (void)_activateWithForwardDirection:(BOOL)direction {
	%orig();

    // Select the first iconView when activating
	[klct_commandTabViewController _moveSelectionSquareToIconAtIndex:0];

    // Add our TapGestureRecognizer, so we actually open applications with the touch screen.
	for (UIView *view in klct_IconViews) {
		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:[KLCTGestureDelegate sharedInstance] action:@selector(handleIconViewPressed:)];
		[view setUserInteractionEnabled:YES];
		[view addGestureRecognizer:tapGestureRecognizer];
        
        // Don't leak..
		[tapGestureRecognizer release];
	}
}

%end