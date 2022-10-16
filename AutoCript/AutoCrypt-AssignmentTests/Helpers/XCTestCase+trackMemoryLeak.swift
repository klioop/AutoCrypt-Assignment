//
//  XCTestCase+trackMemoryLeak.swift
//  AutoCript-AssignmentTests
//
//  Created by klioop on 2022/10/16.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "테스트가 끝나면 \(String(describing: instance)) 는 메모리에서 해제되어야 함. 그렇지 않으면 메모리 릭을 암시", file: file, line: line)
        }
    }
}
