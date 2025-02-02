//
//  MultipartAPITests.swift
//  HTTPClient
//
//  Created by Arun on 27/01/25.
//

import XCTest
import Foundation
@testable import HTTPClient

final class MultipartAPITests: XCTestCase {

    private var sut: HTTPClient!
    
    override func setUp() {
        sut = HTTPClient()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testUploadTest() async throws {
        if let resourceURL = Bundle.module.url(forResource: "StreetVendorWithFlowers", withExtension: "jpg") {
            let data = try Data(contentsOf: resourceURL)
            
            var multipartFormData = MultipartFormData()
            multipartFormData.addField(
                name: "file",
                fileName: resourceURL.lastPathComponent,
                mimeType: "image/jpeg",
                data: data
            )
            let multipartResponse: MultipartAPIResponse = try await sut.execute(httpRequest: MultipartHTTPRequest.uploadFile, multipartFormData: multipartFormData)
            
            XCTAssertEqual(multipartResponse.originalname, resourceURL.lastPathComponent)
            XCTAssertFalse(multipartResponse.filename.isEmpty)

            if URL(string: multipartResponse.location) == nil {
                XCTFail("URL should not be nil")
            }
        }
        else {
            XCTFail("Resource file cannot found.")
        }
    }
}
