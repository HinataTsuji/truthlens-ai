# TruthLens AI - Mobile App 📱

Flutter mobile application for TruthLens AI fake news detection system. Available for iOS and Android.

## Features

- 🔍 **Text Analysis**: Analyze news text for authenticity
- 📸 **Image Analysis**: Use camera or gallery to analyze news screenshots
- 🎯 **Verdict Display**: Clear TRUE/FALSE/MISLEADING/UNVERIFIED verdicts
- 📊 **Confidence Scoring**: Visual confidence percentage with progress bar
- 💡 **Detailed Results**: Explanation, key findings, sources, and red flags
- 🔗 **Clickable Sources**: Open source links directly in browser
- 🎨 **Beautiful UI**: Material Design 3 with purple gradient theme

## Prerequisites

- **Flutter SDK**: Version 3.0.0 or higher
- **Dart SDK**: Comes with Flutter
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Mobile Platform Tools**:
  - For Android: Android SDK, Android Studio
  - For iOS: Xcode (macOS only)

### Install Flutter

Follow the official installation guide: https://docs.flutter.dev/get-started/install

After installation, verify with:
```bash
flutter doctor
```

## Setup

### 1. Install Dependencies

```bash
cd mobile
flutter pub get
```

### 2. Configure API Endpoint

Edit `lib/services/api_service.dart` and update the `baseUrl` constant:

**For Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

**For iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:3000';
```

**For Physical Device:**
```dart
static const String baseUrl = 'http://YOUR_IP:3000';  // e.g., 'http://192.168.1.100:3000'
```

To find your computer's IP address:
- **macOS/Linux**: `ifconfig | grep "inet "`
- **Windows**: `ipconfig`

**For Production:**
```dart
static const String baseUrl = 'https://your-deployed-backend.com';
```

### 3. Ensure Backend is Running

Make sure the backend-ai and gateway-api services are running:

```bash
# Terminal 1 - Backend AI
cd backend-ai
python app.py

# Terminal 2 - Gateway API
cd gateway-api
node server.js
```

## Running the App

### Android Emulator

1. Start Android emulator from Android Studio or command line:
   ```bash
   flutter emulators --launch <emulator_id>
   ```

2. Run the app:
   ```bash
   flutter run
   ```

### iOS Simulator (macOS only)

1. Start iOS simulator:
   ```bash
   open -a Simulator
   ```

2. Run the app:
   ```bash
   flutter run
   ```

### Physical Device

1. **Android**:
   - Enable Developer Options and USB Debugging
   - Connect device via USB
   - Run: `flutter run`

2. **iOS** (requires macOS):
   - Register device in Xcode
   - Configure signing
   - Run: `flutter run`

## Building Release Versions

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS (macOS only)

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode to archive and export.

## Troubleshooting

### Connection Issues

**Error: "Cannot connect to server"**

1. Verify backend and gateway are running
2. Check API endpoint URL in `api_service.dart`
3. For physical devices:
   - Ensure device is on same WiFi network
   - Check firewall settings
   - Verify IP address is correct

**Android Emulator Connection:**
- Use `http://10.0.2.2:3000` (not localhost)
- Ensure `android:usesCleartextTraffic="true"` in AndroidManifest.xml

**iOS Simulator Connection:**
- Use `http://localhost:3000`
- Check NSAppTransportSecurity settings in Info.plist

### Image Picker Issues

**Error: "Permission denied"**

1. Check AndroidManifest.xml has camera/storage permissions
2. Check Info.plist has camera/photo library descriptions
3. Grant permissions when prompted on device
4. On iOS: Settings → App → Allow Camera/Photos

### Build Errors

**Error: "No Podfile found"** (iOS)
```bash
cd ios
pod install
```

**Error: "Gradle sync failed"** (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**General build issues:**
```bash
flutter clean
flutter pub get
flutter doctor
```

### Common Issues

1. **Hot reload not working**: Use hot restart (Shift+R in terminal)
2. **White screen on startup**: Check console for errors
3. **Dependencies not found**: Run `flutter pub get`
4. **Plugin errors**: Run `flutter clean` then rebuild

## Project Structure

```
mobile/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── analysis_result.dart  # Data model
│   ├── screens/
│   │   └── home_screen.dart      # Main screen
│   ├── services/
│   │   └── api_service.dart      # API communication
│   └── widgets/
│       └── result_card.dart      # Results display widget
├── android/                      # Android-specific files
├── ios/                          # iOS-specific files
├── pubspec.yaml                  # Dependencies
└── README.md                     # This file
```

## Dependencies

- **http** (^1.1.2): HTTP requests
- **image_picker** (^1.0.5): Camera and gallery access
- **flutter_spinkit** (^5.2.0): Loading animations
- **url_launcher** (^6.2.2): Open URLs in browser
- **cupertino_icons** (^1.0.6): iOS-style icons

## Development Tips

1. **Enable hot reload**: Press 'r' in terminal while app is running
2. **Hot restart**: Press 'R' in terminal
3. **Toggle performance overlay**: Press 'p' in terminal
4. **Debug mode**: `flutter run`
5. **Profile mode**: `flutter run --profile`
6. **Release mode**: `flutter run --release`

## API Reference

The app communicates with the TruthLens backend via:

**Endpoint**: `POST /api/verify`

**Request** (multipart/form-data):
- `text` (optional): News text to analyze
- `image` (optional): Image file to analyze

**Response**:
```json
{
  "verdict": "TRUE|FALSE|MISLEADING|UNVERIFIED",
  "confidence": 0.85,
  "explanation": "...",
  "key_findings": [...],
  "sources": [...],
  "red_flags": [...]
}
```

## Support

For issues or questions:
1. Check this README troubleshooting section
2. Review Flutter documentation: https://docs.flutter.dev
3. Check GitHub issues in the main repository

## License

This project is part of the TruthLens AI system.
