//
//  TestHelpers.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/16.
//

import Foundation
import AutoCrypt_Assignment

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    Data("any data".utf8)
}

func anyNSError() -> NSError {
    NSError(domain: "a error", code: 0)
}

func uniqueCenter(id: Int = 0,
                          name: String = "a name",
                          facilityName: String = "a facility name",
                          address: String = "a address",
                          lat: String = "1.0",
                          lng: String = "1.0",
                          updatedAt: String = "2021-07-16 04:55:08"
) -> VaccinationCenter {
    let centerID = CenterID(id: id)
    return VaccinationCenter(id: centerID, name: name, facilityName: facilityName, address: address, lat: lat, lng: lng, updatedAt: updatedAt)
}