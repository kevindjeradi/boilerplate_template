# Kevin Djeradi's Flutter Boilerplate Template

## Getting Started

This boilerplate template is designed to help you quickly set up a new Flutter project with customizable project name, organization, and app name.

## Features
- **Routing:** Managed with GoRouter and Riverpod.
- **State Management:** Utilizing Riverpod 2.6.1 with modern patterns and code generation.
- **Dependency Injection:** Implemented via Riverpod providers.
- **Authentication:** Firebase Auth with phone, email, and Google sign-in.
- **Internationalization:** Using `flutter_localization` and `intl`. French and English by default.
- **Theming:** Flexible theme system with light and dark modes and custom dynamic themes.
- **Local Storage:** Persistent secure storage for sensitive data and Shared preferences for app settings.
- **Error Handling:** Centralized error handling service.
- **Permissions:** Dynamic permission handling.
- **API Handling:** HTTP client with request caching mechanisms and timeout handling.
- **Connectivity:** Real-time connectivity status monitoring.
- **Notifications:** Local and push notifications with Firebase Cloud Messaging.

## Setup Instructions

Follow these steps **in order** to set up your project:

### Step 1: Clone the Repository

First, clone the boilerplate repository to your local machine:

```bash
git clone path_to_your_repo
cd boilerplate_template
```

### Step 2: Install Dependencies

Run the following command to install the necessary dependencies:

```bash
flutter pub get
```

### Step 3: Generate Required Code

This project uses code generation for Riverpod, Freezed, and JSON serialization. Generate all required files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Note:** You'll need to run this command whenever you modify files with code generation annotations.

### Step 4: Generate Localizations

Generate localization files for multi-language support:

```bash
flutter gen-l10n
```

### Step 5: Rename the Project (Recommended)

**Important:** Do this BEFORE Firebase configuration to avoid having to reconfigure Firebase with the new bundle ID.

If you want to customize the app name and package name:

```bash
dart run rename setAppName --targets ios,android,macos,windows,linux --value "Your App Name"
dart run rename setBundleId --targets ios,android --value "com.yourcompany.yourapp"
```

These commands will:
- Change the app's display name
- Update the bundle identifier for iOS
- Update the package name for Android

### Step 6: Firebase Setup (Required for .env configuration)

⚠️ **Do this step AFTER renaming your project**

