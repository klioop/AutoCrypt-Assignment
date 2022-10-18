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
    
    func test_map_throwsErrorOnInvalidDataWith200HTTPResponse() throws {
        let invalidData = Data("invalid".utf8)
        let response = httpURLResponse(with: 200)
        
        XCTAssertThrowsError(try VaccinationCenterMapper.map(invalidData, from: response))
    }
    
    func test_map_doesNotThrowErrorOnValidDataWith200HTTPResponse() throws {
        let item = makeItem(updatedAt: "2012-12-12")
        let validData = makeJSON([item.item])
        let response = httpURLResponse(with: 200)
        
        XCTAssertNoThrow(try VaccinationCenterMapper.map(validData, from: response))
    }
    
    // MARK: - Helpers
    
    private func makeItem(id: Int = 0,
                          name: String = "a name",
                          facilityName: String = "a facility name",
                          address: String = "a address",
                          lat: String = "1.0",
                          lng: String = "1.0",
                          updatedAt: String)
    -> (model: VaccinationCenter, item: [String: Any]) {
        let model = uniqueCenter(id: id, name: name, facilityName: facilityName, address: address, lat: lat, lng: lng, updatedAt: updatedAt)
        let item: [String: Any] = [
            "id": id,
            "centerName": name,
            "facilityName": facilityName,
            "address": address,
            "lat": "\(lat)",
            "lng": "\(lng)",
            "updatedAt": updatedAt,
        ].compactMapValues { $0 }
        
        return (model, item)
    }
    
    private func makeJSON(_ items: [[String: Any]]) -> Data {
        let json = [
            "data": items
        ]
        
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
