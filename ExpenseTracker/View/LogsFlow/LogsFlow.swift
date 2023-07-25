//
//  LogsFlow.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 9.07.2023.
//

import UIKit
import CoreData

struct Category {
    let title: String
}
let categories: [Category] = [
    Category(title: "Donation"),
    Category(title: "Food"),
    Category(title: "Entertainment"),
    Category(title: "Health"),
    Category(title: "Shopping"),
    Category(title: "Transportion"),
    Category(title: "Utilities"),
    Category(title: "Other"),
    
]

class LogsFlow: UIViewController {
    
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var segmentView: UIStackView!
    @IBOutlet weak var itemTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        request.returnsObjectsAsFaults = false
        
        setNavigationContreoller()
        setTabCollectionView()
        
        itemTableView.layer.borderWidth = 0.3
        itemTableView.layer.borderColor = UIColor.gray.cgColor

    }
    
    
    private func setTabCollectionView(){
        tabCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        bottomBorder.frame = CGRect(x: 0, y: tabCollectionView.bounds.height - 1, width: tabCollectionView.bounds.width, height: 0.3)
        tabCollectionView.layer.addSublayer(bottomBorder)
        
        tabCollectionView.showsHorizontalScrollIndicator = false
        tabCollectionView.dataSource = self
        tabCollectionView.delegate = self
        
        if let flowLayout = tabCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 100, height: 50)
        }
    }
    
    private func setNavigationContreoller(){
        navigationItem.title = "Expense Logs"
        let rightButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func saveButtonTapped() {
        performSegue(withIdentifier: "showEditFlow", sender: nil)
        print("Go Edit Flow")
    }
    
}

extension LogsFlow: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.item]
        print("Seçilen Kategori: \(selectedCategory.title)")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        let category = categories[indexPath.item]
        cell.titleLabel.text = category.title
        
        cell.layoutSubviews()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = categories[indexPath.item]
        let titleWidth = calculateLabelWidth(text: category.title) + 20
        return CGSize(width: titleWidth + 30, height: 40)
        
        //return CGSize(width: 100, height: 40)
    }
    
    private func calculateLabelWidth(text: String) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}



