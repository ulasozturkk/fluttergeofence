# fluttergeofence

This application is developed to track the user's real-time location and display it on the map with flutter_geofence package.
(it's only sat up on iOS)
## Features

- Real-time location tracking
- Integration with Google Maps
- Listening to location changes
- Displaying location on the map with markers

## Usage

1. When you launch the application, it will initially show the San Francisco area on the map.
2. The app will request user permission to access location information and display it on the map.
3. The location information on the map will be continuously updated and shown to the user.

## Installation

1. **Flutter Installation**: Follow the steps on the [official documentation](https://flutter.dev/docs/get-started/install) to install Flutter.
2. **Installing Dependencies**: Open the terminal in your project folder and run the `flutter pub get` command to install dependencies.
3. **Setting up API Keys**: Since Google Maps is used, make sure to add your API key to `android/app/src/main/AndroidManifest.xml`. Refer to [Google Maps Platform](https://cloud.google.com/maps-platform/) documentation for details.
4. Register and get your API Key, paste on AppDelegate.swift file

## Contributing

1. Fork it (https://github.com/yourusername/location-tracker-app/fork)
2. Create your feature branch (`git checkout -b feature/username`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/username`)
5. Create a new Pull Request

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
