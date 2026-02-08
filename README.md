# TruthLens AI 🔍

TruthLens is a multimodal fake news detection system. It uses **Gemini 1.5 Pro** to perform OCR on images and cross-reference text claims with live Google Search data.

**Available on Web and Mobile (iOS + Android)** 🌐📱

## 🚀 Features
- **OCR Analysis:** Extract text from news screenshots automatically.
- **Live Fact-Checking:** Grounded responses using Google Search.
- **Confidence Scoring:** Visual representation of the AI's certainty.
- **Mobile Apps:** Native iOS and Android applications with camera integration.
- **Multi-Platform:** Works on web browsers and mobile devices.

## 📁 Project Structure

```
truthlens-ai/
├── backend-ai/          # Python Flask + Gemini AI
│   ├── app.py
│   ├── requirements.txt
│   └── .env
├── gateway-api/         # Node.js Express Gateway
│   ├── server.js
│   └── package.json
├── frontend/            # Web UI (HTML/CSS/JS)
│   ├── index.html
│   ├── style.css
│   └── script.js
├── mobile/              # Flutter Mobile App (iOS + Android)
│   ├── lib/
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
├── docker-compose.yml
└── README.md
```

## 🛠️ Setup

### Backend Services

1. **Backend-AI (Python):**
   ```bash
   cd backend-ai
   pip install -r requirements.txt
   ```
   - Add `GEMINI_API_KEY` to `.env`
   - Run `python app.py`

2. **Gateway (Node.js):**
   ```bash
   cd gateway-api
   npm install
   node server.js
   ```

### Frontend (Web)

3. **Web Application:**
   - Open `frontend/index.html` in your browser
   - Or use a local server: `python -m http.server 8080`

### Mobile App (Flutter)

4. **iOS + Android Application:**
   ```bash
   cd mobile
   flutter pub get
   flutter run
   ```
   
   See [mobile/README.md](mobile/README.md) for detailed instructions.

## 📱 Mobile App (Flutter)

The TruthLens AI mobile application is available for iOS and Android devices.

### Features
- Native mobile experience
- Camera integration for instant screenshot analysis
- Gallery image picker
- Offline-capable UI (analysis requires internet)
- Beautiful Material Design interface

### Quick Start
1. Install Flutter SDK (version 3.0+)
2. Navigate to mobile directory: `cd mobile`
3. Install dependencies: `flutter pub get`
4. Configure API endpoint in `lib/services/api_service.dart`
5. Run the app: `flutter run`

### Building
- **Android APK**: `flutter build apk --release`
- **iOS IPA**: `flutter build ios --release` (requires macOS)

See [mobile/README.md](mobile/README.md) for detailed setup, configuration, and troubleshooting.

## ⚙️ Configuration

### Backend API Endpoint

For the mobile app to connect to your backend:

**Local Development:**
- **Android Emulator**: Use `http://10.0.2.2:3000`
- **iOS Simulator**: Use `http://localhost:3000`
- **Physical Device**: Use your computer's IP address (e.g., `http://192.168.1.100:3000`)

To find your IP address:
- **macOS/Linux**: Run `ifconfig | grep "inet "`
- **Windows**: Run `ipconfig`

Update the `baseUrl` in `mobile/lib/services/api_service.dart`

**Production:**
Deploy your backend to a cloud service (Railway, Render, Heroku) and update the `baseUrl` to your deployed URL.

## 🚀 Deployment

### Web Application
1. Deploy frontend to any static hosting (Netlify, Vercel, GitHub Pages)
2. Deploy backend-ai and gateway-api to cloud platforms
3. Update frontend API endpoint

### Mobile App Deployment

#### Google Play Store (Android)
1. Build signed APK/AAB: `flutter build appbundle`
2. Create developer account at play.google.com/console
3. Upload your app bundle
4. Complete store listing
5. Submit for review

#### Apple App Store (iOS)
1. Build iOS app: `flutter build ios --release`
2. Open `ios/Runner.xcworkspace` in Xcode
3. Configure signing & capabilities
4. Archive and upload to App Store Connect
5. Submit for review

See [Flutter deployment guide](https://docs.flutter.dev/deployment) for details.

## 🔧 Troubleshooting

### Backend Issues
- Ensure Python dependencies are installed
- Check `GEMINI_API_KEY` is set in `.env`
- Verify backend is running on port 5000

### Gateway Issues
- Ensure Node.js dependencies are installed
- Check gateway is running on port 3000
- Verify `BACKEND_URL` environment variable

### Web Frontend Issues
- Check browser console for errors
- Ensure backend and gateway are running
- Verify API endpoints in `script.js`

### Mobile App Issues

**"Connection refused" error:**
- Ensure backend and gateway are running
- Check firewall settings
- Verify API URL in `api_service.dart`
- For physical devices, ensure same WiFi network

**Image picker not working:**
- Check permissions in AndroidManifest.xml / Info.plist
- Grant camera/photo permissions on device

**Build errors:**
- Run `flutter clean && flutter pub get`
- Update Flutter SDK: `flutter upgrade`
- Check SDK version: `flutter doctor`

See [mobile/README.md](mobile/README.md) for more troubleshooting help.
