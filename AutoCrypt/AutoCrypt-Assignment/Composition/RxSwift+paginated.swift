//
//  RxSwift+paginated.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/17.
//

import Foundation
import RxSwift

public extension Paginated {
    init(items: [Item], loadMoreSingle: (() -> Single<Self>)?) {
        let bag = DisposeBag()
        self.init(items: items, loadMore: loadMoreSingle.map { single in
            return { completion in
                single()
                    .subscribe(onSuccess: {
                        completion(.success($0))
                    }, onFailure: {
                        completion(.failure($0))
                    }).disposed(by: bag)
            }
        })
    }
    
    var loadMoreSingle: (() -> Single<Self>)? {
        guard let loadMore = self.loadMore else { return nil }
        
        return {
            Single.create { observer in
                loadMore { result in
                    observer(result)
                }
                return Disposables.create()
            }
        }
    }
}
