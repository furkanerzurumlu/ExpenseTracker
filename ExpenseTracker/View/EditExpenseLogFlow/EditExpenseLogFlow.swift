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
    private let categoryOptions = ["Donation","Entertainment","Food","Health","Shopping","Transportation","Utilities","Other"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        let context = appDelegate.persistentContainer.viewContext
        //        let newExpense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context)
        
        
        
        setViewController()
        rightSaveButton()
        leftCancelButton()
        
        setCategorySelectedTextField()
        setPriceTextField()
        
        createDatePicker()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yyyy"
        let toDay = Date()
        let todayFormatted = dateFormatter.string(from: toDay)
        dateTextField.text = todayFormatted
        
        productNameTextField.borderStyle = .none
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
        priceView.layer.borderColor = UIColor.gray.cgColor
        priceView.layer.borderWidth = 0.3
        
        priceTextField.borderStyle = .none
        
        let dolarLabel = UILabel()
        dolarLabel.text = "$"
        dolarLabel.font = UIFont.systemFont(ofSize: 22)
        dolarLabel.sizeToFit()
        priceTextField.leftView = dolarLabel
        priceTextField.leftViewMode = .always
        
        priceTextField.tintColor = .clear
        priceTextField.borderStyle = .none
        
        priceTextField.delegate = self
        priceTextField.keyboardType = .numberPad
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
        print(selecetCategory)
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
        print("Save succesful")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context)
        
        // save all data
        saveData.setValue(UUID(), forKey: "id")
        //saveData.setValue(priceTextField.text!, forKey: "price")
        saveData.setValue(productNameTextField.text!, forKey: "product")
        
        do {
            try context.save()
            print("Data Save Done")
        } catch {
            print("Error")
        }
        NotificationCenter.default.post(name: NSNotification.Name.init("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
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
extension EditExpenseLogFlow: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharecters = CharacterSet(charactersIn: "0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharecters.isSuperset(of: characterSet)
    }
}