1. **Create a New Firebase Project:**
   - Go to the [Firebase Console](https://console.firebase.google.com) and create a new project.

2. **Add Your App to Firebase Project:**
   ```bash
   flutter pub global activate flutterfire_cli
   flutterfire configure
   ```
   - Select your Firebase project
   - Choose platforms (Android, iOS, Web)
   - **Use your NEW package name** (from Step 5) when prompted
   - This will generate `firebase_options.dart` and platform-specific config files

3. **Enable Authentication Methods:**
   - In Firebase Console, go to **Authentication > Sign-in method**
   - Enable **Email/Password**
   - Enable **Phone Number**
   - Enable **Google Sign-In**

4. **Configure Google Sign-In:**
   - In **Authentication > Sign-in method > Google**
   - Copy the **Web client ID** (you'll need this for the .env file)

5. **Enable Firestore Database:**
   - In the Firebase Console, navigate to **Firestore Database** and create a new database
   - Start in **test mode** (you can configure rules later)

6. **Enable Crashlytics:**
   - Navigate to **Crashlytics** in the Firebase Console and enable it

7. **Enable Push Notifications:**
   - Navigate to **Cloud Messaging** in the Firebase Console and enable it

8. **Configure SHA Certificates for Android:**
   - Get your SHA-1 and SHA-256 certificates:
     ```bash
     # For debug (development)
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     
     # On Windows
     keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
     ```
   - Add these certificates in Firebase Console under **Project Settings > Your Apps > Android**

### Step 7: Environment Variables

Create a `.env` file in the root of the project:

```bash
# On macOS/Linux
cp env.example .env

# On Windows
copy env.example .env
```

Then edit the `.env` file and add your Firebase Web Client ID (from Step 6.4):

```bash
GOOGLE_CLIENT_ID=your_google_web_client_id_from_firebase_console
```

**Example:**
```bash
GOOGLE_CLIENT_ID=123456789-abcdefghijklmnopqrstuvwxyz.apps.googleusercontent.com
```

### Step 8: Configure Native Splash Screen

**Before generating the splash screen, customize your logo:**

1. **Replace the logo image:**
   - Add your app logo as `assets/images/logo.png` (replacing the existing one)
   - **Important:** The splash screen will be clipped to a circle on the center of the screen
   - **App icon WITH background:** 960×960 pixels, and fit within a circle 640 pixels in diameter
   - **App icon WITHOUT background:** 1152×1152 pixels, and fit within a circle 768 pixels in diameter
   - Format: PNG with transparent background recommended

2. **Optional: Customize splash screen colors in `pubspec.yaml`:**
   ```yaml
   flutter_native_splash:
     color: "#FFFFFF"              # Light mode background color
     color_dark: "#1C1B1F"         # Dark mode background color
     image: assets/images/logo.png  # Your logo path
     image_dark: assets/images/logo.png  # Dark mode logo (can be different)
   ```

3. **Generate native splash screens:**
   ```bash
   dart run flutter_native_splash:create
   ```

This will use the configuration in `pubspec.yaml` to generate platform-specific splash screens for Android, iOS, and Web.

### Step 9: Platform-Specific Configuration

#### For Android:

✅ **No additional configuration needed** - The boilerplate includes a pre-configured `AndroidManifest.xml` with all necessary permissions.

#### For iOS (Required only if building for iOS):

The boilerplate includes a pre-configured `Info.plist`, but you need to configure Google Sign-In:

1. **Configure URL Schemes for Google Sign-In:**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select the `Runner` project in the Project Navigator
   - Go to **Runner > Info > URL Types**
   - Click the **+** button and add the `REVERSED_CLIENT_ID` from your `ios/Runner/GoogleService-Info.plist`

2. **Enable Push Notifications Capability (Optional):**
   - In Xcode, go to **Runner > Signing & Capabilities**
   - Click the **+ Capability** button and add:
     - **Push Notifications**
     - **Background Modes** with the **Remote notifications** option checked

### Step 10: Final Verification

1. **Clean and rebuild everything:**
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter gen-l10n
   ```

2. **Verify Firebase connection:**
   ```bash
   flutter run
   ```
   - The app should start without Firebase errors
   - Check the console for "✅ Firebase initialized" message

3. **Test key features:**
   - Email authentication should work
   - Google Sign-In should work (if configured)
   - Notifications should work
   - Settings should persist (language/theme changes)

### Step 11: Move to Your Project Directory (Optional)

Once everything is working, you can move the configured project to your desired location:

```bash
# Move the entire folder to your projects directory
mv boilerplate_template /path/to/your/projects/your_app_name
cd /path/to/your/projects/your_app_name
```

## Development Notes

### Architecture Overview

This boilerplate uses **Riverpod 2.6.1** for state management with the following modern architecture:

- **Providers:** Located in `lib/features/*/providers/` for dependency injection with code generation
- **Controllers:** Use Riverpod's modern patterns for state management
- **Services:** Business logic layer with interface-based design
- **States:** Immutable state classes using sealed classes and pattern matching

### Localization

After running `flutter clean`, don't forget to run `flutter gen-l10n` to generate the localizations files.

**Package used:** `flutter_localization: ^0.2.2` (not flutter_localizations)

### State Management Pattern

```dart
// Example of ConsumerWidget usage with actual project structure
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    
    return authState.when(
      authenticated: (userId) => HomeScreen(),
      unauthenticated: () => const AuthScreen(),
      loading: () => const CircularProgressIndicator(),
      initial: () => const LoadingScreen(),
      codeSent: (verificationId) => PhoneVerificationScreen(verificationId),
    );
  }
}
```

### API Usage Example

```dart
// Example of using the API controller
class ApiExampleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiStatus = ref.watch(apiControllerProvider);
    final isLoading = ref.watch(isApiLoadingProvider);
    
    return Column(
      children: [
        if (isLoading) const CircularProgressIndicator(),
        ElevatedButton(
          onPressed: () async {
            try {
              final response = await ref
                  .read(apiControllerProvider.notifier)
                  .get('https://api.example.com/data');
              // Handle response
            } catch (e) {
              // Handle error
            }
          },
          child: const Text('Make API Call'),
        ),
      ],
    );
  }
}
```

### Testing

The architecture supports easy testing with provider overrides:

```dart
testWidgets('My widget test', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(MockAuthService()),
      ],
      child: MaterialApp(home: MyWidget()),
    ),
  );
  
  // Your test assertions
});
```

### Code Generation

This project uses code generation for Riverpod providers. After making changes to providers, run:

```bash
dart run build_runner build
```

Or for watching changes during development:

```bash
dart run build_runner watch
```

### Development Workflow

When developing, you can run these commands in separate terminals:

```bash
# Terminal 1: Run the app
flutter run

# Terminal 2: Watch for code generation changes
dart run build_runner watch

# Terminal 3: Watch for localization changes (if needed)
flutter gen-l10n --watch
```

## Common Issues & Solutions

### Code Generation Issues
- **Problem:** `.g.dart` files not found
- **Solution:** Run `dart run build_runner build --delete-conflicting-outputs`

### Localization Issues
- **Problem:** AppLocalizations not found
- **Solution:** Run `flutter gen-l10n` after any changes to `.arb` files

### Firebase Issues
- **Problem:** Firebase not initialized
- **Solution:** Ensure `flutterfire configure` was run and files are in place

### Permission Issues
- **Problem:** Permissions not working on device
- **Solution:** Check that permissions are declared in platform-specific files

## Performance Tips

1. **Code Generation:** Use `--delete-conflicting-outputs` flag to avoid conflicts
2. **Build Runner:** Use `watch` mode during development for automatic regeneration
3. **Localization:** Only regenerate when `.arb` files change
4. **Hot Reload:** Most changes work with hot reload, but code generation requires restart
