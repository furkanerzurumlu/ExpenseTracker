//
//  ItemFile.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 31.07.2023.
//

import Foundation

class ItemModel{
    var id: String?
    var date: String?
    var price: Int?
    var product: String?
    
    init(id: String? = nil, date: String? = nil, price: Int? = nil, product: String? = nil) {
        self.id = id
        self.date = date
        self.price = price
        self.product = product
    }
}
