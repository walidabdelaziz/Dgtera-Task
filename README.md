# Dgtera - iOS

The Cashier Screen app is designed to facilitate the cashier's tasks, providing a user-friendly interface for managing products, creating orders, and processing payments. This README file provides an overview of the app's features and the technologies used in its development.

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5+

## Installation

- Clone the repository.
- Open Dgtera Task.xcworkspace.
- Build and run the project on your simulator or device.

## Technologies Used

### Asynchronous Programming

- Utilizes asynchronous programming techniques to handle network requests and database operations efficiently.
- Makes use of async and await keywords in Swift for asynchronous operations.

### MVVM Architecture

- Adopts the Model-View-ViewModel (MVVM) architecture pattern for clear separation of concerns and maintainability.
- Divides the app's components into models, views, and view models, facilitating easier testing and code organization.

### Alamofire with Async/Await
- Integrates Alamofire, a popular networking library for Swift, to handle HTTP requests.
- Leverages async and await features in Swift 5.5 to write asynchronous code in a more readable and synchronous-like manner.

### SDWebImage for Image Loading

- Incorporates SDWebImage library to efficiently load and cache images from URLs.
- Enhances the app's performance by reducing image loading times and optimizing memory usage.

### SQLite Database

- Implements SQLite database for local storage of product data.
- Enables seamless offline access to product information and order management.
- Syncs data with the server to ensure consistency between local and remote data sources.

## Features

- [x] Displays a list of available products for sale.
- [x] Allows users to browse products and view details such as name, price, and images.
- [x] Supports adding products to the order.
- [x] Utilizes SQLite database to store product data locally for offline access.
- [x] Enables users to continue using the app even without an internet connection.
- [x] Provides functionality for completing the order and processing payments.



