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
            XCTFail("예방접종센터 리스트를 로드 하는 API 통신은 성공해야 한다")
        }
    }
    
    // MARK: - Helpers
    
    private func getCenterResult() -> RemoteVaccinationCentersLoader.LoadResult {
        let baseURL = URL(string: "https://api.odcloud.kr/api")!
        let url = VaccinationCenterListEndPoint.get().url(with: baseURL)
        let client = URLSessionHTTPClient()
        let exp = expectation(description: "wait for load completion")
        
        var receivedResult: Result<[VaccinationCenter], Error>!
        client
            .get(from: url) { result in
                receivedResult = result.flatMap { (data, response) in
                    do {
                        let centers = try VaccinationCenterMapper.map(data, from: response)
                        return .success(centers)
                    } catch {
                        return .failure(error)
                    }
                }
                exp.fulfill()
            }
        wait(for: [exp], timeout: 10.0)
        return receivedResult
    }
}
