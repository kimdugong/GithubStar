//
//  Network.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/04.
//

import Foundation
import Moya
import RxSwift

protocol Networkable {
    var gitHubProvider: MoyaProvider<Github> { get }
    func getUsers(name: String) -> Single<GithubResponse<User>>
}

class Network: Networkable {
    var gitHubProvider: MoyaProvider<Github>
    
    init(provider: Provider = .production) {
        switch provider {
        case .production:
            self.gitHubProvider = MoyaProvider<Github>(stubClosure: MoyaProvider.neverStub, plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .default))])
        case .mock:
            self.gitHubProvider = MoyaProvider<Github>(stubClosure: MoyaProvider.immediatelyStub, plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
        }
    }
    
    /**
     error:
     Response Body: {"message":"Validation Failed","errors":[{"resource":"Search","field":"q","code":"missing"}],"documentation_url":"https://docs.github.com/v3/search"}
     */
    func getUsers(name: String) -> Single<GithubResponse<User>> {
        gitHubProvider.rx.request(.fetchUsers(name: name), callbackQueue: .main).debug("getUsers").map(GithubResponse<User>.self).catch { error in
            debugPrint(#function, "error : ", error)
            return Single.error(error)
        }
    }
}
