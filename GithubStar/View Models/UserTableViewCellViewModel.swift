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
    var user: BehaviorRelay<User> { get }
    func starredButtonTapped()
}

protocol UserTableViewCellViewModelOutputs {
    var isStarred: BehaviorRelay<Bool> { get }
}

class UserTableViewCellViewModel: UserTableViewCellViewModelInputs, UserTableViewCellViewModelOutputs {
    var isStarred: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var user: BehaviorRelay<User>
    
    private let userTableViewModel: UserTableViewModel
    
    func starredButtonTapped() {
        guard let starreds = userTableViewModel.coreData.getStarred(user: user.value), !starreds.isEmpty else {
            let starred = userTableViewModel.coreData.add(user: user.value)
            let updatedUser = User(id: starred.id, name: starred.name!, avatar: starred.avatar!, isStarred: true)
            updateDataSource(updatedUser: updatedUser)
            return
        }
        
        guard let starred = starreds.first, starreds.count == 1 else {
            fatalError("복수개의 데이타...")
        }
        let updatedUser = User(id: starred.id, name: starred.name!, avatar: starred.avatar!, isStarred: false)
        let _ = userTableViewModel.coreData.delete(starred: starred)
        updateDataSource(updatedUser: updatedUser)
    }
    
    private func updateDataSource(updatedUser: User) {
        let users = userTableViewModel.outputs.users.value.map { user -> User in
            if user.id == updatedUser.id {
                return updatedUser
            }
            return user
        }
        
        userTableViewModel.outputs.users.accept(users)
        if let starreds = userTableViewModel.coreData.getStarreds() {
            userTableViewModel.inputs.starreds.accept(starreds)
        }
    }
    
    init(user: User, userTableViewModel: UserTableViewModel) {
        self.userTableViewModel = userTableViewModel
        let isStarred = userTableViewModel.inputs.starreds.value.contains(where: { $0.id == user.id})
        let user = User(id: user.id, name: user.name, avatar: user.avatar, isStarred: isStarred)
        self.user = BehaviorRelay<User>(value: user)
    }
    
    var inputs:UserTableViewCellViewModelInputs { self }
    var outputs:UserTableViewCellViewModelOutputs { self }
}
