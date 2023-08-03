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
    
    
    var viewModel = LogsFlowVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        let context = appDelegate.persistentContainer.viewContext
        viewModel.delegate = self
        //        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        //        request.returnsObjectsAsFaults = false
        
        setNavigationController()
        setTabCollectionView()
        
        //getData()
        
        itemTableView.reloadData()
        
        itemTableView.dataSource = self
        itemTableView.delegate = self
        itemTableView.register(ItemCell.nibName, forCellReuseIdentifier: ItemCell.identifer)
        
        itemTableView.layer.borderWidth = 0.3
        itemTableView.layer.borderColor = UIColor.gray.cgColor
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
        //NotificationCenter.default.removeObserver("newData")
        viewModel.getAllData()
        itemTableView.reloadData()
        
        
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
        let rightButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func saveButtonTapped() {
        performSegue(withIdentifier: "showEditFlow", sender: nil)
        print("Go Edit Flow")
    }
    
}

// MARK: Category CollectionView Extension
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

// MARK: ItemTableView Extension
extension LogsFlow: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return idArray.count
        return viewModel.idArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = itemTableView.dequeueReusableCell(withIdentifier: ItemCell.identifer,for: indexPath) as! ItemCell
        
        if indexPath.row < viewModel.productNameArray.count {
            cell.productLabelText.text = "\(viewModel.productNameArray[indexPath.row])"
        } else {
            cell.productLabelText.text = "--"
        }
        if indexPath.row < viewModel.priceArray.count {
            cell.priceLabelText.text = "\(viewModel.priceArray[indexPath.row])"
        } else {
            cell.priceLabelText.text = "-----"
        }
        //cell.dateLabelText.text = "\(viewModel.dateArray[indexPath.row])"
        //print("\(viewModel.categoryNameArray[indexPath.row])")
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


extension LogsFlow: LogsFlowVMDelegate {
    func refreshTableView() {
        DispatchQueue.main.async {
            self.itemTableView.reloadData()
        }
    }
    
    
}
