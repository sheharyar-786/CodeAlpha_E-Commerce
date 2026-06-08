# CodeAlpha E-Commerce Application

This is an advanced mobile-only cross-platform e-commerce application built with Flutter, Firebase, and Stripe. It supports both buying and selling of products securely.

## Repository Structure

- `/frontend` - Flutter mobile application (buyer & seller flows).
- `/backend` - Cloud Functions & database configurations (coming soon).

## Key Features

1. **User Authentication**: Secure signup and login using Firebase Auth.
2. **Product Catalog & Search**: Advanced querying, filtering, and responsive search results.
3. **Secure Checkout & Payments**: Integration of Stripe/Razorpay SDKs for secure payment processing.
4. **Order History & Real-Time Tracking**: Lifecycle tracking of orders (Pending -> Processing -> Shipped -> Delivered).
5. **Seller Dashboard**: Real-time sales metrics, inventory management, and new product publishing.

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK
- Android Studio / VS Code (with Flutter extensions)

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Connect your Firebase project by placing:
   - `android/app/google-services.json` (for Android)
   - `ios/Runner/GoogleService-Info.plist` (for iOS)
4. Run the app:
   ```bash
   flutter run
   ```

## Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: BLoC (`flutter_bloc`)
- **Backend & DB**: Firebase Auth, Firestore Database, Firebase Storage
- **Payments**: Stripe / Razorpay SDK
