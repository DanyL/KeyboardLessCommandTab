#import <UIKit/UIKit.h>
#import <substrate.h>

#import "SBCommandTabController.h"
#import "SBCommandTabViewController.h"

#define klct_commandTabController ([%c(SBCommandTabController) sharedInstance])
#define klct_commandTabViewController (MSHookIvar<SBCommandTabViewController *>(klct_commandTabController, "_commandTabViewController"))
#define klct_switcherDisplayItems (MSHookIvar<NSMutableArray *>(klct_commandTabViewController, "_switcherDisplayItems"))
#define klct_IconViews (MSHookIvar<NSMutableArray *>(klct_commandTabViewController, "_iconViews"))
