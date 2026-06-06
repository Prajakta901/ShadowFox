# Flutter Calculator App

A sleek, intuitive, and responsive Calculator Application built using Flutter. This project covers the fundamentals of UI/UX designing and state-driven logic integration in Android App Development.

---

## 👤 Developer Profile

* **Name:** Prajakta Sambare
* **Batch:** ShadowFox June B1 (Android App Development)

---

## 🚀 Getting Started

The entry point of this application is located at:
📂 **`lib/main.dart`**

To run this project locally, ensure you have Flutter installed, then execute:
```bash
flutter pub get
flutter run


Core App Structure
To build a robust calculator app, the development process is divided into two primary phases: UI Designing and Logic Integration.

1. UI Designing (The Presentation Layer)
The user interface is built using a clean grid-based layout to mimic a physical calculator.

Main Canvas (Scaffold): Provides the basic visual page structure, including a dark/light theme background.

Display Screen: A section at the top using Column and Text widgets to show the current input and the calculated result. It uses alignment properties to keep text right-aligned.

Button Grid: Utilizes GridView.builder or nested Row and Column widgets to cleanly arrange the buttons.

Custom Button Component: A reusable Widget created to maintain consistency for numbers, operators (+, -, *, /), and action keys (C, =).

2. Logic Integration (The Brains)
The logic ensures that button presses translate into accurate mathematical calculations.

State Management: Uses StatefulWidget (and functions like setState()) to dynamically update the display screen whenever a user presses a button.

Input Parsing: Strings are concatenated as the user types (e.g., pressing 5 then + then 3 creates the string "5+3").

Expression Evaluation: * A logic function parses the expression string when the = button is pressed.

You can use packages like math_expressions to safely evaluate the string and return the correct mathematical result.

Error Handling: Implements checks to prevent application crashes during invalid operations (e.g., division by zero or consecutive operators like ++).

🛠️ Tech Stack & Tools
Framework: Flutter

Language: Dart

IDE: VS Code / Android Studio