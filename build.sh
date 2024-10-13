#!/bin/bash

# List all *.webp files inside a directory.
listImages() {
    echo $(cd "$1" && find *.webp -maxdepth 1 -type f -exec printf '%s;' {} \;)
}

# List all countries inside the src/assets/image folder.
listCountries() {
    # Get all directories inside the src/assets/image folder. (Switzerland;Germany;...)
    echo $(cd "src/assets/image" && find * -maxdepth 1 -type d -exec printf '%s;' {} \;)
}

# Convert a bash list to a JavaScript array.
bashListToJsArray() {
    BASH_LIST=$1

    # Convert the custom list string (Element1;Element2;..) to an array.
    IFS=';' read -a BASH_ARRAY <<< "$BASH_LIST"

    JS_ARRAY=""

    for ITEM in "${BASH_ARRAY[@]}"; do
        JS_ARRAY+="\"$ITEM\", "
    done

    JS_ARRAY="[${JS_ARRAY%, }]"
    echo $JS_ARRAY
}

# Insert the replacement text into the HTML file between two flags.
insertIntoHtmlFile() {
    PLACEHOLDER=$1
    REPLACEMENT_TEXT=$2

    # Use sed to insert the replacement text between the two lines
    sed -i '' "/\/\/\/ ${PLACEHOLDER}\.\.\./,/\/\/\/ \.\.\.${PLACEHOLDER}/{//!d; /\/\/\/ ${PLACEHOLDER}\.\.\./a\\
      $REPLACEMENT_TEXT
    }" "src/index.html"
}


# 1. Step: Get all country codes.
COUNTRY_LIST=$(listCountries)
# Convert the custom list string (Element1;Element2;..) to an array.
IFS=';' read -a COUNTRY_ARRAY <<< "$COUNTRY_LIST"

# 2. Step: Get all image arrays per country code and write them into the HTML file.
IMAGE_OBJECT_JS=""

for COUNTRY in "${COUNTRY_ARRAY[@]}"; do
    IMAGE_ARRAY=$(listImages "src/assets/image/${COUNTRY}/")
    IMAGE_OBJECT_JS+="\"$COUNTRY\": $(bashListToJsArray "${IMAGE_ARRAY[@]}"), "
done

IMAGE_OBJECT_JS="{${IMAGE_OBJECT_JS%, }}"
insertIntoHtmlFile "IMAGE_OBJECT" "const imageObject = ${IMAGE_OBJECT_JS};"

exit 0