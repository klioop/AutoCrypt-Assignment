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
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestsURLs, [])
    }
    
    func test_load_requestsLoadCentersFromAGivenURL() {
        let url = URL(string: "http://a-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestsURLs, [url])
    }
    
    private func makeSUT(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteVaccinationCentersLoader, client: ClientSpy) {
        let client = ClientSpy()
        let sut = RemoteVaccinationCentersLoader(url: url, client: client)
        
        return (sut, client)
    }
}
