//
//  RxSwift+loadSingle.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/17.
//

import Foundation
import RxSwift

extension RemoteVaccinationCentersLoader {
    func loadSingle() -> Single<[VaccinationCenter]> {
        Single.create { [weak self] observer in
            self?.load { result in
                observer(result)
            }
            return Disposables.create()
        }
    }
}
