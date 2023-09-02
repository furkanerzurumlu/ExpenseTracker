//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 9.07.2023.
//

import UIKit
import Charts
import DGCharts

class ViewController: UIViewController {
    
    @IBOutlet weak var pieView: PieChartView!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    let colors: [UIColor] = [
        UIColor(hex: 0xFF5733),
        UIColor(hex: 0xE74C3C),
        UIColor(hex: 0x3498DB),
        UIColor(hex: 0x1ABC9C),
        UIColor(hex: 0x9B59B6),
        UIColor(hex: 0xF39C12),
        UIColor(hex: 0x16A085),
        UIColor(hex: 0xF39C12)
    ]
    
    var viewModel = DashboardVM()
    var totalPrice = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getAllData()
        
        setTabBar()
        setupPieChart()
        
        totalExpenditure()
        print("Total: \(viewModel.priceArray.count)")
        
    }
    
    func setTabBar(){
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: "circleChart")
        self.tabBarController?.tabBar.items?[0].title = "Dashboard"
        self.tabBarController?.tabBar.items?[1].image = UIImage(named: "document")
        self.tabBarController?.tabBar.items?[1].title = "Logs"
        
    }
    
    func setupPieChart(){
        var dataEntries: [ChartDataEntry] = []
        
        let values: [Double] = [10.0, 10.0, 20.0, 10.0, 10.0, 10.0, 20.0, 10.0]
        for (index, value) in values.enumerated() {
            let entry = PieChartDataEntry(value: value, label: "Segment \(index)")
            dataEntries.append(entry)
        }
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        
        
        
        dataSet.colors = colors
        dataSet.valueTextColor = .black
        dataSet.entryLabelColor = .white
        dataSet.sliceSpace = 3
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.multiplier = 1
        numberFormatter.percentSymbol = "%"
        dataSet.valueFormatter = DefaultValueFormatter(formatter: numberFormatter)
        
        let data = PieChartData(dataSet: dataSet)
        pieView.data = data
        
        pieView.legend.enabled = true
        pieView.drawEntryLabelsEnabled = false
        pieView.drawHoleEnabled = false
        pieView.legend.enabled = false
        
    }
    
    func totalExpenditure(){
        for index in viewModel.priceArray {
            if let intValue = index as? Int {
                totalPrice += intValue
//                print("Total Price: \(totalPrice)")
                totalPriceLabel.text = "$\(totalPrice).00"
            }
            
        }
    }
    
}

extension NSUIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Bilinmeyen Kırmızı Komponent")
        assert(green >= 0 && green <= 255, "Bilinmeyen Yeşil Komponent")
        assert(blue >= 0 && blue <= 255, "Bilinmeyen Mavi Komponent")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    
}
