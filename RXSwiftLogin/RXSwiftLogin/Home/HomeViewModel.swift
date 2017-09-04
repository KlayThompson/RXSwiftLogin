//
//  HomeViewModel.swift
//  RXSwiftLogin
//
//  Created by Kim on 2017/9/4.
//  Copyright © 2017年 Brain. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HomeViewModel {
    
    var model: Driver<[Hero]>
    
    init(searchText: Observable<String>, service: CheckService) {
        model = searchText
            .debug()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap({ (text)  in
                return service.getHeroWithName(name: text)
            })
            .asDriver(onErrorJustReturn: [])
    }
}
