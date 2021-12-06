//
//  RemoteViewController.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/02.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

class RemoteViewController: UIViewController {
    private let disposeBag: DisposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = .systemGroupedBackground
        } else {
            tableView.backgroundColor = .lightGray
        }
        tableView.delegate = self
        
        tableView.tableHeaderView = searchBar
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 36 + 16))
        bar.delegate = self
        bar.placeholder = "검색어를 입력하세요"
        return bar
    }()
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, User>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>>  { [unowned self] dataSource, tableView, indexPath, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier) as? UserTableViewCell else {
                return UITableViewCell()
            }
            let cellViewModel = UserTableViewCellViewModel(user: model, userTableViewModel: viewModel)
            cell.configurationCell(viewModel: cellViewModel)
            return cell
        }
        return dataSource
    }()
    
    private let viewModel: UserTableViewModel

    init(viewModel: UserTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
//        tableView.tableHeaderView = searchController.searchBar
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchResultsUpdater = self
//        searchController.hidesNavigationBarDuringPresentation = false
//        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    private func bind() {
        searchBar.rx.text.orEmpty.filter{ $0 != "" }.debounce(.milliseconds(500), scheduler: MainScheduler.instance).distinctUntilChanged().debug("search bar text").bind(to: viewModel.inputs.query).disposed(by: disposeBag)
        
        viewModel.inputs.query
            .withUnretained(viewModel)
            .flatMapLatest{ $0.0.inputs.searchUsers(name: $0.1) }
            .bind(to: viewModel.outputs.users)
            .disposed(by: disposeBag)
        
//        viewModel.outputs.users.bind(to: tableView.rx.items(cellIdentifier: UserTableViewCell.identifier, cellType: UserTableViewCell.self)){ [unowned self] row, model, cell in
//            let cellViewModel = UserTableViewCellViewModel(user: model, userTableViewModel: viewModel)
//            cell.configurationCell(viewModel: cellViewModel)
//        }.disposed(by: disposeBag)
        viewModel.outputs.users.map{ [SectionModel(model: "", items: $0)] }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
}

extension RemoteViewController: UITableViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if let parent = self.parent?.parent as? PageViewController {
//            parent.scrollView.contentSize = scrollView.contentSize
//            parent.scrollView.contentInset = scrollView.contentInset
//            parent.scrollView.contentOffset = scrollView.contentOffset
//            parent.scrollView.decelerationRate = scrollView.decelerationRate
//            parent.scrollView.panGestureRecognizer.state = scrollView.panGestureRecognizer.state
//            parent.scrollView.directionalPressGestureRecognizer.state = scrollView.directionalPressGestureRecognizer.state
//        }
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension RemoteViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function, searchText)
    }
}
