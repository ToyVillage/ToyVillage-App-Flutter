#!/usr/bin/env bash
set -euo pipefail

# 사용:
#   ./scripts/build.sh prod all     # prod APK + IPA
#   ./scripts/build.sh stag apk     # stag APK
#   ./scripts/build.sh prod ipa     # prod IPA
# flavor: stag | prod,  target: apk | ipa | all (기본 all)

FLAVOR="${1:-}"
TARGET="${2:-all}"

if [[ "$FLAVOR" != "stag" && "$FLAVOR" != "prod" ]]; then
  echo "사용법: ./scripts/build.sh <stag|prod> [apk|ipa|all]" >&2
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
