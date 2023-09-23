//
//  EditExpenseLogFlow.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 12.07.2023.
//

import UIKit
import CoreData

class EditExpenseLogFlow: UIViewController {
    
    // MARK: All Veriables
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var spendingView: UIStackView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceView: UIStackView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    
    private var datePicker = UIDatePicker()
    private let pickerView = UIPickerView()
    private let categoryOptions = ["Donation","Entertainment","Food","Health","Shopping","Transportion","Utilities","Other"]
    
    var viewModel = EditExpenseLogVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        let context = appDelegate.persistentContainer.viewContext
        //        let newExpense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context)
        
        
        productNameTextField.layer.cornerRadius = 10
        productNameTextField.layer.borderWidth = 1
        productNameTextField.layer.borderColor = UIColor.systemBlue.cgColor
        
        priceTextField.layer.cornerRadius = 10
        priceTextField.layer.borderWidth = 1
        priceTextField.layer.borderColor = UIColor.systemBlue.cgColor
        
        setViewController()
        rightSaveButton()
        leftCancelButton()
        
        setCategorySelectedTextField()
        setPriceTextField()
        
        createDatePicker()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let toDay = Date()
        let todayFormatted = dateFormatter.string(from: toDay)
        dateTextField.text = todayFormatted
        
        
        productNameTextField.placeholder = "Enter Expense"
        
        dateTextField.tintColor = .clear
        dateTextField.textColor = .systemBlue
        dateTextField.borderStyle = .none
        
    }
    
    // MARK: Set DatePicker
    func createToolbar() -> UIToolbar {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    func createDatePicker(){
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = createToolbar()
    }
    
    @objc func donePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
        
    }
    
    // MARK: Select Price Action
    private func setPriceTextField(){
        //        priceView.layer.borderColor = UIColor.gray.cgColor
        //        priceView.layer.borderWidth = 0.3
        
        
        
        let dolarLabel = UILabel()
        dolarLabel.text = " $"
        dolarLabel.font = UIFont.systemFont(ofSize: 18)
        dolarLabel.sizeToFit()
        priceTextField.leftView = dolarLabel
        priceTextField.leftViewMode = .always
        
        priceTextField.tintColor = .clear
        priceTextField.borderStyle = .none
        priceTextField.placeholder = " 19.99"
        
        //        priceTextField.delegate = self
        //        priceTextField.keyboardType =vi .numberPad
    }
    
    // MARK: Select Category Action
    private func setCategorySelectedTextField(){
        categoryTextField.inputView = pickerView
        categoryTextField.placeholder = "Selected"
        categoryTextField.attributedPlaceholder = NSAttributedString(string: "Selected", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        categoryTextField.tintColor = .clear
        categoryTextField.textColor = .systemBlue
        categoryTextField.borderStyle = .none
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectButtonTapped))
        toolbar.setItems([flexibleSpace,doneButton], animated: false)
        categoryTextField.inputAccessoryView = toolbar
    }
    
    @objc func selectButtonTapped(){
        let selecetRow = pickerView.selectedRow(inComponent: 0)
        let selecetCategory = categoryOptions[selecetRow]
        
        categoryTextField.text = selecetCategory
        categoryTextField.resignFirstResponder()
        print("Seçilen kategori: \(selecetCategory)")
    }
    
    // MARK: Set ViewController Function
    private func setViewController(){
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Edit Exponse Log"
    }
    
    // MARK: Cancel Button Action
    private func leftCancelButton(){
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func cancelButtonTapped(){
        print("Cancel succesful")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Save Button Action
    private func rightSaveButton(){
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        
    }
    @objc func saveButtonTapped() {
        //                let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //                let managedContext = appDelegate.persistentContainer.viewContext
        //
        //                // Silmek istediğiniz Entity adını buraya girin
        //                let entityName = "Expense"
        //
        //                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        //
        //                // Silinecek tüm verileri çekmek için fetch request'i kullanın
        //                do {
        //                    let records = try managedContext.fetch(fetchRequest)
        //                    for record in records {
        //                        if let object = record as? NSManagedObject {
        //                            // Her veriyi silebilirsiniz
        //                            managedContext.delete(object)
        //                        }
        //                    }
        //
        //                    // Verileri kaydedin
        //                    try managedContext.save()
        //
        //                    print("Tüm veriler başarıyla silindi.")
        //                } catch {
        //                    print("Hata oluştu: Veriler silinemedi.")
        //                }
        
        
        
        
        viewModel.saveData(value: UUID(), key: "id")
        viewModel.saveData(value: productNameTextField.text!, key: "product")
        //        viewModel.saveData(value: priceTextField.text!, key: "price")
        if let priceText = priceTextField.text, let priceNumber = Double(priceText){
            viewModel.saveData(value: NSNumber(value: priceNumber), key: "price")
        }
        
        viewModel.saveData(value: dateTextField.text!, key: "date")
        viewModel.saveData(value: categoryTextField.text!, key: "category")
        
        
        NotificationCenter.default.post(name: NSNotification.Name.init("newData"), object: nil)
        dismiss(animated: true, completion: nil)
        
        
    }
    
}

// MARK: Category Picker View
extension EditExpenseLogFlow: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categoryOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return categoryOptions[row]
        
        return categoryOptions[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //let selectedCategory = categoryOptions[row]
        //        categoryTextField.text = selectedCategory
        //        categoryTextField.resignFirstResponder()
        
        let selectedCategory = categoryOptions[row]
        print("Selected Category = \(selectedCategory)")
        
        
    }
}

// MARK: TextField Extension
//extension EditExpenseLogFlow: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let allowedCharecters = CharacterSet(charactersIn: "0123456789")
//        let characterSet = CharacterSet(charactersIn: string)
//        return allowedCharecters.isSuperset(of: characterSet)
//    }
//}
