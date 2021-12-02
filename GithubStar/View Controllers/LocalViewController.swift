//
//  LocalViewController.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/02.
//

import UIKit

class LocalViewController: UIViewController {
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
        title = "Github"
        view.backgroundColor = .white
    }
}
