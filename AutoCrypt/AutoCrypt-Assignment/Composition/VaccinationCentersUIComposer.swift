//
//  VaccinationCentersUIComposer.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import Foundation
import RxSwift

public final class VaccinationCentersUIComposer {
    static public func vaccinationCenterListComposedWith(loadSingle: @escaping () -> Single<Paginated<VaccinationCenter>>) -> VaccinationCenterListViewController {
        let viewModel = VaccinationCentersViewModel(loadSingle: loadSingle)
        let refreshController = VaccinationCentersRefreshController(viewModel: viewModel)
        let centerListController = VaccinationCenterListViewController(refreshController: refreshController)
        
        refreshController.onLoad = { [weak centerListController] paginated in
            centerListController?.set(paginated.items.map { VaccinationCenterCellController(model: $0) })
            viewModel.loadMoreLoader = paginated.loadMore
        }
        
        centerListController.callback = {
            viewModel.loadMore()
        }
        
        viewModel.onLoadMore = { [weak centerListController] in
            centerListController?.add($0.items.map { VaccinationCenterCellController(model: $0) })
        }
        
        return centerListController
    }
}
