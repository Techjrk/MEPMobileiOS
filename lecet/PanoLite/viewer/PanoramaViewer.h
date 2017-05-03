//
//  DMDViewerController.h
//
//  Created by AMS on 10/16/13.
//  Copyright (c) 2013 Dermandar. All rights reserved.
//  DMDViewerSample v3.1

#include <stdlib.h>

#ifndef PANORAMAVIEWER_H
#define PANORAMAVIEWER_H

class Texture;
class Geometry;

class PanoramaViewer
{
public:
	Texture *texture;
	Geometry *geometry;
    int Max_Texture_Size;

	unsigned int m_uiVertexShader, m_uiFragShader;
	unsigned int m_uiProgramObject;
	int i32Location;

	float viewMatrix[16];

	double DEGREE_TO_RADIAN(double degree);
	double znear, zfar;

	bool partial;
	int WW;
	int HH;

	bool portrait;
	bool controlstart;
	double ASP;

	bool moving;

	double cx;
	double cy;

	double prevH;
	double prevP;

	double prevprevH;
	double prevprevP;

	bool trans;

	double animc;

	double Frad;
	double Fs;
	double dF;
	double Fmin;
	double Fmax;

	double P;		// PITCH
	double Ps;
	double dP;
	double Pmin;
	double Pmax;

	double H;		// HEADING
	double Hs;
	double dH;
	double Hmin;
	double Hmax;

	double ori;

	double s;

	bool tejj;

	double animbez[4];
    
    double fovXDeg;

	virtual void checkHPF();
	virtual void initControl();
	virtual bool animate();
	virtual void transRot(double _dH, double _dP);
	virtual void transZoom(double _H, double _P, double _F, double _s);
	virtual void autoplay();

public:
    // in this version bpp is not used and should be 4 always
	virtual void initialize(unsigned char* bytes, int w, int h, int bpp, double horizontalAngleDegree = 360.0);

public:
	bool changed;

	PanoramaViewer();
	virtual bool draw(bool force = false);

	virtual void zoom(double x, double y);
	virtual void zoomsc(double sc);
	virtual void scroll(double delta, double x, double y);
	virtual void move(double x, double y);
	virtual void start(double x, double y);
	virtual void end();
    // H: angle in radian over the y axis;
    virtual void setH(double hRadian);
    virtual double getH();
    // P: angle in radian over the x axis;
    virtual void setP(double pRadian);
    virtual double getP();
    // F: angle in radian represents the current vertical field of view;
    virtual void setF(double fRadian);
    virtual double getF();
    virtual double getFmin();
    virtual double getFmax();
    virtual double getPmin();
    virtual double getPmax();
    virtual double getHmin();
    virtual double getHmax();
	virtual void setDim(double _WW, double _HH);
    //clickX and clickY both of them should take into consideration the scalefactor of the screen.
    //percentageImageX: value between 0.0 and 1.0 denotes the horizontal normalized shift on the image regarding to the top-left point of the image (multiply by the image width to get the pixel's x).
    //percentageImageY: value between 0.0 and 1.0 denotes the vertical normalized shift on the image regarding to the top-left point of the image (multiply by the image height to get the pixel's y).
    virtual void getImageXandY(double clickX, double clickY, double &percentageImageX, double &percentageImageY);
	virtual ~PanoramaViewer();
protected:
    unsigned int t2;
};

#endif
