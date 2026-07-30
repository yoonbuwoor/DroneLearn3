from pathlib import Path
import re
import shutil

ROOT = Path(__file__).resolve().parents[1]
ANDROID = ROOT / "android"
APP = ANDROID / "app"

manifest = APP / "src" / "main" / "AndroidManifest.xml"
if manifest.exists():
    text = manifest.read_text(encoding="utf-8")
    text = text.replace('android:label="droneatlas"', 'android:label="DroneAtlas Academy"')
    text = text.replace('android:label="Droneatlas"', 'android:label="DroneAtlas Academy"')
    text = text.replace('android:label="DroneAtlas"', 'android:label="DroneAtlas Academy"')
    permissions = [
        'android.permission.INTERNET',
        'android.permission.POST_NOTIFICATIONS',
    ]
    for permission in permissions:
        marker = f'<uses-permission android:name="{permission}" />'
        if marker not in text:
            text = text.replace(
                '<manifest xmlns:android="http://schemas.android.com/apk/res/android">',
                '<manifest xmlns:android="http://schemas.android.com/apk/res/android">\n'
                f'    {marker}',
            )
    manifest.write_text(text, encoding="utf-8")

icon_root = ROOT / "tool" / "icons"
res_root = APP / "src" / "main" / "res"
for source_dir in icon_root.glob("mipmap-*"):
    source = source_dir / "ic_launcher.png"
    if source.exists():
        target_dir = res_root / source_dir.name
        target_dir.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target_dir / "ic_launcher.png")

# Configuration nécessaire à flutter_local_notifications 22.x.
gradle = APP / "build.gradle.kts"
if gradle.exists():
    text = gradle.read_text(encoding="utf-8")
    text = re.sub(r'compileSdk\s*=\s*flutter\.compileSdkVersion', 'compileSdk = 36', text)
    text = re.sub(r'minSdk\s*=\s*flutter\.minSdkVersion', 'minSdk = 24', text)
    text = re.sub(
        r'sourceCompatibility\s*=\s*JavaVersion\.VERSION_\d+',
        'sourceCompatibility = JavaVersion.VERSION_17',
        text,
    )
    text = re.sub(
        r'targetCompatibility\s*=\s*JavaVersion\.VERSION_\d+',
        'targetCompatibility = JavaVersion.VERSION_17',
        text,
    )
    text = re.sub(
        r'jvmTarget\s*=\s*JavaVersion\.VERSION_\d+\.toString\(\)',
        'jvmTarget = JavaVersion.VERSION_17.toString()',
        text,
    )
    if 'isCoreLibraryDesugaringEnabled = true' not in text:
        text = text.replace(
            'compileOptions {',
            'compileOptions {\n        isCoreLibraryDesugaringEnabled = true',
            1,
        )
    if 'multiDexEnabled = true' not in text:
        text = text.replace(
            'defaultConfig {',
            'defaultConfig {\n        multiDexEnabled = true',
            1,
        )
    release_marker = "buildTypes {\n        release {"
    if release_marker in text and 'signingConfig = signingConfigs.getByName("debug")' not in text:
        text = text.replace(
            release_marker,
            release_marker + '\n            signingConfig = signingConfigs.getByName("debug")',
        )
    dependencies = '''

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")
}
'''
    if 'coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")' not in text:
        text = text.rstrip() + dependencies
    gradle.write_text(text, encoding="utf-8")

settings = ANDROID / "settings.gradle.kts"
if settings.exists():
    text = settings.read_text(encoding="utf-8")
    text = re.sub(
        r'id\("com\.android\.application"\) version "[^"]+"',
        'id("com.android.application") version "8.11.1"',
        text,
    )
    text = re.sub(
        r'id\("org\.jetbrains\.kotlin\.android"\) version "[^"]+"',
        'id("org.jetbrains.kotlin.android") version "2.1.20"',
        text,
    )
    settings.write_text(text, encoding="utf-8")

wrapper = ANDROID / "gradle" / "wrapper" / "gradle-wrapper.properties"
if wrapper.exists():
    text = wrapper.read_text(encoding="utf-8")
    text = re.sub(
        r'distributionUrl=.*gradle-[^-]+-(?:all|bin)\.zip',
        'distributionUrl=https\\://services.gradle.org/distributions/gradle-8.13-all.zip',
        text,
    )
    wrapper.write_text(text, encoding="utf-8")

print("Configuration Android DroneAtlas (notifications + mises à jour) appliquée.")
