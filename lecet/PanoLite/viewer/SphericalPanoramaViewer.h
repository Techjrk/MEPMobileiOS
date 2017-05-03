//
//  SphericalPanoramaViewer.h
//  SphericalPanoramaViewer
//
//  Created by AMS on 3/12/14.
//  Copyright (c) 2014 Dermandar. All rights reserved.
//
#include "PanoramaViewer.h"

#ifndef SPHERICALPANORAMAVIEWER_H
#define SPHERICALPANORAMAVIEWER_H

class SphericalPanoramaViewer : public PanoramaViewer
{
private:
    double *angles;
    
public:
    // in this version bpp is not used and should be 4 always
    // horizontalAngleDegree also should be always 360
	SphericalPanoramaViewer(unsigned char* bytes, int w, int h, int bpp, double horizontalAngleDegree = 360.0);
    // in this version bpp is not used and should be 4 always
    // horizontalAngleDegree also should be always 360
    virtual void initialize(unsigned char* bytes, int w, int h, int bpp, double horizontalAngleDegree = 360.0);
	virtual ~SphericalPanoramaViewer();
    virtual void checkHPF();
};

#endif
