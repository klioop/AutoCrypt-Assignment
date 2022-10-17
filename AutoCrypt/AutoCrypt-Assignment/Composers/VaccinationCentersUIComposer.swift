//
//  VaccinationCentersUIComposer.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import Foundation
import RxSwift

public final class VaccinationCentersUIComposer {
    static public func vaccinationCenterListComposedWith(loadSingle: @escaping () -> Single<[VaccinationCenter]>) -> VaccinationCenterListViewController {
        let viewModel = VaccinationCentersViewModel(loadSingle: loadSingle)
        let refreshController = VaccinationCentersRefreshController(viewModel: viewModel)
        let centerListController = VaccinationCenterListViewController(refreshController: refreshController)
        
        refreshController.onLoad = { [weak centerListController] centers in
            centerListController?.set(centers.map { VaccinationCenterCellController(model: $0) })
        }
        return centerListController
    }
}

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
