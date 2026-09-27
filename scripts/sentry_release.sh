#!/usr/bin/env bash
set -euo pipefail

PLATFORM="${1:-android}"
SYMBOLS_DIR="build/symbols"

if [[ -z "${SENTRY_AUTH_TOKEN:-}" ]]; then
  echo "SENTRY_AUTH_TOKEN 환경변수가 없습니다. export SENTRY_AUTH_TOKEN=... 후 다시 실행하세요." >&2
  exit 1
fi

case "$PLATFORM" in
  android)
    flutter build appbundle --release \
      --obfuscate --split-debug-info="$SYMBOLS_DIR"
    ;;
  ios)
    flutter build ios --release --no-codesign \
      --obfuscate --split-debug-info="$SYMBOLS_DIR"
    ;;
  *)
    echo "알 수 없는 플랫폼: $PLATFORM (android | ios)" >&2
    exit 1
    ;;
esac

dart run sentry_dart_plugin

echo "완료: 릴리즈 빌드 및 심볼 업로드가 끝났습니다."
