@interface SBCommandTabViewController : UIViewController

@property(retain, nonatomic) UIImageView *_selectionSquareView;

- (void)_moveSelectionSquareToIconAtIndex:(unsigned long long)index;

@end
