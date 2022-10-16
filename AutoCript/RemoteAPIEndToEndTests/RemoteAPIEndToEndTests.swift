//
//  RemoteAPIEndToEndTests.swift
//  RemoteAPIEndToEndTests
//
//  Created by klioop on 2022/10/16.
//

import XCTest
import AutoCript_Assignment

class RemoteAPIEndToEndTests: XCTestCase {

    func test_EndToEndServerTest_matchesItemsCountLoadedFromTheSever() {
        let url = URL(string: "https://api.odcloud.kr/api/15077586/v1/centers?serviceKey=G%2BNU43EDZdI5nseI67t2beD9Lgaecfc2DFnmHI6419KLzpekWjxDnzhvMajqKVv96rluIxoKv5KSjiZ5%2FICxaw%3D%3D")!
        let client = URLSessionHTTPClient()
        let sut = RemoteVaccinationCentersLoader(url: url, client: client)
        let exp = expectation(description: "wait for load completion")
        
        sut.load { result in
            let centers = try? result.get()
            XCTAssertEqual(centers?.count, 10)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
    }
}
