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
    var filtteredStarreds: BehaviorRelay<[Starred]> { get }
    func searchUsers(name: String) -> Single<[User]>
}

protocol UserTableViewModelOutputs {
    var users: BehaviorRelay<[User]> { get }
    var starredsUser: BehaviorRelay<[[Starred]]> { get }
}

class UserTableViewModel: UserTableViewModelInputs, UserTableViewModelOutputs {
    var network: Network
    var coreData: StarredService
    private let disposeBag = DisposeBag()
    
    var users: BehaviorRelay<[User]> = BehaviorRelay<[User]>(value: [])
    var starredsUser: BehaviorRelay<[[Starred]]> = BehaviorRelay<[[Starred]]>(value: [])
    
    // MARK: - Inputs
    var query: PublishSubject<String> = PublishSubject<String>()
    var query2: PublishSubject<String> = PublishSubject<String>()
    var starreds: BehaviorRelay<[Starred]>
    var filtteredStarreds: BehaviorRelay<[Starred]> = BehaviorRelay<[Starred]>(value: [])
    
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
        starreds.bind(to: filtteredStarreds).disposed(by: disposeBag)
        Observable.combineLatest(query2, starreds).map { query, list in
            query == "" ? list : list.filter{ $0.name?.lowercased().hasPrefix(query.lowercased()) ?? false }
        }.bind(to: filtteredStarreds).disposed(by: disposeBag)
        
//        query2.withLatestFrom(starreds) { query, list in
//            query == "" ? list : list.filter{ $0.name?.lowercased().hasPrefix(query.lowercased()) ?? false }
//        }.bind(to: filtteredStarreds).disposed(by: disposeBag)
        
        filtteredStarreds
            .map({ starreds in
                return starreds.reduce([]) { partialResult, starred in
                    guard var last = partialResult.last else { return [[starred]] }
                    var collection = partialResult
                    if last.first?.name?.lowercased().prefix(1) == starred.name?.lowercased().prefix(1) {
                        last.append(starred)
                        let _ = collection.removeLast()
                        collection.append(last)
                    } else {
                        collection.append([starred])
                    }
                    return collection
                }
            })
            .debug("2d array of starredUser")
            .bind(to: starredsUser).disposed(by: disposeBag)
    }
    
    var inputs: UserTableViewModelInputs { return self }
    var outputs: UserTableViewModelOutputs { return self }
}
