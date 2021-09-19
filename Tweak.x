@import UIKit;

@interface WAMediaBrowserViewController : UIViewController
- (void)safeOnceImage ;
- (void)alertWithMessage:(NSString *)message ;
@end

%hook WAMediaBrowserViewController
- (void)viewDidAppear:(BOOL)animated {
	%orig;
	if (![self valueForKey:@"_viewOnceButton"])
		return;

	UIBarButtonItem *safeImage = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(safeOnceImage)];
	NSMutableArray *items = ([[self valueForKey:@"_toolbar"] items]) ? [[[self valueForKey:@"_toolbar"] items] mutableCopy] : [NSMutableArray new];
	[items addObject:safeImage];
	[[self valueForKey:@"_toolbar"] setItems:items];
}
%new
- (void)safeOnceImage {
	UIView *imageCell = [self valueForKey:@"_lastFullyVisibleCell"];
	UIImageView *imageView = [imageCell valueForKey:@"_imageView"];
	UIImage *img = [imageView image];

	UIImageWriteToSavedPhotosAlbum(img, self, nil, NULL);
}
%end