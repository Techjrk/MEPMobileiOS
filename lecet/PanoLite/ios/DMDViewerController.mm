//
//  DMDViewerController.mm
//
//  Created by AMS on 10/16/13.
//  Copyright (c) 2013 Dermandar. All rights reserved.
//

#import "DMDViewerController.h"

#import "EAGLView.h"
#import "CylindricalPanoramaViewer.h"
#import "SphericalPanoramaViewer.h"

#define DMD_ARCENABLED() __has_feature(objc_arc)

#define TITLE_FONT              fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define TITLE_COLOR_BLUE        RGB(5, 31, 73)
#define TITLE_COLOR_WHITE       RGB(255, 255, 7255)

#define DETAIL_FONT             fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define DETAIL_COLOR_BLUE        RGB(5, 31, 73)
#define DETAIL_COLOR_WHITE       RGB(255, 255, 7255)

CGFloat distanceBetweenPoints(float scaleFactor, CGPoint first, CGPoint second)
{
	CGFloat deltaX=second.x*scaleFactor-first.x*scaleFactor, deltaY=second.y*scaleFactor-first.y*scaleFactor;
    return sqrt((deltaX*deltaX)+(deltaY*deltaY));
}

#pragma mark -
#pragma mark DMDWebViewerController (Private)

class PanoramaViewer;

@interface DMDViewerController (){
    PanoramaViewer *viewer;
    UIButton *backButton;
    UIView *viewtextBackground;
    UITextView *textView;
}

- (void)clean;
- (void)drawFrame;

- (void)userDTapped:(UIGestureRecognizer*)gestureRecognizer;
- (void)setViewerDim;

@end

#pragma mark -
#pragma mark DMDWebViewerController implementation

@implementation DMDViewerController
@synthesize photoTitle;
@synthesize text;

#pragma mark -
#pragma mark OpenGL Default Context

+(EAGLContext*)defaultContext
{
    static EAGLContext *_context = nil;
    if (!_context) _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    return _context;
}

#pragma mark -
#pragma mark Controller Life Cycle

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[displayLink invalidate];
#if !DMD_ARCENABLED()
    [curTouches release];
#endif
    if(viewer)delete viewer,viewer=0;
#if !DMD_ARCENABLED()
    [super dealloc];
#endif
}

-(id)init
{
	if ((self=[super init]))
	{
		if (![EAGLContext setCurrentContext:[DMDViewerController defaultContext]])
            NSLog(@"Failed to set OpenGLES 2.0 context as a current context");
        viewer=0;
		animating=FALSE; displayLink=nil; blocked=false; aT=0;
    }
	return self;
}

#pragma mark -
#pragma mark Interface Orientation

- (BOOL)shouldAutorotate
{
	return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	UIDeviceOrientation ori = [UIDevice currentDevice].orientation;
	UIInterfaceOrientation intOri = UIDeviceOrientationIsPortrait(ori)?(UIInterfaceOrientation)ori:UIInterfaceOrientationPortrait;
	return intOri;
}

#pragma mark -
#pragma mark View Life Cycle

- (void)loadView
{
    self.view =
#if !DMD_ARCENABLED()
    [
#endif
     [[EAGLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]
#if !DMD_ARCENABLED()
     autorelease]
#endif
    ;
    
}

- (void)loadInfo {

    self.photoTitle = [DerivedNSManagedObject objectOrNil:self.photoTitle];
    if (self.photoTitle == nil) {
        self.photoTitle = @"";
    }
    
    self.text = [DerivedNSManagedObject objectOrNil:self.text];
    if (self.text == nil) {
        self.text = @"";
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight * 0.1)];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:view];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, view.frame.size.width * 0.2, view.frame.size.height);
    
    [view addSubview:backButton];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.hidden = YES;
    
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat height = kDeviceHeight * 0.25;
    viewtextBackground = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - height, kDeviceWidth, height)];
    viewtextBackground.backgroundColor = [UIColor redColor];
    [view addSubview:viewtextBackground];
    
    viewtextBackground.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    viewtextBackground.hidden = YES;
    
    CGFloat width = kDeviceWidth * 0.85;
    textView = [[UITextView alloc] initWithFrame:CGRectMake((kDeviceWidth - width)/2.0, 0, width, viewtextBackground.frame.size.height)];
    [viewtextBackground addSubview:textView];
    textView.backgroundColor = [UIColor clearColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:TITLE_FONT.pointSize * 0.6];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.photoTitle]  attributes:@{NSFontAttributeName: TITLE_FONT, NSForegroundColorAttributeName: TITLE_COLOR_BLUE, NSParagraphStyleAttributeName: paragraphStyle}];
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: DETAIL_FONT, NSForegroundColorAttributeName: DETAIL_COLOR_BLUE, NSParagraphStyleAttributeName: paragraphStyle}]];
    
    textView.attributedText = attributedString;

}

