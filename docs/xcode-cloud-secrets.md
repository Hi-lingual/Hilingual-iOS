# Xcode Cloud xcconfig secrets

`Debug.xcconfig` and `Release.xcconfig` stay ignored and must not be committed.

Tracked template files:

- `Hilingual/App/Config/Debug.xcconfig.template`
- `Hilingual/App/Config/Release.xcconfig.template`

Xcode Cloud generates the real xcconfig files during `ci_post_clone.sh`:

- `ci_scripts/ci_post_clone.sh`

## Xcode Cloud variables to add

Add these environment variables in your Xcode Cloud workflow:

- `BASE_URL_DEBUG`
- `BASE_URL_RELEASE`
- `MASTERKEY`
- `AMPLITUDE_API_KEY`
- `GAD_APPLICATION_IDENTIFIER_DEBUG`
- `GAD_APPLICATION_IDENTIFIER_RELEASE`
- `AD_BANNER_UNIT_ID_DEBUG`
- `AD_BANNER_UNIT_ID_RELEASE`
- `AD_NATIVE_UNIT_ID_DEBUG`
- `AD_NATIVE_UNIT_ID_RELEASE`
- `AD_FEEDBACK_UNIT_ID_DEBUG`
- `AD_FEEDBACK_UNIT_ID_RELEASE`
- `AD_INTERSTITIAL_UNIT_ID_DEBUG`
- `AD_INTERSTITIAL_UNIT_ID_RELEASE`
- `AD_RECOVERY_UNIT_ID_DEBUG`
- `AD_RECOVERY_UNIT_ID_RELEASE`
- `GID_IOS_CLIENT_KEY_DEBUG`
- `GID_IOS_CLIENT_KEY_RELEASE`
- `GID_SERVER_CLIENT_ID_DEBUG`
- `GID_SERVER_CLIENT_ID_RELEASE`

`GID_IOS_CLIENT_KEY_*` is the iOS OAuth client ID without the `.apps.googleusercontent.com` suffix (e.g. `123-abc`). `GID_SERVER_CLIENT_ID_*` is the full Web client ID shared with Android.

Mark secret values as secrets in Xcode Cloud where appropriate.

## Local development

Local builds still require real files:

- `Hilingual/App/Config/Debug.xcconfig`
- `Hilingual/App/Config/Release.xcconfig`

Those files remain ignored by git. Create them from the template files and fill in your own local values.

## Important

Do not add actual values to:

- template files
- `.xcconfig` files tracked by git
- workflow YAML files
- documentation
