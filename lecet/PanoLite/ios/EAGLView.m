//
//  DMDViewerController.h
//
//  Created by AMS on 10/16/13.
//  Copyright (c) 2013 Dermandar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "EAGLView.h"

#define DMD_ARCENABLED() __has_feature(objc_arc)

@interface EAGLView (PrivateMethods)
- (void)createFramebuffer;
- (void)deleteFramebuffer;
@end

@implementation EAGLView

// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                        nil];
    }
    [self setMultipleTouchEnabled:YES];
    return self;
}
//800x1747
- (void)dealloc
{
    [self deleteFramebuffer];
#if !DMD_ARCENABLED()
	[super dealloc];
#endif
}

- (void)createFramebuffer
{
    if (!defaultFramebuffer) {
        // Create default framebuffer object.
        glGenFramebuffers(1, &defaultFramebuffer); glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        glGenRenderbuffers(1, &colorRenderbuffer); glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        [[EAGLContext currentContext] renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
        
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
            NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}

- (void)deleteFramebuffer
{
	if (defaultFramebuffer) {
		glDeleteFramebuffers(1, &defaultFramebuffer);
		defaultFramebuffer = 0;
	}
	
	if (colorRenderbuffer) {
		glDeleteRenderbuffers(1, &colorRenderbuffer);
		colorRenderbuffer = 0;
	}
}

- (void)setFramebuffer
{
	if (!defaultFramebuffer) [self createFramebuffer];
	glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
	glViewport(0, 0, framebufferWidth, framebufferHeight);
}

- (BOOL)presentFramebuffer
{
    BOOL success = FALSE;

	glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);

	success = [[EAGLContext currentContext] presentRenderbuffer:GL_RENDERBUFFER];
    
    return success;
}

- (void)layoutSubviews
{
    // The framebuffer will be re-created at the beginning of the next setFramebuffer method call.
    [self deleteFramebuffer];
}

@end
