//
//  LoadVaccinationCentersFromRemoteUseCasesTests.swift
//  AutoCript-AssignmentTests
//
//  Created by klioop on 2022/10/16.
//

import XCTest

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}


class RemoteVaccinationCentersLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    typealias LoadResult = Result<Void, Error>
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    func load(completion: @escaping (LoadResult) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((_, response)):
                if response.statusCode != 200 {
                    completion(.failure(Error.invalidData))
                }
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
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

        sut.load() { _ in }

        XCTAssertEqual(client.requestsURLs, [url])
    }
    
    func test_load_deliversErrorOnFails() {
        let (sut, client) = makeSUT()
        let exp = expectation(description: "wait for load completion")
        
        var receivedError: Error?
        sut.load { result in
            if case let .failure(error) = result {
                receivedError = error
            }
            exp.fulfill()
        }
        
        client.loadCompletion(with: NSError(domain: "a error", code: 0))
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNotNil(receivedError)
    }
    
    func test_load_deliversErrorOnNon200HTTPResponseStatusCode() {
        let (sut, client) = makeSUT()
        let exp = expectation(description: "wait for load completion")
        
        var receivedError: Error?
        sut.load { result in
            if case let .failure(error) = result {
                receivedError = error
            }
            exp.fulfill()
        }
        
        client.loadCompletion(with: anyData(), from: anyHTTURLResponse(with: 400))
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNotNil(receivedError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteVaccinationCentersLoader, client: ClientSpy) {
        let client = ClientSpy()
        let sut = RemoteVaccinationCentersLoader(url: url, client: client)
        trackMemoryLeak(client, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return (sut, client)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    private func anyData() -> Data {
        Data("any data".utf8)
    }
    
    private func anyHTTURLResponse(with code: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: code, httpVersion: nil, headerFields: nil)!
    }
    
    private func trackMemoryLeak(_ instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "테스트가 끝나면 \(String(describing: instance)) 는 메모리에서 해제되어야 함. 그렇지 않으면 메모리 릭을 암시", file: file, line: line)
        }
    }
    
    private class ClientSpy: HTTPClient {
        private var requests = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        
        var requestsURLs: [URL] {
            requests.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            requests.append((url, completion))
        }
        
        func loadCompletion(with error: Error, at index: Int = 0) {
            requests[index].completion(.failure(error))
        }
        
        func loadCompletion(with data: Data, from response: HTTPURLResponse, at index: Int = 0) {
            requests[index].completion(.success((data, response)))
        }
    }
}
