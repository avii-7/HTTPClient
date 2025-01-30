# HTTPClient  

**HTTPClient** is a Swift package designed to simplify making HTTP requests. It provides a quick way to manage a group of HTTP API requests in your Swift applications.  

## Components  

1. **HTTPRequest**:  
   A protocol that you implement to define the URLs, HTTP methods, request body, headers, etc. Use an `enum` to represent a group of APIs, with each case corresponding to a specific endpoint. Customize the request details for each case accordingly.  

2. **HTTPClient**:  
   A client class that interacts with `URLSession` to execute requests. Its methods accept a type conforming to the `HTTPRequest` protocol, extract the necessary details from this protocol, and create a `URLRequest` for making HTTP calls.  

3. **NetworkError**:  
   Starting from Swift 6.0, Swift allows you to throw specific errors instead of the generic `Error`. `NetworkError` is the specific error thrown by all the methods in `HTTPClient`. This feature enables consumers to handle errors more precisely and take actions based on the type of error encountered.  

## Usage  

### Defining API Requests Using `HTTPRequest`  

The `HTTPRequest` protocol allows you to organize your API requests in an `enum`, ensuring a structured and type-safe approach.  

### Example: `CommentHTTPRequest`  

Below is an example of how to define an API for managing comments using `HTTPRequest`:  

```swift
enum CommentHTTPRequest: HTTPRequest {
    
    case all
    case add(body: CommentAddBody)
    case delete(commentId: Int)
    
    var endPoint: String {
        switch self {
        case .all: "comments"
        case .add: "comments/add"
        case .delete(let commentId): "comments/\(commentId)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .all: .get
        case .add: .post
        case .delete: .delete
        }
    }
    
    var body: Encodable? {
        if case .add(let body) = self {
            return body
        }
        return nil
    }

    var baseURL: URL {
         URL(string: "https://dummyjson.com/")!
    }
}
```

### To perform API requests using `HTTPClient`:  

```swift
let httpClient = HTTPClient()
let allCommentsResponse: CommentsResponse = try await httpClient.hit(httpRequest: CommentHTTPRequest.all)
try await httpClient.hit(httpRequest: CommentHTTPRequest.delete(commnetId: 1))
```

## Contributing  

Contributions are welcome! If you have ideas to improve the library, fork the repository and submit a pull request with your enhancements.  

---  
This project is licensed under the [LICENSE](https://github.com/avii-7/HTTPClient/blob/main/LICENSE).  
