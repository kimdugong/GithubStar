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
    var isCompleted: BehaviorRelay<Bool> { get }
    func searchUsers(name: String) -> Single<[User]>
    var users: BehaviorRelay<[User]> { get }
    var starreds: BehaviorRelay<[Starred]> { get }
}

protocol UserTableViewModelOutputs {
    
}

class UserTableViewModel: UserTableViewModelInputs, UserTableViewModelOutputs {
    private var network: Network
    private var coreData: StarredService
    private let disposeBag = DisposeBag()
    
    var users: BehaviorRelay<[User]> = BehaviorRelay<[User]>(value: [])
    var starreds: BehaviorRelay<[Starred]>
    
    
    // MARK: - Inputs
    var query: PublishSubject<String> = PublishSubject<String>()
    var isCompleted: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    func searchUsers(name: String) -> Single<[User]> {
        return network.getUsers(name: name).debug("res").catch({ error in
            debugPrint(#function, "error : ", error)
            return Single<GithubResponse<User>>.never()
        }).map{ $0.items }
    }
    
    init(networkProvider: Provider, coreDataProvider: Provider) {
        network = Network(provider: networkProvider)
        coreData = StarredService(provider: coreDataProvider)
        starreds = BehaviorRelay<[Starred]>(value: coreData.getStarreds() ?? [])
    }
    
    var inputs: UserTableViewModelInputs { return self }
    var outputs: UserTableViewModelOutputs { return self }
}
