#!/bin/sh
set -eu

CONFIG_DIR="$CI_PRIMARY_REPOSITORY_PATH/Hilingual/App/Config"
DEBUG_TEMPLATE="$CONFIG_DIR/Debug.xcconfig.template"
RELEASE_TEMPLATE="$CONFIG_DIR/Release.xcconfig.template"
DEBUG_OUTPUT="$CONFIG_DIR/Debug.xcconfig"
RELEASE_OUTPUT="$CONFIG_DIR/Release.xcconfig"

REQUIRED_ENV="
BASE_URL_DEBUG
BASE_URL_RELEASE
MASTERKEY
AMPLITUDE_API_KEY
GAD_APPLICATION_IDENTIFIER_DEBUG
GAD_APPLICATION_IDENTIFIER_RELEASE
AD_BANNER_UNIT_ID_DEBUG
AD_BANNER_UNIT_ID_RELEASE
AD_NATIVE_UNIT_ID_DEBUG
AD_NATIVE_UNIT_ID_RELEASE
AD_FEEDBACK_UNIT_ID_DEBUG
AD_FEEDBACK_UNIT_ID_RELEASE
AD_INTERSTITIAL_UNIT_ID_DEBUG
AD_INTERSTITIAL_UNIT_ID_RELEASE
AD_RECOVERY_UNIT_ID_DEBUG
AD_RECOVERY_UNIT_ID_RELEASE
"

require_env() {
  missing=""
  for var_name in $REQUIRED_ENV; do
    eval "var_value=\${$var_name:-}"
    [ -z "$var_value" ] && missing="$missing  $var_name\n"
  done
  [ -z "$missing" ] && return 0

  echo "Missing required environment variables:" >&2
  printf "$missing" >&2
  echo "Xcode Cloud 워크플로의 환경 변수를 확인하세요. docs/xcode-cloud-secrets.md 참고." >&2
  exit 1
}

write_from_template() {
  template_path="$1"
  output_path="$2"

  python3 - "$template_path" "$output_path" <<'PY'
import os
import pathlib
import sys

template_path = pathlib.Path(sys.argv[1])
output_path = pathlib.Path(sys.argv[2])

replacements = {
    "__BASE_URL_DEBUG__": os.environ["BASE_URL_DEBUG"],
    "__BASE_URL_RELEASE__": os.environ["BASE_URL_RELEASE"],
    "__MASTERKEY__": os.environ["MASTERKEY"],
    "__AMPLITUDE_API_KEY__": os.environ["AMPLITUDE_API_KEY"],
    "__GAD_APPLICATION_IDENTIFIER_DEBUG__": os.environ["GAD_APPLICATION_IDENTIFIER_DEBUG"],
    "__GAD_APPLICATION_IDENTIFIER_RELEASE__": os.environ["GAD_APPLICATION_IDENTIFIER_RELEASE"],
    "__AD_BANNER_UNIT_ID_DEBUG__": os.environ["AD_BANNER_UNIT_ID_DEBUG"],
    "__AD_BANNER_UNIT_ID_RELEASE__": os.environ["AD_BANNER_UNIT_ID_RELEASE"],
    "__AD_NATIVE_UNIT_ID_DEBUG__": os.environ["AD_NATIVE_UNIT_ID_DEBUG"],
    "__AD_NATIVE_UNIT_ID_RELEASE__": os.environ["AD_NATIVE_UNIT_ID_RELEASE"],
    "__AD_FEEDBACK_UNIT_ID_DEBUG__": os.environ["AD_FEEDBACK_UNIT_ID_DEBUG"],
    "__AD_FEEDBACK_UNIT_ID_RELEASE__": os.environ["AD_FEEDBACK_UNIT_ID_RELEASE"],
    "__AD_INTERSTITIAL_UNIT_ID_DEBUG__": os.environ["AD_INTERSTITIAL_UNIT_ID_DEBUG"],
    "__AD_INTERSTITIAL_UNIT_ID_RELEASE__": os.environ["AD_INTERSTITIAL_UNIT_ID_RELEASE"],
    "__AD_RECOVERY_UNIT_ID_DEBUG__": os.environ["AD_RECOVERY_UNIT_ID_DEBUG"],
    "__AD_RECOVERY_UNIT_ID_RELEASE__": os.environ["AD_RECOVERY_UNIT_ID_RELEASE"],
}

content = template_path.read_text(encoding="utf-8")
for placeholder, value in replacements.items():
    content = content.replace(placeholder, value.replace("//", "/$()/"))

output_path.write_text(content, encoding="utf-8")
PY
}

require_env

write_from_template "$DEBUG_TEMPLATE" "$DEBUG_OUTPUT"
write_from_template "$RELEASE_TEMPLATE" "$RELEASE_OUTPUT"

echo "Generated xcconfig files for Xcode Cloud."
