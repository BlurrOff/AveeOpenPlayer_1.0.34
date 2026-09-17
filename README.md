
<p align="center">
  <img width="100" height="100" src="app/src/main/res/drawable-xxxhdpi/ic_launcher.png">
</p>

# Avee Open Player (Avee 1.0.34)

Avee Music Player Version (1.0.34) source release.


Audio playback is realized using MediaPlayer Api and ExoPlayer project. 
Visualizer is rendered using OpenGL, sound spectrum created using FFT with additional processing. 

## Android Code Studio (ACS) mobile build

This project is configured for a conservative ACS/mobile Gradle stack:

- Android Gradle Plugin `7.4.2`
- Gradle wrapper `7.5.1`
- JDK `11` minimum (`17` also works if ACS provides it)
- Android SDK Platform `34` installed in ACS, plus a compatible Android Build-Tools package

Run from the project root in the ACS terminal:

```sh
chmod +x acs_debug_build.sh
./acs_debug_build.sh
```

The script updates `local.properties` when it finds a valid SDK through `ANDROID_SDK_ROOT`, `ANDROID_HOME`, or common ACS/AndroidIDE SDK paths, then runs `:app:assembleDebug`.

## Features

Android music player / audio visualization app. 

* Most popular formats and network streams supported
* Shuffle and repeat modes
* Direct folder browsing whit folder shortcuts
* Searchable library, queue, files, ...
* Screen orientation lock
* Playlist editing
* Queue editing
* Item sorting
* Supports two playback engines (Native / ExoPlayer)
* Lockscreen and status bar widget
* Supports media and bluetooth controls
* Sleep timer
* Video fit, crop and strech modes
* Audio visualizer - spectrum and waveform variants
* Add media by external links (including adaptive streaming)
* Won't keep running in background for no reason


# License

    Copyright 2019 Avee Player

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
