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

    private func updateList() -> [String] {
        let context = PersistenceManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Starred", in: context)
        let starred = NSManagedObject(entity: entity!, insertInto: context)
        starred.setValue(names[index], forKey: "name")
        try! context.save()

        let starredList = try! context.fetch(Starred.fetchRequest())
        let names = starredList.compactMap{ $0.name }
        return names
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        list = updateList()
    }

    @IBAction func buttonTapped(_ sender: Any) {
        list = updateList()
        index += 1
    }

}

