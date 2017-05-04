//
//  DMDViewerController.h
//
//  Created by AMS on 10/16/13.
//  Copyright (c) 2013 Dermandar. All rights reserved.
//

#include "PanoramaViewer.h"

#ifndef __CylindricalPanoramaViewer__
#define __CylindricalPanoramaViewer__

class CylindricalPanoramaViewer : public PanoramaViewer
{
public:
    // in this version bpp is not used and should be 4 always
	CylindricalPanoramaViewer(unsigned char* bytes, int w, int h, int bpp, double horizontalAngleDegree = 360.0);
    // in this version bpp is not used and should be 4 always
    virtual void initialize(unsigned char* bytes, int w, int h, int bpp, double horizontalAngleDegree = 360.0);
    virtual void reset();
	virtual ~CylindricalPanoramaViewer();
};

#endif
