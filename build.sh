#!/bin/bash

# List the content of a directory
listDirectoryContent() {
    TARGET_FOLDER=$1
    FILES=$(ls -1 "$TARGET_FOLDER")
    echo $FILES
}

# Convert a bash array to a JavaScript array
bashArrayToJsArray() {
    BASH_ARRAY=$1
    JS_ARRAY=""
    for ITEM in $BASH_ARRAY; do
        JS_ARRAY+="\"$ITEM\","
    done
    JS_ARRAY="[${JS_ARRAY%,}]"
    echo $JS_ARRAY
}

# Insert the replacement text into the HTML file between two flags.
insertIntoHtmlFile() {
    PLACEHOLDER=$1
    REPLACEMENT_TEXT=$2

    # Use sed to insert the replacement text between the two lines
    sed -i '' "/\/\/\/ ${PLACEHOLDER}\.\.\./,/\/\/\/ \.\.\.${PLACEHOLDER}/{//!d; /\/\/\/ ${PLACEHOLDER}\.\.\./a\\
      $REPLACEMENT_TEXT
    }" "index.html"
}

# 1. Step: Get all country codes.
COUNTRY_CODE_ARRAY=$(listDirectoryContent "data/")

# 2. Step: Get all image arrays per country code and write them into the HTML file.
IMAGE_OBJECT_JS=""
for COUNTRY_CODE in $COUNTRY_CODE_ARRAY; do
    IMAGE_ARRAY=$(listDirectoryContent "data/${COUNTRY_CODE}/")
    IMAGE_OBJECT_JS+="\"$COUNTRY_CODE\": $(bashArrayToJsArray "${IMAGE_ARRAY[@]}"),"
    #insertIntoHtmlFile "IMAGE_ARRAY_${COUNTRY_CODE}" "const imageArray${COUNTRY_CODE} = ${IMAGE_ARRAY_JS};"
done

IMAGE_OBJECT_JS="{${IMAGE_OBJECT_JS%,}}"
echo $IMAGE_OBJECT_JS

insertIntoHtmlFile "IMAGE_OBJECT" "const imageObject = ${IMAGE_OBJECT_JS};"

exit 0

# Use sed to replace the placeholder <TEST> with the replacement text
sed -i '' "s/<COUNTRY_CODE_ARRAY>/${REPLACEMENT_TEXT}/g" "index.html"