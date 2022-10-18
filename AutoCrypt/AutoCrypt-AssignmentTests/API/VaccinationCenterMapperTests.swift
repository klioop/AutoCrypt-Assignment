//
//  VaccinationCenterMapperTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/18.
//

import XCTest
import AutoCrypt_Assignment

class VaccinationCenterMapperTests: XCTestCase {
    
    func test_map_deliversInvalidErrorOnNon200HTTPResponse() throws {
        let samples = [201, 250, 299, 300, 401, 500]
        
        try samples.enumerated().forEach { index, code in
            let response = httpURLResponse(with: code)
            let data = anyData()
            XCTAssertThrowsError(try VaccinationCenterMapper.map(data, from: response))
        }
    }
}
