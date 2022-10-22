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
            centerListController?.set(paginated.cellControllers)
            guard let loadMore = paginated.loadMoreSingle else { return }
            
            let pagingViewModel = PagingViewModel(loadMoreLoader: loadMore)
            let pagingController = PagingController(viewModel: pagingViewModel)
            
            pagingController.onLoadMore = { [weak centerListController] paginated in
                centerListController?.append(paginated.cellControllers)
                
                guard let loadMore = paginated.loadMoreSingle else {
                    pagingController.isLastPage = true
                    return
                }
                
                pagingController.viewModel = PagingViewModel(loadMoreLoader: loadMore)
            }
            
            centerListController?.callback = pagingController.loadMore
        }
        
        centerListController.title = "예방접종센터 리스트"
        return centerListController
    }
}

private extension Paginated where Item == VaccinationCenter {
    var cellControllers: [VaccinationCenterCellController] {
        items.map { VaccinationCenterCellController(model: $0) }
    }
}
