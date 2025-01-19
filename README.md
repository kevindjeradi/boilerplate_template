
# Kevin Djeradi's Flutter Boilerplate Template

## Getting Started

This boilerplate template is designed to help you quickly set up a new Flutter project with customizable project name, organization, and app name.

## Features
- **Routing:** Managed with GetX routing.
- **State Management:** Utilizing GetX.
- **Dependency Injection:** Implemented via GetX.
- **Authentication:** Firebase Auth with phone, email, and Google sign-in.
- **Internationalization:** Using `flutter_localizations` and `intl`. French and english by default.
- **Theming:** Flexible theme system with light and dark modes and custom dynamic themes.
- **Local Storage:** Persistent secure storage for sensitive data and Shared preferences for app settings.
- **Error Handling:** Centralized error handling service.
- **Permissions:** Dynamic permission handling.
- **API Handling:** HTTP client with request caching mechanisms and timeout handling.
- **Connectivity:** Real-time connectivity status monitoring.

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

### Step 3: Rename the Project

Use the rename package to set your app's name, package name, and bundle identifier:

```bash
dart run rename setAppName --targets ios,android,macos,windows,linux --value "Your App Name"
dart run rename setBundleId --targets ios,android --value "com.yourcompany.yourapp"
```

These commands will:

- Change the app’s display name.
- Update the bundle identifier for iOS.
- Update the package name for Android.

### Step 4: Move the Project

Now that you have renamed the project, you can move the content of the boilerplate template to your new project.

### Step 5: Firebase Setup

1. **Create a New Firebase Project:**
   - Go to the [Firebase Console](https://console.firebase.google.com) and create a new project.

2. **Enable Authentication Methods:**
   - **Email/Password**
   - **Phone Number**
   - **Google Sign-In**

3. **Enable Firestore Database:**
   - In the Firebase Console, navigate to Firestore and create a new database.

4. **Enable Crashlytics:**
   - Navigate to Crashlytics in the Firebase Console and enable it for your project.

5. **Enable Push Notifications:**
   - Navigate to Cloud Messaging in the Firebase Console and enable it for your project.

6. **Add Your App to Firebase Project:**
   ```bash
   flutter pub global activate flutterfire_cli
   flutterfire configure
   ```
   This command will generate the necessary Firebase configuration files for your project.

7. **Update Google Sign-In Configuration in Firebase Console:**
   - Ensure that the OAuth client IDs are correctly set up for both Android and iOS.

8. **Configure SHA Certificates:**
   - Add your app's SHA-1 and SHA-256 keys to the Firebase Console under **Project Settings > Your Apps > Android**.

### Step 6: Environment Variables

Create a `.env` file in the root of the project and add the following variables:

```bash
GOOGLE_CLIENT_ID=your_google_client_id
```

### Step 7: Configure Platforms

#### For iOS:

1. **Configure URL Schemes:**
   - Open `ios/Runner.xcworkspace` in Xcode.
   - Select the `Runner` project in the Project Navigator.
   - Go to **Runner > Info > URL Types**.
   - Click the **+** button and add the necessary URL schemes provided in the `GoogleService-Info.plist`.
   - Typically, you'll need to add the REVERSED_CLIENT_ID found in the plist.

2. **Enable Push Notifications (APNs Configuration):**
   - **Register for APNs:**
     - In the Apple Developer Portal, register your app for push notifications.
   - **Upload APNs Authentication Key to Firebase:**
     - In the Firebase Console, navigate to **Project Settings > Cloud Messaging**.
     - Upload your APNs authentication key.
   - **Enable Push Notifications Capability:**
     - In Xcode, go to **Runner > Signing & Capabilities**.
     - Click the **+ Capability** button and add **Push Notifications** and **Background Modes** with the **Remote notifications** option checked.

## After running flutter clean don't forget to run flutter gen-l10n to generate the localizations files.
