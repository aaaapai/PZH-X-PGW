//
// Created by Vera-Firefly on 2.12.2023.
// Definitions specific to the renderer
//

#ifndef POTATOBRIDGE_H
#define POTATOBRIDGE_H
#include <EGL/egl.h>

struct PotatoBridge {
    void* eglContext;    // EGLContext
    void* eglDisplay;    // EGLDisplay
    void* eglSurface;    // EGLSurface
    // void* eglSurfaceRead;
    // void* eglSurfaceDraw;
};

extern struct PotatoBridge potatoBridge;
extern EGLConfig config;

#endif // POTATOBRIDGE_H


