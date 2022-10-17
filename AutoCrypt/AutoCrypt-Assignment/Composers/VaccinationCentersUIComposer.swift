//
//  VaccinationCentersUIComposer.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import Foundation

public typealias LoadCompletion = (RemoteVaccinationCentersLoader.LoadResult) -> Void

public final class VaccinationCentersUIComposer {
    static public func vaccinationCenterListComposedWith(load: @escaping (@escaping LoadCompletion) -> Void) -> VaccinationCenterListViewController {
        let viewModel = VaccinationCentersViewModel(load: load)
        let refreshController = VaccinationCentersRefreshController(viewModel: viewModel)
        let centerListController = VaccinationCenterListViewController(refreshController: refreshController)
        
        refreshController.onLoad = { [weak centerListController] centers in
            centerListController?.set(centers.map { VaccinationCenterCellController(model: $0) })
        }
        return centerListController
    }
}
