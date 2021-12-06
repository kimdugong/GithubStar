//
//  UserTableViewCell.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/02.
//

import UIKit
import RxSwift
import Kingfisher

class UserTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"
    private(set) var disposeBag = DisposeBag()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .black)
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "img_empty")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let starredButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "star"), for: .normal)
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurationCell(viewModel: UserTableViewCellViewModel) {
        viewModel.inputs.user.map{ $0.name }.bind(to: userNameLabel.rx.text).disposed(by: disposeBag)
        
        //        viewModel.inputs.user.map{ URL(string: $0.avatar) }
        //            .compactMap{ $0 }
        //            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        //            .flatMapLatest{ URLSession.shared.rx.data(request: URLRequest(url: $0))}
        //            .map{ UIImage(data: $0)}
        //            .subscribe(on: MainScheduler.instance)
        //            .bind(to: avatarImageView.rx.image)
        //            .disposed(by: disposeBag)
        
        viewModel.inputs.user
            .map{ URL(string: $0.avatar) }
            .compactMap{ $0 }
            .withUnretained(avatarImageView)
            .subscribe { (imageView, url) in imageView.kf.setImage(with: url) }
            .disposed(by: disposeBag)
        
        starredButton.rx.tap.bind{ viewModel.inputs.starredButtonTapped() }.disposed(by: disposeBag)
        
        viewModel.inputs.user
            .map{ $0.isStarred ?? false }
            .asDriver(onErrorJustReturn: false)
            .map{ $0 ? UIImage(named: "star.fill") : UIImage(named: "star") }
            .drive(starredButton.rx.image() )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setting Up UI
    private func setupUI() {
        contentView.addSubview(userNameLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(starredButton)
        
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerY.equalToSuperview()
            make.top.bottom.leading.equalToSuperview().inset(16).priority(.high)
        }
        
        starredButton.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerY.equalTo(avatarImageView)
            make.trailing.equalToSuperview().inset(16)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalTo(starredButton.snp.leading).offset(16)
            make.centerY.equalTo(avatarImageView)
        }
    }
    
}
