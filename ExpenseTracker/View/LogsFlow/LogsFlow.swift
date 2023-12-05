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
    Category(title: "Transportion"),
    Category(title: "Utilities"),
    Category(title: "Other"),
]

class LogsFlow: UIViewController {
    
    // MARK: All Variables
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var segmentView: UIStackView!
    @IBOutlet weak var itemTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filterProductName: [String] = []
    var filterCategory:[String] = []
    
    var viewModel = LogsFlowVM()
    
    var selectedCell: CategoryCollectionViewCell?
    var selectedIndex: IndexPath?
    
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
        
        //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        //        let context = appDelegate.persistentContainer.viewContext
        //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        //        fetchRequest.returnsObjectsAsFaults = false
        //
        //        do{
        //            let results = try context.fetch(fetchRequest)
        //            for resut in results as! [NSManagedObject]{
        //
        //                if let product = resut.value(forKey: "product") as? String {
        //                    self.productNameArray.append(product)
        //                }
        //                if let id = resut.value(forKey: "id") as? UUID {
        //                    self.idArray.append(id)
        //                }
        //                self.itemTableView.reloadData()
        //            }
        //        } catch {
        //
        //        }
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
        
        refreshTableView()
        selectedIndex = indexPath
        collectionView.reloadData()
        
        let selectedCategory = categories[indexPath.item]
        var selectedCategoryTitle = selectedCategory.title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("Seçilen Kategori: \(selectedCategoryTitle)")
        
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
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        let category = categories[indexPath.item]
        cell.titleLabel.text = category.title
        
        cell.layoutSubviews()
        
