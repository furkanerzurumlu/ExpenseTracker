//
//  LogsFlow.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 9.07.2023.
//

import UIKit

struct Category {
    let title: String
    // Diğer kategori özelliklerini burada tanımlayabilirsiniz
}
let categories: [Category] = [
    Category(title: "Kategori 1"),
    Category(title: "Kategori 2"),
    Category(title: "Kategori 1"),
    Category(title: "Kategori 2"),
    Category(title: "Kategori 1"),
    Category(title: "Kategori 2"),
    Category(title: "Kategori 1"),
    Category(title: "Kategori 2"),
    // Diğer kategorileri burada ekleyin
]

class LogsFlow: UIViewController {
    @IBOutlet weak var tabCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationContreoller()
        
        tabCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        tabCollectionView.showsHorizontalScrollIndicator = false
        tabCollectionView.dataSource = self
        tabCollectionView.delegate = self
        
        if let flowLayout = tabCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 100, height: 50) // Örneğin
        }

        
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
////            flowLayout.scrollDirection = .horizontal
//            flowLayout.minimumInteritemSpacing = 10
//            flowLayout.minimumLineSpacing = 10
//        }

    }
    
    func setNavigationContreoller(){
        navigationItem.title = "Expense Logs"
        let rightButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func saveButtonTapped() {
        // Butona tıklandığında yapılacak işlemler
        print("Kaydet butonuna tıklandı!")
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
        return CGSize(width: 100, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
