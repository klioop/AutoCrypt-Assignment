//
//  UIView+forceLayout.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/18.
//

import UIKit

extension UIView {
    func forceLayout() {
        layoutIfNeeded()
        RunLoop.main.run(until: Date())
    }
}
