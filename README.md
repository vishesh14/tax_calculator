# Tax Calculator App

## Overview
The **Tax Calculator App** is a simple Flutter application that allows users to add items to a cart, calculate applicable taxes, and generate a receipt. The tax is calculated at a fixed rate of **10%** and rounded to the nearest 5 paise.

## Features
- Add items to the cart with **name, price, and quantity**.
- Automatically calculate tax for each item.
- Round tax values to the nearest 5 paise.
- Display a detailed receipt including total tax and total cost.
- Simple UI with text inputs and buttons.

## Installation
To run this Flutter app, ensure you have Flutter installed on your machine. Then, follow these steps:

### Prerequisites
- Flutter SDK ([Install Flutter](https://flutter.dev/docs/get-started/install))
- Dart SDK (included with Flutter)
- A code editor (VS Code, Android Studio, etc.)

### Steps to Run the App
```sh
# Clone the repository
https://github.com/your-repo/tax_calculator.git

# Navigate to the project directory
cd tax_calculator

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Project Structure
```
📦 tax_calculator
├── 📂 lib
│   ├── main.dart         # Main application file
│   ├── tax_calculator.dart # Tax calculation logic
├── 📂 test
│   ├── tax_calculator_test.dart # Unit tests
├── pubspec.yaml         # Flutter dependencies
├── README.md            # Project documentation
```

## Running Tests
To run unit tests, execute the following command:
```sh
flutter test
```

## Issues & Debugging
- Ensure that tax rounding calculations match expectations.
- Run `flutter doctor` to check for missing dependencies.
- Verify the expected tax and total cost calculations in test cases.

## Contribution
Contributions are welcome! Feel free to submit pull requests or report issues in the repository.

## License
This project is licensed under the MIT License.
