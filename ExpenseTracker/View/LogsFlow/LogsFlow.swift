//
//  LogsFlow.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 9.07.2023.
//

import UIKit
import CoreData

// MARK: Category Variables
struct Category {
    let title: String
}

let categories: [Category] = [
    Category(title: "All   "),
    Category(title: "Donation"),
    Category(title: "Food"),
    Category(title: "Entertainment"),
    Category(title: "Health"),
    Category(title: "Shopping"),
    Category(title: "Transportation"),
    Category(title: "Utilities"),
    Category(title: "Other"),
]

class LogsFlow: UIViewController {
    
    // MARK: All Variables
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var segmentView: UIStackView!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel = LogsFlowVM()
    
    var filterProductName: [String] = []
    var filterCategory:[String] = []
    
    var matchCategory: String?
    
    var selectedCell: CategoryCollectionViewCell?
    var selectedIndex: IndexPath?
    
    var matchingIndex: [Int] = []
    
    var toDoSearchText: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getAllData()
        filterProductName = viewModel.productNameArray
        filterCategory = viewModel.categoryNameArray
        
        tabCollectionView.allowsMultipleSelection = true
        itemTableView.allowsSelection = false
        
        searchBar.placeholder = "Search Expenses"
        searchBar.delegate = self
        viewModel.delegate = self
        
        setNavigationController()
        setTabCollectionView()
        itemTableView.reloadData()
        
        
        itemTableView.dataSource = self
        itemTableView.delegate = self
        itemTableView.register(ItemCell.nibName, forCellReuseIdentifier: ItemCell.identifer)
        
        itemTableView.layer.borderWidth = 0.3
        itemTableView.layer.borderColor = UIColor.gray.cgColor
        
        print("Kategori Array :\(viewModel.categoryNameArray)")
        print(viewModel.priceArray)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
        
        viewModel.getAllData()
        //itemTableView.reloadData()
        viewModel.delegate?.refreshTableView()
        
    }
    
    
    // MARK: CoreData Fetch Proccess
    @objc func getData(){
        
        viewModel.getAllData()
        
    }
    
    // MARK: Match Product Image
    
    func getValidCategoryImage(category: String, cell: ItemCell){
        
        switch category {
            
        case "Donation": cell.categoryImageView.image = UIImage(named: "donation")
        case "Food": cell.categoryImageView.image = UIImage(named: "food")
        case "Entertainment": cell.categoryImageView.image = UIImage(named: "entertainment")
        case "Health": cell.categoryImageView.image = UIImage(named: "health")
        case "Shopping": cell.categoryImageView.image = UIImage(named: "shopping")
        case "Transportation": cell.categoryImageView.image = UIImage(named: "transportation")
        case "Utilities": cell.categoryImageView.image = UIImage(named: "utilities")
            
        default:
            cell.categoryImageView.image = UIImage(named: "other")
        }
    }
    
    // MARK: Set ColletionView
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
    
    // MARK: Set Navigation Controller
    private func setNavigationController(){
        navigationItem.title = "Expense Logs"
        let rightButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(saveButton))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func saveButton() {
        performSegue(withIdentifier: "showEditFlow", sender: nil)
        print("Go Edit Flow")
    }
    
}

