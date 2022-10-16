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
    
    typealias LoadResult = Result<[VaccinationCenter], Error>
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    struct Root: Decodable {
        let data: [Item]
        
        var centers: [VaccinationCenter] {
            data.map { VaccinationCenter(id: CenterID(id: $0.id), name: $0.centerName, facilityName: $0.facilityName, address: $0.address, lat: $0.lat, lng: $0.lng, updatedAt: $0.updatedAt) }
        }
    }
    
    struct Item: Decodable {
        let id: Int
        let centerName, facilityName, address: String
        let lat, lng: String
        let updatedAt: String
    }
    
    func load(completion: @escaping (LoadResult) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                if response.statusCode != 200 {
                    completion(.failure(Error.invalidData))
                    return
                }
                let root = try! JSONDecoder().decode(Root.self, from: data)
                completion(.success(root.centers))
                
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

struct VaccinationCenter: Equatable {
    let id: CenterID
    let name: String
    let facilityName: String
    let address: String
    let lat: String
    let lng: String
    let updatedAt: String
}

struct CenterID: Equatable {
    let id: Int
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
        let connectivityError = RemoteVaccinationCentersLoader.Error.connectivity
        
        expect(sut, toCompletedWith: .failure(connectivityError), when: {
            client.loadCompletion(with: connectivityError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponseStatusCode() {
        let (sut, client) = makeSUT()
        let samples = [201, 250, 299, 300, 401, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompletedWith: .failure(.invalidData), when: {
                client.loadCompletion(with: anyData(), from: anyHTTURLResponse(with: code), at: index)
            })
        }
    }
    
    func test_load_deliversVaccinationCentersFrom200HTTPResponse() {
        let (sut, client) = makeSUT()
        let center0 = makeItem(id: 0, name: "center0", lat: "10.0", lng: "11.0", updatedAt: "2022-10-16 14:04:08")
        let center1 = makeItem(id: 1, name: "center1", lat: "2.5", lng: "32.7", updatedAt: "2022-10-10 11:04:08")
        let data = makeJSON([center0.item, center1.item])
        let response = anyHTTURLResponse(with: 200)
        
        expect(sut, toCompletedWith: .success([center0.model, center1.model]), when: {
            client.loadCompletion(with: data, from: response)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteVaccinationCentersLoader, client: ClientSpy) {
        let client = ClientSpy()
        let sut = RemoteVaccinationCentersLoader(url: url, client: client)
        trackMemoryLeak(client, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteVaccinationCentersLoader, toCompletedWith expectedResult: RemoteVaccinationCentersLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
                
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("\(expectedResult) 를 기대했지만 \(receivedResult) 가 나옴", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "a error", code: 0)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    private func anyData() -> Data {
        Data("any data".utf8)
    }
    
    private func uniqueCenter(id: Int = 0,
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
