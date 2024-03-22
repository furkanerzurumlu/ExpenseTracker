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
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var donationStackView: UIStackView!
    @IBOutlet weak var entertainmentStackView: UIStackView!
    @IBOutlet weak var foodStackView: UIStackView!
    @IBOutlet weak var healthStackView: UIStackView!
    @IBOutlet weak var shoppingStackView: UIStackView!
    @IBOutlet weak var transportationStackView: UIStackView!
    @IBOutlet weak var utilitiesStackView: UIStackView!
    @IBOutlet weak var otherStackView: UIStackView!
    
    @IBOutlet weak var donationPriceLabel: UILabel!
    @IBOutlet weak var entertainmentPrieceLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var healthPriceLabel: UILabel!
    @IBOutlet weak var shoppingPriceLabel: UILabel!
    @IBOutlet weak var transportatoinPriceLabel: UILabel!
    @IBOutlet weak var utilitiesPriceLabel: UILabel!
    @IBOutlet weak var otherPriceLabel: UILabel!
    
    @IBOutlet weak var pieView: PieChartView!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var selectedCategoryTotal: Double = 0.0
    
    let colors: [UIColor] = [
        UIColor(hex: 0x007AFF),
        UIColor(hex: 0xFF9500),
        UIColor(hex: 0x4CD964),
        UIColor(hex: 0xFF2D55),
        UIColor(hex: 0x5856D6),
        UIColor(hex: 0xFFCC00),
        UIColor(hex: 0x34C759),
        UIColor(hex: 0xFF3B30)
    ]
    
    var viewModel = DashboardVM()
    var totalPrice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getAllData()
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
        
        setTabBar()
        setupPieChart()
    
        pieView.delegate = self
        
        setCategoryStackView(stackView: donationStackView, colorHex: colors[0])
        setCategoryStackView(stackView: entertainmentStackView, colorHex: colors[1])
        setCategoryStackView(stackView: foodStackView, colorHex: colors[2])
        setCategoryStackView(stackView: healthStackView, colorHex: colors[3])
        setCategoryStackView(stackView: shoppingStackView, colorHex: colors[4])
        setCategoryStackView(stackView: transportationStackView, colorHex: colors[5])
        setCategoryStackView(stackView: utilitiesStackView, colorHex: colors[6])
        setCategoryStackView(stackView: otherStackView, colorHex: colors[7])

        
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor.gray.cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        //totalExpenditure()
        print("Total: \(viewModel.priceArray.count)")
        
    }
    override func viewWillAppear(_ animated: Bool) {
       //NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
        //NotificationCenter.default.removeObserver("newData")
        viewModel.getAllData()

        //totalExpenditure()
        
    }
    @objc func getData(){
            self.viewModel.getAllData()
            //self.totalExpenditure()
    }
    
    func calculateCategoryTotal(category: String, prices: [Int]) -> Double{
        let filteredPrices = prices.filter { $0 != 0 }
            var total = 0
            
            for (index, categoryName) in viewModel.categoryNameArray.enumerated() {
                if categoryName == category {
                    total += filteredPrices[index]
                }
            }
            
        return Double(total)

    }
    
    func setTabBar(){
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: "circleChart")?.withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items?[0].title = ""
        self.tabBarController?.tabBar.items?[1].image = UIImage(named: "document")?.withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items?[1].title = ""
        
    }
    
    func setCategoryStackView(stackView: UIStackView, colorHex: UIColor){
        stackView.layer.borderColor = colorHex.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 5
        
    }
    
    func setupPieChart(){
        pieView.drawEntryLabelsEnabled = true
        
        
        var dataEntries: [ChartDataEntry] = []
        
        let donationTotal = calculateCategoryTotal(category: "Donation", prices: viewModel.priceArray)
        donationPriceLabel.text = donationTotal != 0 ? "$\(String(donationTotal))  " : "$0"
        
        let entertainmentTotal = calculateCategoryTotal(category: "Entertainment", prices: viewModel.priceArray)
        entertainmentPrieceLabel.text = entertainmentTotal != 0 ? "$\(String(entertainmentTotal))" : "$0"
        
        let foodTotal = calculateCategoryTotal(category: "Food", prices: viewModel.priceArray)
        foodPriceLabel.text = foodTotal != 0 ? "$\(String(foodTotal))" : "$0"
        
        let healthTotal = calculateCategoryTotal(category: "Health", prices: viewModel.priceArray)
        healthPriceLabel.text = healthTotal != 0 ? "$\(String(healthTotal))" : "$0"
        
        let shoppingTotal = calculateCategoryTotal(category: "Shopping", prices: viewModel.priceArray)
        shoppingPriceLabel.text = shoppingTotal != 0 ? "$\(String(shoppingTotal))" : "$0"
        
        let transportationTotal = calculateCategoryTotal(category: "Transportation", prices: viewModel.priceArray)
        transportatoinPriceLabel.text = transportationTotal != 0 ? "$\(String(transportationTotal))" : "$0"
        
        let utilitiesTotal = calculateCategoryTotal(category: "Utilities", prices: viewModel.priceArray)
        utilitiesPriceLabel.text = utilitiesTotal != 0 ? "$\(String(utilitiesTotal))" : "$0"
        
        let otherTotal = calculateCategoryTotal(category: "Other", prices: viewModel.priceArray)
        otherPriceLabel.text = otherTotal != 0 ? "$\(String(otherTotal))" : "$0"
        
        print(donationTotal+entertainmentTotal+foodTotal+healthTotal+shoppingTotal+transportationTotal+utilitiesTotal+utilitiesTotal+otherTotal)
        
        let values: [Double] = [donationTotal,
                                entertainmentTotal,
                                foodTotal,
                                healthTotal,
                                shoppingTotal,
                                transportationTotal,
                                utilitiesTotal,
                                otherTotal]
        
        viewModel.categoryTotalPrice = values
        print(values)
        print(viewModel.categoryTotalPrice)
        let total = values.reduce(0, +)
        
        self.totalPriceLabel.text = "$\(total)"

        for (index, value) in values.enumerated() {
            let percentage = (value / total) * 100.0
            let entry = PieChartDataEntry(value: percentage, label: "\(index)")
            dataEntries.append(entry)
        }
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        
        
        dataSet.colors = colors
        dataSet.valueTextColor = .black
        dataSet.entryLabelColor = .black
        dataSet.sliceSpace = 3
        
        let data = PieChartData(dataSet: dataSet)
        pieView.data = data
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.multiplier = 1
        numberFormatter.percentSymbol = " %"
        
        data.setValueFormatter(DefaultValueFormatter(formatter: numberFormatter))
        
       
        pieView.legend.enabled = false
        pieView.drawEntryLabelsEnabled = false
        //pieView.drawHoleEnabled = false
        //pieView.legend.enabled = false
       
        pieView.drawHoleEnabled = true
        pieView.holeRadiusPercent = 0.4 // Deliğin yarıçapı, tam yüzde cinsinden (%50)
        pieView.holeColor = UIColor.white // Deliğin rengi
        
        let totalValue = calculateCategoryTotal(category: "Tüm Kategoriler", prices: viewModel.priceArray)
        //let centerText = "Toplam: \(totalValue)"
       // pieView.centerText = centerText
        //pieView.drawCenterTextEnabled = true // Merkezdeki metni görünür hale getirir
    }
    
    func totalExpenditure(){
        for index in viewModel.priceArray {
            if let intValue = index as? Int {
                totalPrice += intValue
//                totalPriceLabel.text = "$\(totalPrice).00"
            }
            DispatchQueue.main.async {
                self.totalPriceLabel.text = "$\(self.totalPrice) "
            }
        }
    }
    
}

extension ViewController: ChartViewDelegate {
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = chartView.data?.dataSets[ highlight.dataSetIndex] {
               let sliceIndex: Int = dataSet.entryIndex( entry: entry)
            print( "Selected slice index: \( sliceIndex.description)")
            print("$ \( viewModel.categoryTotalPrice[sliceIndex])")
            let selectedCategoryValue = viewModel.categoryTotalPrice[sliceIndex]
            
            let centerText = "$\(selectedCategoryValue)"
            pieView.centerText = centerText
            pieView.drawCenterTextEnabled = true
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
