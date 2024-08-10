# Safe Ship

Safe Ship is a delivery app developed using Flutter, designed to ensure secure and efficient delivery services. The app incorporates essential features such as age verification, location tracking, and email validation, leveraging Firebase for backend services.

## Features

- **Firebase Authentication**: Secure user authentication using Firebase, ensuring that only authorized users can access the app.
  
- **Email Validation**: Ensures that only valid and verified email addresses are used during registration, adding an extra layer of security.
  
- **Age Verification**: A feature that verifies the age of users, essential for deliveries requiring age restrictions.
  
- **Product Data Management**: Product details are stored and managed in Firebase Database, allowing real-time updates and seamless data management.
  
- **Location Tracking**:
  - **Polyline Implementation**: Displays the delivery route on the map, ensuring clear and precise navigation.
  - **Custom Markers**: Different markers for the source, destination, and current locations enhance the user experience.
  - **Live Location Tracking**: Real-time tracking of the delivery person’s location for accurate and timely deliveries.

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/jagadish-2/safe_ship.git
    ```
2. Navigate to the project directory:
    ```bash
    cd safe_ship
    ```
3. Install dependencies:
    ```bash
    flutter pub get
    ```
4. Set up Firebase:
   - Add your `google-services.json` file for Android.
   - Add your `GoogleService-Info.plist` file for iOS.
   - Ensure that your Firebase project is properly configured for Authentication, Firestore, and Realtime Database.
  
5. Run the app:
    ```bash
    flutter run
    ```

## Usage

- **Login/Signup**: Users can sign up and log in using their email addresses, with Firebase handling authentication and email validation.
  
- **View Products**: Product details are fetched from the Firebase database and displayed within the app.
  
- **Age Verification**: During registration or before making specific purchases, users will undergo age verification.
  
- **Track Delivery**: Users can track their delivery with real-time location updates, polyline routes, and custom markers showing the delivery progress.

## Dependencies

- `firebase_auth`
- `firebase_core`
- `cloud_firestore`
- `firebase_database`
- `google_maps_flutter`
- `location`
- `polyline_do`
- `Riverpod` 
- `flutter_polyline_points`

