//
//  RemoteAPIEndToEndTests.swift
//  RemoteAPIEndToEndTests
//
//  Created by klioop on 2022/10/16.
//

import XCTest
import AutoCrypt_Assignment

class RemoteAPIEndToEndTests: XCTestCase {

    func test_EndToEndServerTest_matchesItemsCountLoadedFromTheSever() {
        switch getCenterResult() {
        case let .success(centers):
            XCTAssertEqual(centers.count, 10)
            
        default:
            XCTFail("API 통신이 성공해야 하지만 실패함")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> RemoteVaccinationCentersLoader {
        let baseURL = URL(string: "https://api.odcloud.kr/api")!
        let url = VaccinationCenterListEndPoint.get.url(with: baseURL)
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
