#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DPView : UIView
@property(nonatomic, strong) UILabel *face;
@property(nonatomic, strong) UILabel *bubble;
@property(nonatomic, strong) NSTimer *idleTimer;
@property(nonatomic, assign) CGPoint dragStart;
@property(nonatomic, assign) CGPoint originCenter;
@end

@implementation DPView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.98 green:0.78 blue:0.22 alpha:1.0];
        self.layer.cornerRadius = 34.0;
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.15].CGColor;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.24;
        self.layer.shadowRadius = 6.0;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.userInteractionEnabled = YES;

        _face = [[UILabel alloc] initWithFrame:self.bounds];
        _face.text = @"•ᴗ•";
        _face.font = [UIFont boldSystemFontOfSize:20.0];
        _face.textAlignment = NSTextAlignmentCenter;
        _face.textColor = [UIColor colorWithWhite:0.12 alpha:1.0];
        _face.userInteractionEnabled = NO;
        [self addSubview:_face];

        _bubble = [[UILabel alloc] initWithFrame:CGRectMake(-36, -38, 110, 30)];
        _bubble.text = @"嗨，我在这儿";
        _bubble.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
        _bubble.textAlignment = NSTextAlignmentCenter;
        _bubble.textColor = [UIColor colorWithWhite:0.15 alpha:1.0];
        _bubble.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.92];
        _bubble.layer.cornerRadius = 12.0;
        _bubble.layer.masksToBounds = YES;
        _bubble.alpha = 0.0;
        [self addSubview:_bubble];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dp_tap:)];
        tap.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tap];
        [self dp_scheduleIdle];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.face.frame = self.bounds;
}

- (void)dp_tap:(UITapGestureRecognizer *)tap {
    NSArray *faces = @[@"•ᴗ•", @"^ᴗ^", @"ಠᴗಠ", @"ᵔᴥᵔ"];
    self.face.text = faces[arc4random_uniform((uint32_t)faces.count)];
    self.bubble.text = @"点到我啦";
    [UIView animateWithDuration:0.12 animations:^{
        self.transform = CGAffineTransformMakeScale(1.15, 1.15);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.18 animations:^{ self.transform = CGAffineTransformIdentity; }];
    }];
    [self dp_showBubble];
}

- (void)dp_showBubble {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dp_hideBubble) object:nil];
    [UIView animateWithDuration:0.18 animations:^{ self.bubble.alpha = 1.0; }];
    [self performSelector:@selector(dp_hideBubble) withObject:nil afterDelay:2.0];
}

- (void)dp_hideBubble {
    [UIView animateWithDuration:0.25 animations:^{ self.bubble.alpha = 0.0; }];
}

- (void)dp_scheduleIdle {
    [self.idleTimer invalidate];
    self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:18.0 target:self selector:@selector(dp_idle) userInfo:nil repeats:YES];
}

- (void)dp_idle {
    self.face.text = @"-ᴗ-";
    [UIView animateWithDuration:0.6 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -7);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 animations:^{ self.transform = CGAffineTransformIdentity; } completion:^(BOOL finished2) {
            self.face.text = @"•ᴗ•";
        }];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.dragStart = [touch locationInView:self.superview];
    self.originCenter = self.center;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint now = [touch locationInView:self.superview];
    CGFloat dx = now.x - self.dragStart.x;
    CGFloat dy = now.y - self.dragStart.y;
    self.center = CGPointMake(self.originCenter.x + dx, self.originCenter.y + dy);
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UIView *host = self.superview;
    if (host) {
        CGFloat top = 54.0 + self.bounds.size.height / 2.0;
        CGFloat bottom = host.bounds.size.height - 24.0 - self.bounds.size.height / 2.0;
        CGFloat x = MIN(MAX(self.center.x, self.bounds.size.width / 2.0), host.bounds.size.width - self.bounds.size.width / 2.0);
        CGFloat y = MIN(MAX(self.center.y, top), bottom);
        [UIView animateWithDuration:0.25 animations:^{ self.center = CGPointMake(x, y); }];
    }
    [super touchesEnded:touches withEvent:event];
}
@end

%hook SBIconController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static BOOL installed = NO;
    if (installed) return;
    installed = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *host = self.view.window ?: self.view;
        if (!host) return;
        DPView *pet = [[DPView alloc] initWithFrame:CGRectMake(host.bounds.size.width - 86.0, 160.0, 68.0, 68.0)];
        pet.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        pet.tag = 280814;
        [host addSubview:pet];
    });
}

%end
