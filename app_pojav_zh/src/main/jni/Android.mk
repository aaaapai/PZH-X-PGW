LOCAL_PATH := $(call my-dir)
HERE_PATH := $(LOCAL_PATH)

# include $(HERE_PATH)/crash_dump/libbase/Android.mk
# include $(HERE_PATH)/crash_dump/libbacktrace/Android.mk
# include $(HERE_PATH)/crash_dump/debuggerd/Android.mk


LOCAL_PATH := $(HERE_PATH)

include $(CLEAR_VARS)
LOCAL_MODULE := EGL_angle
LOCAL_SRC_FILES := tinywrapper/angle-gles/$(TARGET_ARCH_ABI)/libEGL_angle.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := angle_gles2
LOCAL_SRC_FILES := tinywrapper/angle-gles/$(TARGET_ARCH_ABI)/libGLESv2_angle.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := feature_support_angle
LOCAL_SRC_FILES := tinywrapper/angle-gles/$(TARGET_ARCH_ABI)/libfeature_support_angle.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := tinywrapper
LOCAL_SHARED_LIBRARIES := EGL_angle angle_gles2 feature_support_angle
LOCAL_CFLAGS += -O3 -fPIC -flto=thin -fwhole-program-vtables -mllvm -polly
LOCAL_LDLAGS += -flto=thin -fuse-ld=lld
LOCAL_SRC_FILES := tinywrapper/main.c tinywrapper/string_utils.c
LOCAL_C_INCLUDES := $(LOCAL_PATH)/tinywrapper
include $(BUILD_SHARED_LIBRARY)


include $(CLEAR_VARS)
# Link GLESv2 for test
LOCAL_LDLIBS := -ldl -llog -landroid
# -lGLESv2
LOCAL_MODULE := pojavexec
LOCAL_LDLAGS += -flto=thin -fuse-ld=lld
LOCAL_CFLAGS += -O3 -fPIC -flto=thin -fwhole-program-vtables -mllvm -polly
LOCAL_CFLAGS += -Wno-int-conversion
# LOCAL_CFLAGS += -DDEBUG
# -DGLES_TEST
LOCAL_SRC_FILES := \
    bigcoreaffinity.c \
    egl_bridge.c \
    ctxbridges/gl_bridge.c \
    ctxbridges/osm_bridge.c \
    ctxbridges/spare_osm_bridge.c \
    ctxbridges/egl_loader.c \
    ctxbridges/osmesa_loader.c \
    ctxbridges/swap_interval_no_egl.c \
    ctxbridges/virgl_bridge.c \
    environ/environ.c \
    input_bridge_v3.c \
    jre_launcher.c \
    utils.c \
    driver_helper.c \
    driver_helper/nsbypass.c

ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
LOCAL_CFLAGS += -DADRENO_POSSIBLE -DFRAME_BUFFER_SUPPOST
LOCAL_LDLIBS += -lEGL -lGLESv2
endif
include $(BUILD_SHARED_LIBRARY)

#ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
include $(CLEAR_VARS)
LOCAL_MODULE := linkerhook
LOCAL_SRC_FILES := driver_helper/hook.c
LOCAL_LDFLAGS := -z global
LOCAL_CFLAGS += -O3 -fPIC -flto=thin -fwhole-program-vtables -mllvm -polly
LOCAL_LDLAGS += -flto=thin -fuse-ld=lld
include $(BUILD_SHARED_LIBRARY)
#endif

$(call import-module,prefab/bytehook)
LOCAL_PATH := $(HERE_PATH)

include $(CLEAR_VARS)
LOCAL_MODULE := istdio
LOCAL_SHARED_LIBRARIES := bytehook
LOCAL_SRC_FILES := \
    stdio_is.c
LOCAL_CFLAGS += -O3 -fPIC -flto=thin -fwhole-program-vtables -mllvm -polly
LOCAL_LDLAGS += -flto=thin -fuse-ld=lld
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := pojavexec_awt
LOCAL_CFLAGS += -Wno-int-conversion
LOCAL_SRC_FILES := \
    awt_bridge.c
LOCAL_CFLAGS += -O3 -fPIC -flto=thin -fwhole-program-vtables -mllvm -polly
LOCAL_LDLAGS += -flto=thin -fuse-ld=lld
include $(BUILD_SHARED_LIBRARY)

# Helper to get current thread
# include $(CLEAR_VARS)
# LOCAL_MODULE := thread64helper
# LOCAL_SRC_FILES := thread_helper.cpp
# include $(BUILD_SHARED_LIBRARY)

# fake lib for linker
include $(CLEAR_VARS)
LOCAL_MODULE := awt_headless
include $(BUILD_SHARED_LIBRARY)

# libawt_xawt without X11, used to get Caciocavallo working
LOCAL_PATH := $(HERE_PATH)/awt_xawt
include $(CLEAR_VARS)
LOCAL_MODULE := awt_xawt
# LOCAL_CFLAGS += -DHEADLESS
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)
LOCAL_SHARED_LIBRARIES := awt_headless
LOCAL_SRC_FILES := xawt_fake.c
LOCAL_CFLAGS += -O3 -fPIC -flto=thin -fwhole-program-vtables -mllvm -polly
LOCAL_LDLAGS += -flto=thin -fuse-ld=lld
include $(BUILD_SHARED_LIBRARY)
