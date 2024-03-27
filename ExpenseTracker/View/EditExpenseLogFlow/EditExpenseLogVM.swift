//
//  EditeExpenseLogVM.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 1.08.2023.
//

import Foundation
import UIKit
import CoreData

class EditExpenseLogVM {
    
    func saveData(value: Any, key: String){
        print("Save succesful")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context)
        
        // save all data
        //saveData.setValue(UUID(), forKey: "id")
        
        
        saveData.setValue(value, forKey: key)
        //saveData.setValue(priceTextField.text!, forKey: "price")
//        saveData.setValue(productNameTextField.text!, forKey: "product")
//        saveData.setValue(dateTextField.text!, forKey: "date")
//        saveData.setValue(categoryTextField.text!, forKey: "category")
       
        do {
            try context.save()
            print("Data Save Done")
            NotificationCenter.default.post(name: NSNotification.Name.init("newData"), object: nil)
            
        } catch {
            print("Error")
        }
        NotificationCenter.default.post(name: NSNotification.Name.init("newData"), object: nil)
        
    }
}
