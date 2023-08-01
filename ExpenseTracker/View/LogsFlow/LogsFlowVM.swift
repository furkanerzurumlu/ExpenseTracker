//
//  LogsFlowVM.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 31.07.2023.
//

import Foundation
import UIKit
import CoreData


protocol LogsFlowVMDelegate: AnyObject {
    func refreshTableView()
}

class LogsFlowVM {
    
    weak var delegate: LogsFlowVMDelegate?
    var refreshTableView: (() -> Void)?
    var itemList = [ItemModel]()
    
    var idArray = [UUID]()
    var dateArray = [String]()
    var priceArray = [Int]()
    var productNameArray = [String]()
    var categoryNameArray = [String]()
    
    func getAllData(){
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
//        fetchRequest.returnsObjectsAsFaults = false
//
//        do{
//            let results = try context.fetch(fetchRequest)
//            for result in results as! [NSManagedObject]{
//
//                if let id = result.value(forKey: "id") as? UUID {
//                    self.idArray.append(id)
//                }
//                if let date = result.value(forKey: "date") as? String {
//                    self.dateArray.append(date)
//                }
//                if let product = result.value(forKey: "product") as? String {
//                    self.productNameArray.append(product)
//                }
//                if let category = result.value(forKey: "category") as? String {
//                    self.categoryNameArray.append(category)
//                }
//
//                delegate?.refreshTableView()
//            }
//        } catch {
//
//        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
            fetchRequest.returnsObjectsAsFaults = false

            do {
                let results = try context.fetch(fetchRequest)
                var idArray = [UUID]()
                var dateArray = [String]()
                var productNameArray = [String]()
                var priceArray = [Int]()

                for result in results as! [NSManagedObject] {
                    if let id = result.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                    if let date = result.value(forKey: "date") as? String {
                        dateArray.append(date)
                    }
                    if let product = result.value(forKey: "product") as? String {
                        productNameArray.append(product)
                    }
                    if let price = result.value(forKey: "price") as? Int {
                        priceArray.append(price)
                    }
                }

                self.idArray = idArray
                self.dateArray = dateArray
                self.productNameArray = productNameArray
                self.priceArray = priceArray

                delegate?.refreshTableView() // Delegasyon ile tabloyu güncelliyoruz
            } catch {
                print("Error fetching data: \(error)")
            }
    }
    
    
}