- (bool)isLandscape
{
    return self.view.frame.size.width>self.view.frame.size.height;
}

- (void)tappedButton:(id)object {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimation) name:UIApplicationWillResignActiveNotification object:nil];

    curTouches=[[NSMutableArray alloc] initWithCapacity:0];
    fov_scale=cdst=0; idst =-1.f; allowmove=false; ntouches=0;

	UITapGestureRecognizer *dTapGesture=
#if !DMD_ARCENABLED()
    [
#endif
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDTapped:)]
#if !DMD_ARCENABLED()
     autorelease]
#endif
    ;
	dTapGesture.delegate = self;
	dTapGesture.numberOfTapsRequired = 2;
	[self.view addGestureRecognizer:dTapGesture];
    
    UITapGestureRecognizer *tapGesture=
#if !DMD_ARCENABLED()
    [
#endif
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapped:)]
#if !DMD_ARCENABLED()
     autorelease]
#endif
    ;
    dTapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [self loadInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[UIApplication sharedApplication].statusBarHidden = YES;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   	[self startAnimation];
    [self setViewerDim];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self stopAnimation];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

#pragma mark -
#pragma mark Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    aT+=touches.count; if(blocked)return;
    if (ntouches+(NSInteger)touches.count>2){blocked=true; [curTouches removeAllObjects];ntouches=0;return;}
    unsigned int l=(unsigned int)ntouches; ntouches+=[touches count]; float sf=[self.view contentScaleFactor];
    for(unsigned int i=0;i<touches.count;i++){[curTouches insertObject:[[touches allObjects] objectAtIndex:i] atIndex:l+i];}
    if(ntouches == 2) {
        UITouch *first=[curTouches objectAtIndex:0], *second=[curTouches objectAtIndex:1];
        idst=distanceBetweenPoints(sf,[first locationInView: self.view], [second locationInView:self.view]);
        CGPoint lcn; lcn.x=self.view.bounds.size.width/2.; lcn.y=self.view.bounds.size.height/2.;
        allowmove=false;viewer->start(lcn.x*sf,lcn.y*sf);
    }
    else if (([[touches anyObject] tapCount] == 1) && (ntouches < 2)) {
        UITouch *touch=[touches anyObject]; CGPoint lcn=[touch locationInView:self.view]; allowmove = true;
        viewer->start(lcn.x*sf, lcn.y*sf);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (blocked||!ntouches)return; float sf=[self.view contentScaleFactor];
    if(ntouches==2) {
        UITouch *first=[curTouches objectAtIndex:0], *second=[curTouches objectAtIndex:1];
        if (idst==-1)idst=distanceBetweenPoints(sf,[first locationInView: self.view],[second locationInView:self.view]);
        cdst=distanceBetweenPoints(sf,[first locationInView: self.view],[second locationInView:self.view]);
        CGPoint lcn; lcn.x=self.view.bounds.size.width*sf/2.; lcn.y=self.view.bounds.size.height*sf/2.;
        double fmm=viewer->Fmax/viewer->Fmin;
        double d=cdst-idst, _w=self.view.bounds.size.width, _h=self.view.bounds.size.height; d=(d/((_w>_h)?_w:_h)*fmm)/sf;
        viewer->start(lcn.x,lcn.y); viewer->zoomsc(1.+d); idst=cdst; allowmove=false;
    }
    else if (([[touches anyObject] tapCount]==1)&&(ntouches==1)) {
        UITouch * touch = [touches anyObject]; CGPoint lcn = [touch locationInView:self.view];
        if (allowmove)viewer->move(lcn.x*sf,lcn.y*sf);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    aT-=touches.count; float sf=[self.view contentScaleFactor];
    for (unsigned int i=0;i<touches.count;i++)[curTouches removeObject:[[touches allObjects] objectAtIndex:i]];
    if (ntouches>0)ntouches-=[touches count]; if(ntouches<0)ntouches=0; idst=cdst;
    blocked=(!!aT&&blocked); if (blocked)return;
    if(ntouches==1) {
        allowmove=true;
        UITouch *touch=[curTouches objectAtIndex:0]; CGPoint lcn=[touch locationInView:self.view];
        viewer->start(lcn.x*sf, lcn.y*sf);
    }
    if(!ntouches) { viewer->end(); allowmove=true; }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)userTapped:(UIGestureRecognizer*)gestureRecognizer
{
    CGPoint tapPoint = [(UITapGestureRecognizer*)gestureRecognizer locationInView:self.view];
    double imgX=0, imgY=0;
    viewer->getImageXandY(tapPoint.x*self.view.contentScaleFactor, tapPoint.y*self.view.contentScaleFactor,imgX,imgY);
    printf("%fpx, %fpx\n",imgX*w, imgY*h);
    
    UIView *view = gestureRecognizer.view;
    CGPoint point = [gestureRecognizer locationInView:view];
    UIView* subview = [view hitTest:point withEvent:nil];
    
    if ([subview isEqual:self.view]) {
        backButton.alpha = backButton.hidden?0:1;
        backButton.hidden = !backButton.hidden;
        
        viewtextBackground.alpha = backButton.alpha;
        viewtextBackground.hidden = backButton.hidden;
        
        if (textView.attributedText.length == 1) {
            viewtextBackground.hidden = YES;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            
            backButton.alpha = backButton.hidden?0:1;
            viewtextBackground.alpha = backButton.alpha;

            if (textView.attributedText.length == 1) {
                viewtextBackground.hidden = YES;
            }
          
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
    }

}

- (void)userDTapped:(UIGestureRecognizer*)gestureRecognizer
{
    CGPoint tapPoint = [(UITapGestureRecognizer*)gestureRecognizer locationInView:self.view];
    viewer->zoom(tapPoint.x*self.view.contentScaleFactor, tapPoint.y*self.view.contentScaleFactor);
    
}

#pragma mark -
#pragma mark Private Functions

- (void)clean
{
    aT=0; blocked=0; [curTouches removeAllObjects]; ntouches=0;
}

- (void)drawFrame
{
    [(EAGLView*)self.view setFramebuffer];
    viewer->draw();
    [(EAGLView*)self.view presentFramebuffer];
}

- (void)setViewerDim
{
    CGFloat sf=self.view.contentScaleFactor;
    if(viewer)viewer->setDim(sf*CGRectGetWidth(self.view.bounds),sf*CGRectGetHeight(self.view.bounds));
}

#pragma mark -
#pragma mark Public Interface

- (void)startAnimation
{
	[self clean];
    if (!animating) {
        CADisplayLink *aDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame)];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[displayLink invalidate]; displayLink=aDisplayLink; animating=TRUE;
    }
}

