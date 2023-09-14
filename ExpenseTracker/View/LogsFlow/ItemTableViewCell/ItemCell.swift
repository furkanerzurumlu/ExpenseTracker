//
//  ItemCell.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 31.07.2023.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var productLabelText: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var priceLabelText: UILabel!
    @IBOutlet weak var dateLabelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
}

extension ItemCell {
    static var identifer: String{
        return String(describing: Self.self)
    }
    static var nibName: UINib{
        return UINib(nibName: identifer, bundle: nil)
    }
}
