//
//  ViewController.swift
//  GithubStar
//
//  Created by Dugong on 2021/11/30.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    private var names = ["dugong", "quokka", "panda", "hedgedog"]
    private var index = 0
    private var list: [String] = [] {
        willSet {
            print("oldValue", list)
            print("newValue", newValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        list = updateList()
    }

    @IBAction func buttonTapped(_ sender: Any) {
//        list = updateList()
        index += 1
    }

}

