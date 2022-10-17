//
//  RxSwift+paginated.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/17.
//

import Foundation
import RxSwift

extension Paginated {
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
