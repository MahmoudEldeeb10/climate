# Firebase Setup Instructions for Flutter

To connect your Flutter app (Android and iOS) with Firebase, follow these step-by-step instructions using the official FlutterFire CLI.

## 1. Prerequisites
- Node.js installed on your machine.
- Firebase account (create one at https://console.firebase.google.com/).
- Flutter SDK installed and added to your PATH.

## 2. Install Firebase CLI
Run the following command in your terminal to install the Firebase CLI:
```bash
npm install -g firebase-tools
```

## 3. Login to Firebase
Login to your Firebase account via the terminal:
```bash
firebase login
```
This will open your browser to authenticate.

## 4. Install FlutterFire CLI
Run the following command to activate the FlutterFire CLI globally:
```bash
dart pub global activate flutterfire_cli
```
*Note: Make sure your system path includes the dart pub cache directory if the command is not found.*

## 5. Initialize Firebase in Your Project
Navigate to the root of your Flutter project and run:
```bash
flutterfire configure
```
- Select the Firebase project you created in the Firebase console (or create a new one).
- Select the platforms you want to support (e.g., Android, iOS, Web).
- The CLI will automatically register your apps with Firebase and generate a `firebase_options.dart` file in your `lib` directory.

## 6. Update `main.dart`
After configuring Firebase, update your `main.dart` to use the generated options file. 

Import the generated file:
```dart
import 'firebase_options.dart';
```

And update the initialization code:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

## 7. Enable Authentication in Firebase Console
- Go to the [Firebase Console](https://console.firebase.google.com/).
- Select your project.
- In the left sidebar, click on **Authentication**.
- Go to the **Sign-in method** tab.
- Click on **Email/Password** and enable it.
- Save your changes.

## 8. Run the Application
Now you can run your app on an Android emulator, iOS simulator, or a real device:
```bash
flutter run
```

### iOS Specific Configuration (If needed)
If you encounter CocoaPods issues on iOS, navigate to the `ios` directory and update the pods:
```bash
cd ios
pod install --repo-update
cd ..
```
Make sure your iOS deployment target in `ios/Podfile` is set to at least `13.0` (required by modern Firebase packages).
