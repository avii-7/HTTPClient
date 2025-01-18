import XCTest
@testable import HTTPClient

final class CommentsAPITests: XCTestCase {
    
    private var sut: HTTPClient!
    
    override func setUp() {
        sut = HTTPClient()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testResponseSuccess() async throws {
        let response: CommentsResponse = try await sut.hit(restRequest: CommentHTTPRequest.all)
        print(response.total)
    }
    
    func testDeleteSuccess() async throws {
        try await sut.hit(restRequest: CommentHTTPRequest.delete(commnetId: 1))
    }
    
    func testAddSuccess() async throws {
        let comment = CommentAddBody(body: "This is awesome", postId: 3, userId: 5)
        let response: Comment = try await sut.hit(restRequest: CommentHTTPRequest.add(body: comment))
        print(response)
    }
}
