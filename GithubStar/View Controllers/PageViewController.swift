//
//  PageViewController.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/02.
//

import UIKit
import Tabman
import Pageboy
import SnapKit
import RxGesture

class PageViewController: TabmanViewController {
    private var viewControllers: [UIViewController]
    let scrollView: UIScrollView = UIScrollView()
    private let tabBar: TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator> = {
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .blur(style: .extraLight)
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .progressive
        bar.buttons.customize { button in
            button.tintColor = .lightGray
            button.selectedTintColor = .darkText
        }
        bar.indicator.tintColor = .darkText
        
        return bar
    }()
    
    init(pages viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Setting Up UI
    private func setupUI() {
        title = "Github Stars"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        // MARK: - setup tabman
        bounces = false
        dataSource = self
        addBar(tabBar, dataSource: self, at: .top)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        view.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}

extension PageViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        nil
    }
    
}

extension PageViewController: TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "API")
        case 1:
            return TMBarItem(title: "로컬")
        default:
            return TMBarItem(title: "", badgeValue: nil)
        }
    }
}
