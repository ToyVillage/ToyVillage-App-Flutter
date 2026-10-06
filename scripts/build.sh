#!/usr/bin/env bash
set -euo pipefail

FLAVOR="${1:-}"
TARGET="${2:-all}"

if [[ "$FLAVOR" != "stag" && "$FLAVOR" != "prod" ]]; then
  echo "사용법: ./scripts/build.sh <stag|prod> [apk|ipa|all]" >&2
  exit 1
fi

if ! grep -q "String.fromEnvironment('FLAVOR'" lib/core/config/app_env.dart; then
  echo "lib/core/config/app_env.dart 가 FLAVOR dart-define을 사용하지 않습니다." >&2
  echo "app_env.example.dart 처럼 appFlavor 를 FLAVOR 기반으로 바꾼 뒤 다시 실행하세요." >&2
  echo "(안 그러면 파일명은 $FLAVOR 지만 실제 앱은 고정된 환경으로 빌드됩니다)" >&2
  exit 1
fi

VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: *//' | tr -d '[:space:]')
OUT_DIR="build/dist"
mkdir -p "$OUT_DIR"

build_apk() {
  flutter build apk --release --dart-define=FLAVOR="$FLAVOR"
  cp build/app/outputs/flutter-apk/app-release.apk \
    "$OUT_DIR/toyvillage-$FLAVOR-$VERSION.apk"
  echo "APK -> $OUT_DIR/toyvillage-$FLAVOR-$VERSION.apk"
}

build_ipa() {
  flutter build ipa --release --dart-define=FLAVOR="$FLAVOR"
  cp build/ios/ipa/*.ipa "$OUT_DIR/toyvillage-$FLAVOR-$VERSION.ipa"
  echo "IPA -> $OUT_DIR/toyvillage-$FLAVOR-$VERSION.ipa"
}

case "$TARGET" in
  apk) build_apk ;;
  ipa) build_ipa ;;
  all) build_apk; build_ipa ;;
  *) echo "알 수 없는 타겟: $TARGET (apk|ipa|all)" >&2; exit 1 ;;
esac

echo "완료: $FLAVOR / $VERSION"
