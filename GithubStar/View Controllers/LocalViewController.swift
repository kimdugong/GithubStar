//
//  LocalViewController.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/02.
//

import UIKit
import RxSwift
import RxDataSources

class LocalViewController: UIViewController {
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
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, Starred>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Starred>>  { [unowned self] dataSource, tableView, indexPath, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier) as? UserTableViewCell else {
                return UITableViewCell()
            }
            let user = User(id: model.id, name: model.name!, avatar: model.avatar!, isStarred: true)
            let cellViewModel = UserTableViewCellViewModel(user: user, userTableViewModel: viewModel)
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
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
    }
    
    private func bind() {
        searchBar.rx.text.orEmpty.debug("search bar text").bind(to: viewModel.inputs.query2).disposed(by: disposeBag)
        
        viewModel.outputs.starredsUser
            .map({ starredsArray -> [SectionModel] in
                starredsArray.map ({ starreds -> SectionModel in
                    SectionModel(model: String(starreds.first?.name?.lowercased().prefix(1) ?? ""), items: starreds)
                })
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension LocalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LocalViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function, searchText)
    }
}