        if let selectedIndexPath = selectedIndex {
            // Eğer selectedIndex değeri nil değilse, yani bir hücre seçilmişse
            
            if selectedIndexPath == indexPath {
                cell.backgroundColor = UIColor(hex: 0xEADBC8)
                cell.titleLabel.textColor = UIColor.white
            } else {
                cell.backgroundColor = UIColor.clear
                cell.titleLabel.textColor = UIColor.gray
            }
        } else {
            // selectedIndex değeri nil ise, yani hiçbir hücre seçilmemişse
            
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
        var matchingIndex: [Int] = []
        //        print("ViewModel filter Data Test: \(viewModel.filteredItemsArray)")
        
        print("Normal şekilde yazdırabilrisniz: \(String(describing: viewModel.filterDataValue))")
        
        if (viewModel.filterDataValue == "All   " || viewModel.filterDataValue == ""){
            print("xxxxxxxxx")
            
            
            if indexPath.row < filterProductName.count {
                
                cell.productLabelText.text = "\(filterProductName[indexPath.row])"
                //                print("BUGFİX: \(filterProductName[indexPath.row])")
            } else {
                //                cell.productLabelText.text = "\(filterProductName[indexPath.row])"
                cell.productLabelText.text = "\(viewModel.productNameArray[indexPath.row])"
            }
            
            if indexPath.row < viewModel.priceArray.count {
                
                let newArray = viewModel.priceArray.filter { $0 != 0 }
                cell.priceLabelText.text = "$\(newArray[indexPath.row]).00"
                
                print("Old Array: \(viewModel.priceArray)")
                print("New Array: \(newArray)")
                
                
            } else {
                cell.priceLabelText.text = "-----"
            }
            
            if indexPath.row < viewModel.dateArray.count {
                cell.dateLabelText.text = "\(viewModel.dateArray[indexPath.row])"
            } else {
                cell.dateLabelText.text = "-"
            }
            
            if indexPath.row < viewModel.categoryNameArray.count {
                let selectedCategory = viewModel.categoryNameArray[indexPath.row]
                
                switch selectedCategory {
                case "Donation": cell.categoryImageView.image = UIImage(named: "donation")
                case "Food": cell.categoryImageView.image = UIImage(named: "food")
                case "Entertainment": cell.categoryImageView.image = UIImage(named: "entertainment")
                case "Health": cell.categoryImageView.image = UIImage(named: "health")
                case "Shopping": cell.categoryImageView.image = UIImage(named: "shopping")
                case "Transportion": cell.categoryImageView.image = UIImage(named: "transportion")
                case "Utilities": cell.categoryImageView.image = UIImage(named: "utilities")
                    
                    
                default:
                    cell.categoryImageView.image = UIImage(named: "other")
                }
            } else {
                cell.categoryImageView.image = UIImage(named: "other")
            }
            
        } else{
            print("yyyyyyyyy ")
            for (index,item) in viewModel.categoryNameArray.enumerated() {
                if item == viewModel.filterDataValue {
                    matchingIndex.append(index)
                }
            }
            if !matchingIndex.isEmpty {
                print(viewModel.categoryNameArray)
                print("Eşleşen indisler: \(matchingIndex)")
                //                   for index in matchingIndex {
                //                       print(index)
                //                   }
                cell.productLabelText.text = "\(filterProductName[matchingIndex[indexPath.row]])"
                let newArray = viewModel.priceArray.filter { $0 != 0 }
                cell.priceLabelText.text = "$\(newArray[matchingIndex[indexPath.row]]).00"
                
                switch viewModel.filterDataValue{
                    
                case "Donation": cell.categoryImageView.image = UIImage(named: "donation")
                case "Food": cell.categoryImageView.image = UIImage(named: "food")
                case "Entertainment": cell.categoryImageView.image = UIImage(named: "entertainment")
                case "Health": cell.categoryImageView.image = UIImage(named: "health")
                case "Shopping": cell.categoryImageView.image = UIImage(named: "shopping")
                case "Transportion": cell.categoryImageView.image = UIImage(named: "transportion")
                case "Utilities": cell.categoryImageView.image = UIImage(named: "utilities")
                    
                    
                default:
                    cell.categoryImageView.image = UIImage(named: "other")
                }
            }
        }
        
        
        
        
        
        
        
        
        
        
        //        if indexPath.row < filterProductName.count {
        //
        //            cell.productLabelText.text = "\(filterProductName[indexPath.row])"
        //        } else {
        //            cell.productLabelText.text = "--"
        //
        //        }
        //
        //        if indexPath.row < viewModel.priceArray.count {
        //
        //            let newArray = viewModel.priceArray.filter { $0 != 0 }
        //            cell.priceLabelText.text = "$\(newArray[indexPath.row]).00"
        //
        //            print("Old Array: \(viewModel.priceArray)")
        //            print("New Array: \(newArray)")
        //
        //
        //        } else {
        //            cell.priceLabelText.text = "-----"
        //        }
        //
        //        if indexPath.row < viewModel.dateArray.count {
        //            cell.dateLabelText.text = "\(viewModel.dateArray[indexPath.row])"
        //        } else {
        //            cell.dateLabelText.text = "-"
        //        }
        //
        //        if indexPath.row < viewModel.categoryNameArray.count {
        //            let selectedCategory = viewModel.categoryNameArray[indexPath.row]
        //
        //            switch selectedCategory {
        //            case "Donation": cell.categoryImageView.image = UIImage(named: "donation")
        //            case "Food": cell.categoryImageView.image = UIImage(named: "food")
        //            case "Entertainment": cell.categoryImageView.image = UIImage(named: "entertainment")
        //            case "Health": cell.categoryImageView.image = UIImage(named: "health")
        //            case "Shopping": cell.categoryImageView.image = UIImage(named: "shopping")
        //            case "Transportion": cell.categoryImageView.image = UIImage(named: "transportion")
        //            case "Utilities": cell.categoryImageView.image = UIImage(named: "utilities")
        //
        //
        //            default:
        //                cell.categoryImageView.image = UIImage(named: "other")
        //            }
        //        } else {
        //            cell.categoryImageView.image = UIImage(named: "other")
        //        }
        
        
        
        
        
        
        
        
        
        
        
        
        //        if indexPath.row < filterProductName.count {
        //
        //            cell.productLabelText.text = "\(filterProductName[indexPath.row])"
        //        } else {
        //            cell.productLabelText.text = "--"
        //            //            cell.priceLabelText.text = "\(viewModel.productNameArray[indexPath.row])"
        //        }
        //
        //        if indexPath.row < viewModel.priceArray.count {
        //            //            cell.priceLabelText.text = "\(viewModel.priceArray[indexPath.row])"
        //            let newArray = viewModel.priceArray.filter { $0 != 0 }
        //            cell.priceLabelText.text = "$\(newArray[indexPath.row]).00"
        //
        //            print("Old Array: \(viewModel.priceArray)")
        //            print("New Array: \(newArray)")
        //
        //            //                        let price = viewModel.priceArray[indexPath.row]
        //            //                        cell.priceLabelText.text = "\(price)$"
        //
        //        } else {
        //            cell.priceLabelText.text = "-----"
        //        }
        //        //cell.dateLabelText.text = "\(viewModel.dateArray[indexPath.row])"
        //        //print("\(viewModel.categoryNameArray[indexPath.row])")
        //        if indexPath.row < viewModel.dateArray.count {
        //            cell.dateLabelText.text = "\(viewModel.dateArray[indexPath.row])"
        //        } else {
        //            cell.dateLabelText.text = "-"
        //        }
        //
        //        if indexPath.row < viewModel.categoryNameArray.count {
        //            let selectedCategory = viewModel.categoryNameArray[indexPath.row]
        //
        //            switch selectedCategory {
        //            case "Donation": cell.categoryImageView.image = UIImage(named: "donation")
        //            case "Food": cell.categoryImageView.image = UIImage(named: "food")
        //            case "Entertainment": cell.categoryImageView.image = UIImage(named: "entertainment")
        //            case "Health": cell.categoryImageView.image = UIImage(named: "health")
        //            case "Shopping": cell.categoryImageView.image = UIImage(named: "shopping")
        //            case "Transportion": cell.categoryImageView.image = UIImage(named: "transportion")
        //            case "Utilities": cell.categoryImageView.image = UIImage(named: "utilities")
        //
        //
        //            default:
        //                cell.categoryImageView.image = UIImage(named: "other")
        //            }
        //        } else {
        //            cell.categoryImageView.image = UIImage(named: "other")
        //        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension LogsFlow: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filterProductName = viewModel.productNameArray
        } else {
            filterProductName = viewModel.productNameArray.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        refreshTableView()
        //        if searchText.isEmpty == true {
        //            filterProductName = viewModel.productNameArray
        //
        //        } else {
        //            filterProductName = viewModel.productNameArray.filter { $0.lowercased().contains(searchText.lowercased()) }
        //        }
        //        refreshTableView()
    }
}

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


//extension LogsFlow: LogsFlowVMDelegate {
//    func refreshTableView() {
//        DispatchQueue.main.async {
//            self.itemTableView.reloadData()
//        }
//    }
//
//
//}
