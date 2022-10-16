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
        switch getCenterResult() {
        case let .success(centers):
            XCTAssertEqual(centers.count, 10)
            
        default: break
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> RemoteVaccinationCentersLoader {
        let url = URL(string: "https://api.odcloud.kr/api/15077586/v1/centers?serviceKey=G%2BNU43EDZdI5nseI67t2beD9Lgaecfc2DFnmHI6419KLzpekWjxDnzhvMajqKVv96rluIxoKv5KSjiZ5%2FICxaw%3D%3D")!
        let client = URLSessionHTTPClient()
        let sut = RemoteVaccinationCentersLoader(url: url, client: client)
        trackMemoryLeak(client, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    private func getCenterResult() -> RemoteVaccinationCentersLoader.LoadResult {
        let sut = makeSUT()
        let exp = expectation(description: "wait for load completion")
        
        var result: RemoteVaccinationCentersLoader.LoadResult!
        sut.load { receivedResult in
            result = receivedResult
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
        return result
    }
}
