LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# update manifest for different signatures
$(shell ${LOCAL_PATH}/fix-AndroidManifest.sh ${LOCAL_PATH}>/dev/null 2>&1)

LOCAL_JAVA_LIBRARIES += telephony-common
LOCAL_STATIC_JAVA_LIBRARIES := csopensdk android-support-v4 core-zxing-2.2 scancode_sdk_open_business-1.0.0-SNAPSHOT scancode_sdk_open_core-1.0.0-SNAPSHOT taobao-sdk-java-auto iflytekmsc gson-2.8.1
LOCAL_REQUIRED_MODULES := libmsc_voice
LOCAL_JNI_SHARED_LIBRARIES := libmsc_voice
LOCAL_MODULE_INCLUDE_LIBRARY := true
LOCAL_SRC_FILES := $(call all-java-files-under, src)
LOCAL_PACKAGE_NAME := TextBoom
LOCAL_PROGUARD_FLAG_FILES := proguard.flags
LOCAL_CERTIFICATE := platform
LOCAL_PROGUARD_ENABLED := disabled
LOCAL_USE_FRAMEWORK_SMARTISANOS := true

ifeq ($(findstring oscar, $(TARGET_PRODUCT)), oscar)
    LOCAL_MANIFEST_FILE := ./overlay/oscar/AndroidManifest.xml
else
    LOCAL_MANIFEST_FILE := ./AndroidManifest.xml
endif

BEFORE_LOLLIPOP := $(shell if [ "$(PLATFORM_SDK_VERSION)" -le "22" ]; then echo true; else echo false; fi)

EXCLUDE_FILES := src/com/smartisanos/textboom/widget/ScrollView.java
ifeq ($(BEFORE_LOLLIPOP), true)
    OVERLAY_FILES := $(call all-java-files-under, overlay/lollipop)
    LOCAL_SRC_FILES := $(filter-out $(EXCLUDE_FILES), $(LOCAL_SRC_FILES))
    LOCAL_SRC_FILES += $(OVERLAY_FILES)
endif

BEFORE_OREO := $(shell if [ "$(PLATFORM_SDK_VERSION)" -le "25" ]; then echo true; else echo false; fi)
EXCLUDE_FILES_OREO := src/com/smartisanos/textboom/util/OverlayOreo.java

ifeq ($(BEFORE_OREO), true)
    OVERLAY_FILES_OREO := $(call all-java-files-under, overlay/oreo)
    LOCAL_SRC_FILES := $(filter-out $(EXCLUDE_FILES_OREO), $(LOCAL_SRC_FILES))
    LOCAL_SRC_FILES += $(OVERLAY_FILES_OREO)
endif


include $(BUILD_PACKAGE)

include $(CLEAR_VARS)
LOCAL_PREBUILT_STATIC_JAVA_LIBRARIES := csopensdk:libs/csopensdk.jar
LOCAL_PREBUILT_STATIC_JAVA_LIBRARIES += core-zxing-2.2:libs/core-zxing-2.2.jar
LOCAL_PREBUILT_STATIC_JAVA_LIBRARIES += scancode_sdk_open_business-1.0.0-SNAPSHOT:libs/scancode_sdk_open_business-1.0.0-SNAPSHOT.jar
LOCAL_PREBUILT_STATIC_JAVA_LIBRARIES += scancode_sdk_open_core-1.0.0-SNAPSHOT:libs/scancode_sdk_open_core-1.0.0-SNAPSHOT.jar
LOCAL_PREBUILT_STATIC_JAVA_LIBRARIES += taobao-sdk-java-auto:libs/taobao-sdk-java-auto.jar
LOCAL_PREBUILT_STATIC_JAVA_LIBRARIES += iflytekmsc:libs/Msc.jar
LOCAL_PREBUILT_STATIC_JAVA_LIBRARIES += gson-2.8.1:libs/gson-2.8.1.jar

ifeq ($(TARGET_IS_64_BIT),true)
    LOCAL_PREBUILT_LIBS +=libmsc_voice:libs/arm64-v8a/libmsc_voice.so
else
    LOCAL_PREBUILT_LIBS +=libmsc_voice:libs/armeabi-v7a/libmsc_voice.so
endif

include $(BUILD_MULTI_PREBUILT)

include $(call all-makefiles-under,$(LOCAL_PATH))