- (void)stopAnimation
{
	[self clean]; if (animating) { [displayLink invalidate]; displayLink=nil; animating=FALSE; } glFlush(); glFinish();
}

//release should be done by the caller
- (unsigned char*)getBytes:(UIImage*)src
{
    CGColorSpaceRef type = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef imgRef = [src CGImage];
    
    double rot=0;
    w=(int)CGImageGetWidth([src CGImage])*sc; h=(int)CGImageGetHeight([src CGImage])*sc;
    int ow=(int)CGImageGetWidth([src CGImage]), oh=(int)CGImageGetHeight([src CGImage]);
    int ori=src.imageOrientation;
    
    CGContextRef ctx=nil;
    unsigned char *bytes = 0;
    
    switch (ori) {
        case UIImageOrientationDown:
            //not supported
            break;
        case UIImageOrientationDownMirrored:
            //not supported
            break;
        case UIImageOrientationLeft:
            //not supported
            break;
        case UIImageOrientationLeftMirrored:
            //not supported
            break;
        case UIImageOrientationRight:
            w=(int)CGImageGetHeight([src CGImage])*sc; h=(int)CGImageGetWidth([src CGImage])*sc; rot=-M_PI/2.0;
            bytes = new unsigned char[4*w*h];
            ctx=CGBitmapContextCreate(bytes,w,h,8,w*4,type,kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
            CGContextRotateCTM(ctx,rot);
            CGContextTranslateCTM(ctx,-h,0);
            CGContextScaleCTM(ctx,sc,sc);
            CGContextDrawImage(ctx,CGRectMake(0,0,ow,oh),imgRef);
            break;
        case UIImageOrientationRightMirrored:
            //not supported
            break;
        case UIImageOrientationUp:
            bytes = new unsigned char[4*w*h];
            ctx=CGBitmapContextCreate(bytes,w,h,8,w*4,type,kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
            CGContextScaleCTM(ctx,sc,sc);
            CGContextDrawImage(ctx,CGRectMake(0,0,ow,oh),imgRef);
            break;
        case UIImageOrientationUpMirrored:
            //not supported
            break;
        default:
            break;
    }
    
    CGContextRelease(ctx); CGColorSpaceRelease(type);
    
    return bytes;
}

- (bool)loadPanoramaFromUIImage:(UIImage*)image
{
    return [self loadPanoramaFromUIImage:image fovx:0];
}

- (bool)loadPanoramaFromUIImage:(UIImage*)image fovx:(int)fx
{
    if(viewer)delete viewer,viewer=0;
    glGetIntegerv(GL_MAX_TEXTURE_SIZE,&mts);
    
    double mi=256;
    int _w=(int)CGImageGetWidth([image CGImage]), _h=(int)CGImageGetHeight([image CGImage]);
    int size=_w*_h*4*2; sc=1.0; int i=mi; int limit=
#if defined(TARGET_IPHONE_SIMULATOR) && (TARGET_IPHONE_SIMULATOR==1)
    1024*1024*1024  // 1GB
#else
    (unsigned int)([NSProcessInfo processInfo].physicalMemory)
#endif
    *0.4;
    int ori=image.imageOrientation; int wlim=350;
    if((size>limit)||((ori==3?_h:_w)>mts)||((ori==3?_w:_h)>wlim)) {
        while(((size*(--i/mi)>limit)||((ori==3?_h:_w)*(i/mi)>mts)||((ori==3?_w:_h)*(i/mi)>wlim))&&i);
        sc=i/mi;
        if(i==0) { sc=0.0; NSLog(@"Too large pano."); }
    }
    
    if(sc) {
        unsigned char* bytes=[self getBytes:image]; // bytes returned by this function should be released after using it.
#if !DMD_ARCENABLED()
        [image release];
#endif
        image=nil;
        viewer=new CylindricalPanoramaViewer(bytes,w,h,4,fx);
        if(bytes)delete[]bytes,bytes=0;
        return true;
    }

#if !DMD_ARCENABLED()
    [image release];
#endif
    
    image=nil;
    
    return false;
}

- (bool)loadSphericalPanoramaFromUIImage:(UIImage*)image
{
    if(viewer)delete viewer,viewer=0;
    glGetIntegerv(GL_MAX_TEXTURE_SIZE,&mts);
    
    double mi=256;
    int _w=(int)CGImageGetWidth([image CGImage]), _h=(int)CGImageGetHeight([image CGImage]);
    int size=_w*_h*4*2; sc=1.0; int i=mi; int limit=
#if defined(TARGET_IPHONE_SIMULATOR) && (TARGET_IPHONE_SIMULATOR==1)
    1024*1024*1024  // 1GB
#else
    (unsigned int)([NSProcessInfo processInfo].physicalMemory)
#endif
    *0.4;
    int ori=image.imageOrientation; int wlim=350;
    if((size>limit)||((ori==3?_h:_w)>mts)||((ori==3?_w:_h)>wlim)) {
        while(((size*(--i/mi)>limit)||((ori==3?_h:_w)*(i/mi)>mts)||((ori==3?_w:_h)*(i/mi)>wlim))&&i);
        sc=i/mi;
        if(i==0) { sc=0.0; NSLog(@"Too large pano."); }
    }
    
    if(sc) {
        unsigned char* bytes=[self getBytes:image]; // bytes returned by this function should be released after using it.
#if !DMD_ARCENABLED()
        [image release];
#endif
        image=nil;
        viewer=new SphericalPanoramaViewer(bytes,w,h,4);
        if(bytes)delete[]bytes,bytes=0;
        return true;
    }
    
#if !DMD_ARCENABLED()
    [image release];
#endif
    
    image=nil;
    
    return false;
}

@end
