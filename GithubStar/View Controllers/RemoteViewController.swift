//
//  RemoteViewController.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/02.
//

import UIKit
import RxSwift
import RxCocoa
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
    }
    
    private func bind() {
        searchBar.rx.text.orEmpty.filter{ $0 != "" }.debounce(.milliseconds(500), scheduler: MainScheduler.instance).distinctUntilChanged().debug("search bar text").bind(to: viewModel.inputs.query).disposed(by: disposeBag)
        
        viewModel.inputs.query
            .withUnretained(viewModel)
            .flatMapLatest{ $0.0.inputs.searchUsers(name: $0.1) }
            .withUnretained(viewModel)
            .subscribe(onNext: { (viewModel, res) in
                viewModel.outputs.users.accept(res.items)
                viewModel.outputs.page.accept(1)
                viewModel.outputs.totalCount.accept(res.totalCount)
                print(".flatMapLatest{ $0.0.inputs.searchUsers(name: $0.1) }", res.isIncompleted)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.users.map{ [SectionModel(model: "", items: $0)] }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.withUnretained(searchBar).bind{ $0.0.resignFirstResponder() }.disposed(by: disposeBag)
        
        view.rx.tapGesture(configuration: { recognizer, _ in recognizer.cancelsTouchesInView = false })
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive{ [weak self] _ in self?.view.endEditing(true) }
            .disposed(by: disposeBag)
        
        let bottomTouch = tableView.rx.contentOffset
            .flatMapLatest { [unowned self] offset in offset.y + tableView.frame.size.height + 20 > tableView.contentSize.height ? Signal.just(offset.y) : Signal.empty() }
            .buffer(timeSpan: .never, count: 2, scheduler: MainScheduler.instance)
            .flatMapLatest{ $0[1] > $0[0] ? Signal.just($0[1]) : Signal.empty() }
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
        
        bottomTouch.withLatestFrom(viewModel.inputs.query)
            .withUnretained(viewModel).flatMapLatest{ $0.0.inputs.searchMoreUser(name: $0.1) }
            .withUnretained(viewModel)
            .subscribe { (viewModel, res) in
                viewModel.outputs.users.accept( viewModel.outputs.users.value + res.items)
                viewModel.outputs.page.accept(viewModel.outputs.page.value + 1)
                viewModel.outputs.totalCount.accept(res.totalCount)
            }.disposed(by: disposeBag)
    }
}

extension RemoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RemoteViewController: UISearchBarDelegate {}