// MARK: Category CollectionView
extension LogsFlow: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        selectedIndex = indexPath
        collectionView.reloadData()
        
        let selectedCategory = categories[indexPath.item]
        let selectedCategoryTitle = selectedCategory.title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        matchCategory = selectedCategoryTitle
        
        
        if selectedCategoryTitle == "All" {
            
            viewModel.filterDataValue = ""
            viewModel.filteredItemsArray = []
            
            selectedCell?.backgroundColor = UIColor.clear
            selectedCell?.titleLabel.textColor = UIColor.gray
            selectedCell = nil
            selectedIndex = nil
        } else {
            viewModel.filterDataValue = selectedCategoryTitle
            
            let cellToReload = viewModel.categoryNameArray.filter { $0 == selectedCategoryTitle }
            viewModel.filteredItemsArray = cellToReload
        }
        
        refreshTableView()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        let category = categories[indexPath.item]
        cell.titleLabel.text = category.title
        
        cell.layoutSubviews()
        
        if let selectedIndexPath = selectedIndex {
            
            if selectedIndexPath == indexPath {
                cell.backgroundColor = UIColor(hex: 0xEADBC8)
                cell.titleLabel.textColor = UIColor.white
            } else {
                cell.backgroundColor = UIColor.clear
                cell.titleLabel.textColor = UIColor.gray
            }
        } else {
            
            if indexPath.item == 0 {
                cell.backgroundColor = UIColor(hex: 0xEADBC8)
                cell.titleLabel.textColor = UIColor.white
            } else {
                cell.backgroundColor = UIColor.clear
                cell.titleLabel.textColor = UIColor.gray
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = categories[indexPath.item]
        let titleWidth = calculateLabelWidth(text: category.title) + 20
        return CGSize(width: titleWidth + 30, height: 40)
        
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

// MARK: ItemTableView
extension LogsFlow: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text?.isEmpty == true && viewModel.filteredItemsArray.isEmpty == true{
            
            return viewModel.productNameArray.count
        } else if viewModel.filteredItemsArray.isEmpty == false{
            print("Count: \(viewModel.filteredItemsArray.count)")
            return viewModel.filteredItemsArray.count
        }
        else {
            return filterProductName.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = itemTableView.dequeueReusableCell(withIdentifier: ItemCell.identifer,for: indexPath) as! ItemCell
        
        print("FilterItem:\(viewModel.filteredItemsArray)") // FilterItem:["Food", "Food", "Food"] şeklinde data döndürür.
        matchingIndex = []
        if toDoSearchText == false{ // Search Bar Aktivitasyon
            if viewModel.filteredItemsArray.isEmpty  || filterProductName.isEmpty{ //Kategori seçilmediğinde ya da "All durumunda
                cell.productLabelText.text = filterProductName[indexPath.row]
                cell.priceLabelText.text = "$\(viewModel.priceArray[indexPath.row]).00"
                cell.dateLabelText.text = "\(viewModel.dateArray[indexPath.row])"
                
                
                let selectedCategory = viewModel.categoryNameArray[indexPath.row]
                
                getValidCategoryImage(category: selectedCategory, cell: cell)
                
            } else {
                print("dolu")
                
                
                for (index,item) in viewModel.categoryNameArray.enumerated() {
                    if item == viewModel.filterDataValue {
                        matchingIndex.append(index)
                    }
                }
                print("eşleşen index: \(matchingIndex)")
                print("ham array: \(filterProductName)")
                print("eşleşen product name: \(filterProductName[matchingIndex[indexPath.row]])")
                print("eşleşen price value: \(viewModel.priceArray[matchingIndex[indexPath.row]]).00")
                
                
                
                cell.productLabelText.text = filterProductName[matchingIndex[indexPath.row]]
                //print(filterProductName[matchingIndex[indexPath.row]])
                cell.priceLabelText.text = "$\(viewModel.priceArray[matchingIndex[indexPath.row]]).00"
                cell.dateLabelText.text = "\(viewModel.dateArray[matchingIndex[indexPath.row]])"
                getValidCategoryImage(category: viewModel.filteredItemsArray[indexPath.row], cell: cell)
                
            }
        } else {
            print("Search Deneme Match Index: \(viewModel.searchMatchIndex) ")
            
            
            cell.productLabelText.text = viewModel.productNameArray[viewModel.searchMatchIndex[indexPath.row]]
            cell.priceLabelText.text = "$\(viewModel.priceArray[viewModel.searchMatchIndex[indexPath.row]]).00"
            getValidCategoryImage(category: viewModel.categoryNameArray[viewModel.searchMatchIndex[indexPath.row]], cell: cell)
        }
        
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: SerachBar Delegate

extension LogsFlow: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filterProductName = viewModel.productNameArray
            refreshTableView()
            
            toDoSearchText = false
            
        } else {
            
            filterProductName = viewModel.productNameArray.filter {$0.lowercased().contains(searchText.lowercased())}
            for (index,name) in viewModel.productNameArray.enumerated() {
                if filterProductName.contains(name){
                    matchingIndex.append(index)
                }
            }
            viewModel.searchMatchIndex = matchingIndex
            toDoSearchText = true
            refreshTableView()
            
            print("filterProductName\(filterProductName)")
            print("deneme123\(viewModel.productNameArray.enumerated())")
            print("Match Index2:\(matchingIndex)")
            print("filtrelenen text: \(filterProductName)")
        }
        
    }
}

// MARK: LogsFlowVMDelegate
extension LogsFlow: LogsFlowVMDelegate {
    func refreshTableView() {
        DispatchQueue.main.async {
            self.itemTableView.reloadData()
            
        }
    }
    
    func controllerDidChangeContent() {
        DispatchQueue.main.async {
            self.itemTableView.reloadData()
        }
    }
}



