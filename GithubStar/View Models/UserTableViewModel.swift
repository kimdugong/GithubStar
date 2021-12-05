//
//  UserListViewModel.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/05.
//

import Foundation
import RxSwift
import RxRelay

protocol UserTableViewModelInputs {
    var query: PublishSubject<String> { get }
    var query2: PublishSubject<String> { get }
    var starreds: BehaviorRelay<[Starred]> { get }
    func searchUsers(name: String) -> Single<[User]>
}

protocol UserTableViewModelOutputs {
    var users: BehaviorRelay<[User]> { get }
    var starredsUser: BehaviorRelay<[Starred]> { get }
}

class UserTableViewModel: UserTableViewModelInputs, UserTableViewModelOutputs {
    
    
    var network: Network
    var coreData: StarredService
    private let disposeBag = DisposeBag()
    
    var users: BehaviorRelay<[User]> = BehaviorRelay<[User]>(value: [])
    var starredsUser: BehaviorRelay<[Starred]> = BehaviorRelay<[Starred]>(value: [])
    
    // MARK: - Inputs
    var query: PublishSubject<String> = PublishSubject<String>()
    var query2: PublishSubject<String> = PublishSubject<String>()
    var starreds: BehaviorRelay<[Starred]>
    
    func searchUsers(name: String) -> Single<[User]> {
        return network.getUsers(name: name)
            .debug("res")
            .catch({ error in
                debugPrint(#function, "error : ", error)
                return Single<GithubResponse<User>>.never()
            })
                    .map{ $0.items }
    }
    
    init(networkProvider: Provider, coreDataProvider: Provider) {
        network = Network(provider: networkProvider)
        coreData = StarredService(provider: coreDataProvider)
        starreds = BehaviorRelay<[Starred]>(value: coreData.getStarreds() ?? [])
        
        starreds.bind(to: starredsUser).disposed(by: disposeBag)
    }
    
    var inputs: UserTableViewModelInputs { return self }
    var outputs: UserTableViewModelOutputs { return self }
}
