//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 9.07.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTabBar()
    }

    func setTabBar(){
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: "circleChart")
        self.tabBarController?.tabBar.items?[0].title = "Dashboard"
        self.tabBarController?.tabBar.items?[1].image = UIImage(named: "document")
        self.tabBarController?.tabBar.items?[1].title = "Logs"

        
    }
}

