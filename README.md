# 🌊 Ocean Learn Admin App

A Flutter-based **admin dashboard application** for managing courses, lessons, subscriptions, and user accounts within the **Ocean Learn** online learning ecosystem.

This project is part of the Ocean Learn ecosystem, providing an admin interface to monitor, edit, and manage platform content such as lessons, payments, and users.

---

## 🧭 Overview

The **Ocean Learn Admin App** allows platform administrators and staff to:

- Manage courses and lesson details
- View and edit QR code attendance data
- Handle user subscriptions and payments
- Display and verify payment proof (for transfer-based payments)
- Manage admin login and session states securely
- Access detailed course and invoice information

The app integrates with the Ocean Learn backend via RESTful APIs.

---

## 🧩 Tech Stack

| Layer | Technology |
|:------|:------------|
| Framework | [Flutter](https://flutter.dev) |
| Language | Dart |
| State Management | [GetX](https://pub.dev/packages/get) |
| Networking | `http` |
| Local Storage | `get_storage` |
| Image Caching | `cached_network_image` |
| QR Display | `qr_flutter` |
| Auth Session | Custom token handler with auto logout on 401 |
| UI Design | Material 3 + Google Fonts + SVG icons |

---

## 📁 Project Structure
```
admin_ocean_learn2/
├── lib/
│ ├── controllers/ # Business logic using GetX
│ ├── models/ # Data models (CourseModel, SubscriptionModel, etc.)
│ ├── pages/ # UI pages (Dashboard, Invoice, Course Detail, etc.)
│ ├── services/ # API service classes
│ ├── utils/ # Helper utilities (token checker, colors, etc.)
│ ├── widgets/ # Reusable UI components
│ └── main.dart # App entry point
│
├── assets/
│ ├── images/ # App images (logo, backgrounds, etc.)
│ └── svg/ # SVG icons for UI
│
├── pubspec.yaml # Flutter dependencies
├── android/ # Android-specific configuration
├── ios/ # iOS-specific configuration
└── build/ # Generated build output (excluded from Git)
```
---

## ⚙️ Key Features

### 🔐 Authentication
- Secure admin login with token-based session
- Automatic token expiration handling (`ApiUtils.checkForTokenExpiration`)
- Auto logout and alert when unauthorized (401) response detected

### 📚 Course Management
- Create, edit, and view course details (`AddCoursePage`, `EditCoursePage`, `CourseDetailPage`)
- Generate and display QR codes for course attendance
- Track QR code expiration time

### 💳 Subscription & Payment
- View detailed subscription information (`InvoicePage`)
- Support for multiple payment methods (cash & transfer)
- Display uploaded payment proof images
- Admin confirmation for cash payments

### 🧾 Invoice Handling
- Detailed invoice with user info (name, email, payment method)
- Dynamic messages based on payment type
- Image preview with `CachedNetworkImage`

---

## 🧠 Controllers Overview

| Controller | Purpose |
|-------------|----------|
| `LoginController` | Handles authentication, session storage, logout |
| `DashboardController` | Loads user dashboard data |
| `PaymentController` | Manages subscription and invoice display |
| `InvoiceController` | Handles invoice logic and proof image display |
| `CourseController` | Fetches, adds, and edits course data |

---

## 🧰 API Integration

All services use a RESTful API system with token-based authentication.

### Example Services:
- `LoginService`
- `CourseService`
- `SubscriptionService`

Each service includes:
- HTTP requests via `http` package  
- Token validation via `ApiUtils`  
- Error handling for 401 → triggers auto logout  

---

## 🧑‍💻 Development Guide

### 🔹 Requirements
- Flutter SDK (≥ 3.0)
- Dart SDK
- Android Studio / VS Code
- Device/emulator (Android or iOS)
- Ocean Learn backend API credentials

### 🔹 Run the App

```bash
flutter pub get
flutter run

