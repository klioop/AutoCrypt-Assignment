//
//  LoadVaccinationCentersFromRemoteUseCasesTests.swift
//  AutoCript-AssignmentTests
//
//  Created by klioop on 2022/10/16.
//

import XCTest

class RemoteVaccinationCentersLoader {
    let url: URL
    let loader: LoaderSpy
    
    init(url: URL, loader: LoaderSpy) {
        self.url = url
        self.loader = loader
    }
}

class LoaderSpy {
    private(set) var requestsURLs = [URL]()
}

class LoadVaccinationCentersFromRemoteUseCasesTests: XCTestCase {
    
    func test_init_doesNotSendAnyMessage() {
        let loader = LoaderSpy()
        _ = RemoteVaccinationCentersLoader(url: URL(string: "http://any-url.com")!, loader: loader)
        
        XCTAssertEqual(loader.requestsURLs, [])
    }
}
