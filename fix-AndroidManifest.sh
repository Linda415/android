#!/bin/bash

LOCAL_PATH="$1"

md5_old="Be07C2LBU09N8KYa2AFCfyAT"
md5_odm="tFNfE8R91DabWKNbfCSdYW2N"
md5_formal="WQWTTHFeJ8y4VDLPrfCW72JF"

if test -z "$SMARTCM_PLATFORM_KEY"; then
	perl -npe "s/$md5_old|$md5_odm|$md5_formal/$md5_old/" -i ${LOCAL_PATH}/AndroidManifest.xml
elif test "$SMARTCM_PLATFORM_KEY" = formal-build.key; then
	perl -npe "s/$md5_old|$md5_odm|$md5_formal/$md5_formal/" -i ${LOCAL_PATH}/AndroidManifest.xml
elif test "$SMARTCM_PLATFORM_KEY" = odm-formal-build.key; then
	perl -npe "s/$md5_old|$md5_odm|$md5_formal/$md5_odm/" -i ${LOCAL_PATH}/AndroidManifest.xml
fi
