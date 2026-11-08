# SetVault

> **Your Workouts. Your Progress. Your Data.**

A modern, high-performance fitness logging application built with Flutter, Provider, Firebase Cloud Firestore, and a signature Deep Midnight Navy glassmorphic design system.

---

## 🏋️ Features

### Core Workout Logger
- **Dynamic Session Tracker**: Live stopwatch timer with pause, resume, and background accuracy.
- **Unlimited Sets**: Add, edit, reorder, and remove sets on the fly.
- **Advanced Set Types**:
  - `Normal` (standard work sets)
  - `Warm-up` (marked with W)
  - `Drop Set` (marked with D)
  - `Failure` (marked with F)
- **Reps in Reserve (RIR)**: Track intensity per set.
- **Weighted & Bodyweight**: Full support for weighted, pure bodyweight, and weighted-bodyweight exercises.
- **Dynamic Last-Time & Carry-Over**: Automatically detects and presents your previous performance (e.g. *40 kg × 10 reps*) for each exercise.
- **Reliable Autosaving**: Active workout state is continuously saved locally (`WorkoutAutosaveService`), preventing data loss if the app is killed.

### Built-in Exercise Catalogue
- 8 Complete Muscle Groups: **Chest**, **Back**, **Shoulders**, **Biceps**, **Triceps**, **Legs**, **Core**, and **Full Body**.
- Custom exercise creation, editing, and deletion.
- Search and filtering with real-time query updates.

### Workout Routines
- Build structured routines (Push, Pull, Legs, Upper, Lower, etc.).
- Pre-configure planned exercises, target weights, target reps, and set counts.
- One-tap start: launch active workouts directly from routines.

### History & Progress Analytics
- Interactive **Month Calendar** showing workout days.
- Real-time **Weekly Volume** spline chart powered by `fl_chart`.
- **Weight Progression** curve and dynamic **Personal Records (PR)** calculated from actual workout data.

### Offline-First Architecture & Synchronization
- Seamless offline usage without internet.
- Firestore offline persistence with unlimited cache.
- Visual sync status indicators: `Saved Locally`, `Waiting for Sync`, `Synced`, `Sync Failed`.

### Authentication & Account Security
- **Frictionless Anonymous Guest Mode**: Athletes can start logging workouts immediately without forced sign-up.
- **Safe Account Linking**: Upgrades anonymous accounts to permanent Email/Password credentials without data loss or duplicate accounts.
- **Role-Based Access Control (RBAC)**: Administrator Dashboard access verified through Firebase Custom Claims.

### JSON Backup & Restore
- Versioned (`v1.0`) backup export for all workouts, routines, custom exercises, and settings.
- Validated JSON import with schema checks, type checking, and duplicate prevention.

---

## 🛠️ Technology Stack
- **Framework**: Flutter (Dart 3.13+)
- **State Management**: Provider
- **Backend & Database**: Firebase Cloud Firestore & Firebase Authentication
- **Offline Persistence**: Firestore Cache + SharedPreferences
- **Charts**: fl_chart
- **Typography**: Google Fonts (Inter)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.47+
- Android Studio / Android SDK

### Installation
```bash
git clone https://github.com/malikbabaralicase/project-setvault.git
cd project-setvault
flutter pub get
```

---

## 🔥 Firebase Configuration

SetVault is built with a dual-mode hybrid architecture:
1. **With Firebase Configured**: Automatically connects to Cloud Firestore and Firebase Auth with offline persistence.
2. **Without Firebase Configured (Local/Pre-setup)**: Gracefully runs in local offline-first mode with persistent local caching and memory stores.

### Connecting to Your Firebase Project:
1. Create a project in the [Firebase Console](https://console.firebase.google.com/).
2. Enable **Authentication** (Anonymous + Email/Password providers).
3. Enable **Cloud Firestore** and deploy `firestore.rules`.
4. Download your `google-services.json` and place it in:
   ```
   android/app/google-services.json
   ```
5. Alternatively, run FlutterFire CLI:
   ```bash
   flutterfire configure
   ```

---

## 🧪 Testing & Verification

Run the comprehensive test suite (18+ unit and widget tests covering all screens, data models, backup validation, and authentication):
```bash
flutter test
```

Run static code analysis:
```bash
flutter analyze
```

---

## 📱 Building the Android APK

Build a release APK:
```bash
flutter build apk --release
```

The compiled APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 👥 Project Owners
- **Malik Babar Ali**
- **Sadia Iqbal**

License: Proprietary. All rights reserved.
