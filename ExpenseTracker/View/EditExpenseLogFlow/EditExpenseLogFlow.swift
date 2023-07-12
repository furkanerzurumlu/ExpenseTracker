//
//  EditExpenseLogFlow.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 12.07.2023.
//

import UIKit

class EditExpenseLogFlow: UIViewController {
    
    @IBOutlet weak var categoryTextField: UITextField!
    let pickerView = UIPickerView()
    let categoryOptions = ["Donation","Entertainment","Food","Health","Shopping","Transportation","Utilities"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        rightSaveButton()
        leftCancelButton()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        categoryTextField.inputView = pickerView
        
        categoryTextField.placeholder = "Selected"
        categoryTextField.attributedPlaceholder = NSAttributedString(string: "Selected", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        categoryTextField.tintColor = .clear
        categoryTextField.textColor = .systemBlue
        categoryTextField.borderStyle = .none
    }
  
    private func setViewController(){
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Edit Exponse Log"
    }
    
    func leftCancelButton(){
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func cancelButtonTapped(){
        print("Cancel succesful")
    }
    func rightSaveButton(){
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func saveButtonTapped() {
        print("Save succesful")
    }
    
    
}

extension EditExpenseLogFlow: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = categoryOptions[row]
        categoryTextField.text = selectedCategory
        categoryTextField.resignFirstResponder()
    }
}
