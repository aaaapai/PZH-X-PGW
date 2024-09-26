#include <EGL/egl.h>

#define RENDERER_GL4ES 1
#define RENDERER_VK_ZINK 2
#define RENDERER_VIRGL 3
#define RENDERER_VULKAN 4
#define RENDERER_VK_WARLIP 5
#define RENDERER_VK_ZINK_PREF 6

struct PotatoBridge {
    void* eglContext;    // EGLContext
    void* eglDisplay;    // EGLDisplay
    void* eglSurface;    // EGLSurface
    // void* eglSurfaceRead;
    // void* eglSurfaceDraw;
};

struct PotatoBridge potatoBridge;
EGLConfig config;
