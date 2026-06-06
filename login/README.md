# Firebase Authentication - Home Screen

A secure, minimalist Flutter welcome screen that serves as the landing destination after a user successfully authenticates via Firebase.

---

## 👤 Developer Profile

* **Name:** Prajakta Sambare
* **Batch:** ShadowFox June B1 (Android App Development)

---

## 🚀 Getting Started

The main code file for this UI component is located at:
📂 **`lib/main.dart`** *(or your specific file path inside `lib/`)*

To run this Flutter project, ensure your environment is set up and execute:
```bash
flutter pub get
flutter run

Core Structure & Implementation
This specific UI handles the post-login state using Flutter's core widget architecture:

1. UI Layout & Design
Scaffold: Acts as the main visual canvas, providing a standardized AppBar with a centered title.

Card & Padding: Used to create an elevated, modern material card layout with rounded corners (16.0) to containerize the content.

Column (mainAxisSize: MainAxisSize.min): Vertically aligns the welcome elements tightly inside the card without wasting screen space.

Material Icons: Displays a distinctive blue home icon (Icons.home) to instantly orient the user.

2. Logic & Navigation Integration
StatelessWidget: Since this screen primarily displays a fixed "Success" state without dynamic data shifting on the page itself, a stateless widget keeps performance optimal.

Session Management (Logout): The ElevatedButton triggers Navigator.of(context).pop();. In a full Firebase setup, this is where your FirebaseAuth.instance.signOut() method integrates to securely end the user's active session and return them to the authentication portal.

🔧 Prerequisites (Firebase Setup)
To fully connect this page to a live backend, ensure your project includes:

A registered app instance on the Firebase Console.

The firebase_core and firebase_auth dependencies added to your pubspec.yaml.

Initialization handled inside your main() function:

Dart
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
