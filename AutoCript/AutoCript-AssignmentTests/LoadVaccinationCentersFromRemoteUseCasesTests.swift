//
//  LoadVaccinationCentersFromRemoteUseCasesTests.swift
//  AutoCript-AssignmentTests
//
//  Created by klioop on 2022/10/16.
//

import XCTest

class RemoteVaccinationCentersLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class ClientSpy: HTTPClient {
    private(set) var requestsURLs = [URL]()
    
    func get(from url: URL) {
        requestsURLs.append(url)
    }
    
}

class LoadVaccinationCentersFromRemoteUseCasesTests: XCTestCase {
    
    func test_init_doesNotSendAnyMessage() {
        let client = ClientSpy()
        _ = RemoteVaccinationCentersLoader(url: URL(string: "http://any-url.com")!, client: client)
        
        XCTAssertEqual(client.requestsURLs, [])
    }
    
    func test_load_requestsLoadCentersFromAGivenURL() {
        let client = ClientSpy()
        let url = URL(string: "http://any-url.com")!
        let sut = RemoteVaccinationCentersLoader(url: url, client: client)

        sut.load()

        XCTAssertEqual(client.requestsURLs, [url])
    }
}
