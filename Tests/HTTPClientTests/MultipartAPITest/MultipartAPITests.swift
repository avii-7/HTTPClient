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
                fileName: "StreetVendorWithFlowers.jpg",
                contentType: "image/jpeg",
                data: data
            )
            let resposne: MultipartAPIResponse = try await sut.hitMultipart(httpRequest: MultipartHTTPRequest.uploadFile, multipartFormData: multipartFormData)
            print(resposne)
        }
        else {
            XCTFail("Resource file cannot found.")
        }
    }
}
