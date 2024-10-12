# phts.hrkltz.io
https://phts.hrkltz.io

## Setup
```bash
brew install cwebp
```

## Convert To *.webp
```bash
# For landscape images:
cwebp -q 50 -resize 1920 0 image.png -o image.webp
# For portrait images:
cwebp -q 50 -resize 0 1920 image.png -o image.webp
```