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
    
    @IBOutlet weak var donationPriceLabel: UILabel!
    @IBOutlet weak var entertainmentPrieceLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var healthPriceLabel: UILabel!
    @IBOutlet weak var shoppingPriceLabel: UILabel!
    @IBOutlet weak var transportainPriceLabel: UILabel!
    @IBOutlet weak var utilitiesPriceLabel: UILabel!
    @IBOutlet weak var otherPriceLabel: UILabel!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
        
        setTabBar()
        setupPieChart()
        
        let donationTotal = calculateCategoryTotal(category: "Donation", prices: viewModel.priceArray)
        donationPriceLabel.text = donationTotal != 0 ? "$\(String(donationTotal))" : "$0"
        donationPriceLabel.textColor = UIColor(hex: 0xFF5733)
        
        
        let entertainmentTotal = calculateCategoryTotal(category: "Entertainment", prices: viewModel.priceArray)
        entertainmentPrieceLabel.text = entertainmentTotal != 0 ? "$\(String(entertainmentTotal))" : "$0"
        
        let foodTotal = calculateCategoryTotal(category: "Food", prices: viewModel.priceArray)
        foodPriceLabel.text = foodTotal != 0 ? "$\(String(foodTotal))" : "$0"
        
        let healthTotal = calculateCategoryTotal(category: "Health", prices: viewModel.priceArray)
        healthPriceLabel.text = healthTotal != 0 ? "$\(String(healthTotal))" : "$0"
        
        let shoppingTotal = calculateCategoryTotal(category: "Shopping", prices: viewModel.priceArray)
        shoppingPriceLabel.text = shoppingTotal != 0 ? "$\(String(shoppingTotal))" : "$0"
        
        let transportionTotal = calculateCategoryTotal(category: "Transportion", prices: viewModel.priceArray)
        transportainPriceLabel.text = transportionTotal != 0 ? "$\(String(transportionTotal))" : "$0"
        
        let utilitiesTotal = calculateCategoryTotal(category: "Utilities", prices: viewModel.priceArray)
        utilitiesPriceLabel.text = utilitiesTotal != 0 ? "$\(String(utilitiesTotal))" : "$0"
        
        let otherTotal = calculateCategoryTotal(category: "Other", prices: viewModel.priceArray)
        otherPriceLabel.text = otherTotal != 0 ? "$\(String(otherTotal))" : "$0"

        
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor.gray.cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        totalExpenditure()
        print("Total: \(viewModel.priceArray.count)")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
        //NotificationCenter.default.removeObserver("newData")
        viewModel.getAllData()

        
        
    }
    @objc func getData(){
        viewModel.getAllData()
    }
    
    func calculateCategoryTotal(category: String, prices: [Int]) -> Int{
        let filteredPrices = prices.filter { $0 != 0 }
            var total = 0
            
            for (index, categoryName) in viewModel.categoryNameArray.enumerated() {
                if categoryName == category {
                    total += filteredPrices[index]
                }
            }
            
            return total

    }
    
    
    func setTabBar(){
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: "circleChart")?.withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items?[0].title = ""
        self.tabBarController?.tabBar.items?[1].image = UIImage(named: "document")?.withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items?[1].title = ""
        
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
