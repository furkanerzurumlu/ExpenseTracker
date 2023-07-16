//
//  EditExpenseLogFlow.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 12.07.2023.
//

import UIKit

class EditExpenseLogFlow: UIViewController {
    
    @IBOutlet weak var spendingTitleTextField: UITextField!
    @IBOutlet weak var spendingView: UIStackView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceView: UIStackView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let datePickerView = UIDatePicker()
    let pickerView = UIPickerView()
    let categoryOptions = ["Donation","Entertainment","Food","Health","Shopping","Transportation","Utilities","Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        rightSaveButton()
        leftCancelButton()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
        
        datePicker.datePickerMode = .date
        
        //spendingTitleTextField.tintColor = .clear
        spendingTitleTextField.borderStyle = .none
        priceView.layer.borderColor = UIColor.gray.cgColor
        priceView.layer.borderWidth = 0.3
        
        categoryTextField.inputView = pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectButtonTapped))
        toolbar.setItems([flexibleSpace,doneButton], animated: false)
        categoryTextField.inputAccessoryView = toolbar
        
        priceTextField.borderStyle = .none
        
        categoryTextField.placeholder = "Selected"
        categoryTextField.attributedPlaceholder = NSAttributedString(string: "Selected", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        categoryTextField.tintColor = .clear
        categoryTextField.textColor = .systemBlue
        categoryTextField.borderStyle = .none
    }
    @objc func selectButtonTapped(){
        let selecetRow = pickerView.selectedRow(inComponent: 0)
        let selecetCategory = categoryOptions[selecetRow]
        
        categoryTextField.text = selecetCategory
        categoryTextField.resignFirstResponder()
    }
    private func setViewController(){
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Edit Exponse Log"
    }
    
    private func leftCancelButton(){
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func cancelButtonTapped(){
        print("Cancel succesful")
        dismiss(animated: true, completion: nil)
    }
    private func rightSaveButton(){
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
//        categoryTextField.text = selectedCategory
//        categoryTextField.resignFirstResponder()
    }
}


