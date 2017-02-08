
#import "AlertMenu.h"

@implementation AlertMenu

-(id)init
{
    CGRect screen = [[[UIApplication sharedApplication] keyWindow] frame];
    
    CGRect frame = CGRectMake(0, 0, screen.size.width, screen.size.height);
    self = [super initWithFrame:frame];
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5]];
    [[label layer]setCornerRadius:5];
    [label setClipsToBounds:YES];
    
    [self addSubview:label];
    
    self.alpha = 0;
    
    return self;
}

- (void)show: (NSString *)text
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.alpha = 1;
    }];
    
    UILabel *label = [[self subviews] objectAtIndex:0];
    
    [label setText:text];
    
    // First setText, tgeb sizeToFit to determine size, and finally set x & y
    [label sizeToFit];
    
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake( [self frame].size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect size2 = [text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12] }
                                         context:nil];
    
    CGFloat padding = 10;
    
    CGFloat w = self.frame.size.width / 2 + 2 * padding;
    CGFloat h = size2.size.height + 2 * padding;
    
    CGFloat x = [self frame].size.width / 2 - (w / 2 + padding);
    // 50px from bottom of screen
    CGFloat y = [self frame].size.height - (h + 50 + padding);
    
    [label setFrame:CGRectMake(x, y, w, h)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.alpha = 0;
    }
    completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^(void) {
            [self removeFromSuperview];
        }];
    }];
}

@end

