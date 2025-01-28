# HTTPClient

**HTTPClient** is a Swift package designed to simplify making HTTP requests. It provides an quick way to manage a group of HTTP API requests in your Swift applications.

## Components

1. **HTTPRequest**:  
   A protocol that you implement to define the URLs, HTTP methods, request body, headers etc. Use an `enum` to represent a group of APIs, with each case corresponding to a specific endpoint. Customize the request details for each case accordingly.

2. **HTTPClient**:  
   A client class that interfaces with `URLSession` to execute requests. Its methods accepts a type conforming to the `HTTPRequest` protocol, extracts the necessary details, and creates a `URLRequest` for making HTTP calls.

3. **NetworkError**:  
   Starting from Swift 6.0, Swift allows you to throw specific errors instead of the generic any Error. NetworkError is the specific error thrown by all the methods in HTTPClient. This feature enables consumers to handle errors more precisely and take actions based on the type of error encountered.

## Usage

To understand how to use the package, refer to the provided test cases in the repository.

## Contributing

Contributions are welcome! If you have ideas to improve the library, fork the repository and submit a pull request with your enhancements.

---
This project is licensed under the [https://github.com/avii-7/HTTPClient/blob/main/LICENSE](# HTTPClient

**HTTPClient** is a Swift package designed to simplify making HTTP requests. It provides an quick way to manage a group of HTTP API requests in your Swift applications.

## Components

1. **HTTPRequest**:  
   A protocol that you implement to define the URLs, HTTP methods, request body, headers etc. Use an `enum` to represent a group of APIs, with each case corresponding to a specific endpoint. Customize the request details for each case accordingly.

2. **HTTPClient**:  
   A client class that interfaces with `URLSession` to execute requests. Its methods accepts a type conforming to the `HTTPRequest` protocol, extracts the necessary details, and creates a `URLRequest` for making HTTP calls.

3. **NetworkError**:  
   Starting from Swift 6.0, Swift allows you to throw specific errors instead of the generic any Error. NetworkError is the specific error thrown by all the methods in HTTPClient. This feature enables consumers to handle errors more precisely and take actions based on the type of error encountered.

## Usage

To understand how to use the package, refer to the provided test cases in the repository.

## Contributing

Contributions are welcome! If you have ideas to improve the library, fork the repository and submit a pull request with your enhancements.

---
This project is licensed under the [LICENSE](https://github.com/avii-7/HTTPClient/blob/main/LICENSE)
