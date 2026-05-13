#!/usr/bin/env bash

show_usage() {
  echo "Usage:"
  echo "  $0 --audio <VIDEO_URL> [--cookies]"
  echo "  $0 --video <VIDEO_URL> [--cookies]"
  echo
  echo "Options:"
  echo "  --cookies    Enable --cookies-from-browser chrome"
  exit 1
}

if [ $# -lt 2 ]; then
  show_usage
fi

MODE="$1"
VIDEO_URL="$2"

# Optional flag
USE_COOKIES=false

if [ $# -ge 3 ] && [ "$3" = "--cookies" ]; then
  USE_COOKIES=true
fi

# Build optional cookies args.
COOKIE_ARGS=()
if [ "$USE_COOKIES" = true ]; then
  COOKIE_ARGS+=(--cookies-from-browser chrome)
fi

case "$MODE" in
  --audio)
    yt-dlp -f bestaudio -x --audio-format mp3 --audio-quality 0 \
      --no-playlist --concurrent-fragments 1 \
      --retries 10 --fragment-retries 10 \
      "${COOKIE_ARGS[@]}" \
      "$VIDEO_URL"
    ;;
  --video)
    yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]" \
      --embed-thumbnail \
      --merge-output-format mp4 \
      --concurrent-fragments 1 \
      "${COOKIE_ARGS[@]}" \
      "$VIDEO_URL"
    ;;
  *)
    echo "Error: Unknown option '$MODE'"
    show_usage
    ;;
esac
