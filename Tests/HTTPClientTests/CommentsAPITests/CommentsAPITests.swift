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
        let _: CommentsResponse = try await sut.hit(httpRequest: CommentHTTPRequest.all)
    }
    
    func testDeleteSuccess() async throws {
        try await sut.hit(httpRequest: CommentHTTPRequest.delete(commnetId: 1))
    }
    
    func testAddSuccess() async throws {
        let body = "This is awesome", postId = 3, userId = 5
        let postBody = CommentAddBody(body: body, postId: postId, userId: userId)
        let response: Comment = try await sut.hit(httpRequest: CommentHTTPRequest.add(body: postBody))
        
        XCTAssertEqual(response.body, body)
        XCTAssertEqual(response.postId, postId)
        XCTAssertEqual(response.user.id, userId)
    }
}
