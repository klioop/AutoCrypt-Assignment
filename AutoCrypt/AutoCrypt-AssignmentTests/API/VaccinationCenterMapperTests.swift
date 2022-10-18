//
//  VaccinationCenterMapperTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/18.
//

import XCTest
import AutoCrypt_Assignment

class VaccinationCenterMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [201, 250, 299, 300, 401, 500]
        
        try samples.enumerated().forEach { index, code in
            let response = httpURLResponse(with: code)
            let data = anyData()
            XCTAssertThrowsError(try VaccinationCenterMapper.map(data, from: response))
        }
    }
    
    func test_map_throwsErrorOnInvalidDataOn200HTTPURLResponse() throws {
        let invalidData = Data("invalid".utf8)
        let response = httpURLResponse(with: 200)
        
        XCTAssertThrowsError(try VaccinationCenterMapper.map(invalidData, from: response))
    }
}
