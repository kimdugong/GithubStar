//
//  LocalViewController.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/02.
//

import UIKit

class LocalViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = .systemGroupedBackground
        } else {
            tableView.backgroundColor = .lightGray
        }
        tableView.dataSource = self
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
}

extension LocalViewController: UITableViewDelegate {
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

extension LocalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

extension LocalViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function, searchText)
    }
}
