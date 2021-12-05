//
//  UserTableViewCellViewModel.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/05.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserTableViewCellViewModelInputs {
    var name: BehaviorRelay<String> { get }
    var avatar: BehaviorRelay<URL?> { get }
    func starredButtonTapped()
}

protocol UserTableViewCellViewModelOutputs {
    var isStarred: BehaviorRelay<Bool> { get }
}

class UserTableViewCellViewModel: UserTableViewCellViewModelInputs, UserTableViewCellViewModelOutputs {
    func starredButtonTapped() {
        debugPrint(#function, name.value, avatar.value, isStarred.value)
    }
    
    var name: BehaviorRelay<String>
    var isStarred: BehaviorRelay<Bool>
    var avatar: BehaviorRelay<URL?>

    init(name: String, avatar: String, isStarred: Bool) {
        self.name = BehaviorRelay<String>(value: name)
        self.avatar = BehaviorRelay<URL?>(value: URL(string: avatar))
        self.isStarred = BehaviorRelay<Bool>(value: isStarred)
    }
    
    var inputs:UserTableViewCellViewModelInputs { self }
    var outputs:UserTableViewCellViewModelOutputs { self }
}
