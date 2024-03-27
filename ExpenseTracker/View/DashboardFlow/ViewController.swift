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
    
    private var stackViewArray: [UIStackView] = []
    
    var selectedCategoryTotal: Double = 0.0
    
    var previousSelectedIndex: Int?
    var viewModel = DashboardVM()
    var totalPrice = 0
    
    let colors: [UIColor] = [
        UIColor(hex: 0xFF6F61),
        UIColor(hex: 0x6B5B95),
        UIColor(hex: 0x70C1B3),
        UIColor(hex: 0xFFD166),
        UIColor(hex: 0x7DBEA5),
        UIColor(hex: 0xE5989B),
        UIColor(hex: 0xB565A7),
        UIColor(hex: 0xFFA600)
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getAllData()
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
        
        setTabBar()
        setupPieChart()
        
        pieView.delegate = self
        
        stackViewArray.append(donationStackView)
        stackViewArray.append(entertainmentStackView)
        stackViewArray.append(foodStackView)
        stackViewArray.append(healthStackView)
        stackViewArray.append(shoppingStackView)
        stackViewArray.append(transportationStackView)
        stackViewArray.append(utilitiesStackView)
        stackViewArray.append(otherStackView)
        
        for addIndex in 0...7 {
            setCategoryStackView(stackView: stackViewArray[addIndex], colorHex: colors[addIndex])
        }
        
        
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor.gray.cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        //totalExpenditure()
        //print("Total: \(viewModel.priceArray.count)")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("Deneme"), object: nil)
        viewModel.getAllData()
        getItemForUI()
        pieView.animate(xAxisDuration: 2.0, easingOption: .easeOutBack)
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
    
    func getItemForUI(){
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
        configurePieChartCenterText(centerText: String(total))
        
        print("total: \(total)")
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
    }
    
    
    func setupPieChart(){
        pieView.drawEntryLabelsEnabled = true
        pieView.legend.enabled = false
        pieView.drawEntryLabelsEnabled = false
        pieView.drawHoleEnabled = true
        pieView.holeRadiusPercent = 0.4 // Deliğin yarıçapı, tam yüzde cinsinden (%50)
        pieView.holeColor = UIColor.white // Deliğin rengi
        
        let totalValue = calculateCategoryTotal(category: "Tüm Kategoriler", prices: viewModel.priceArray)
        
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
    
    func configurePieChartCenterText(centerText: String){
        pieView.drawCenterTextEnabled = true
        let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17) ]
        let myAttrString = NSAttributedString(string: String(centerText), attributes: myAttribute)
        
        pieView.centerAttributedText = myAttrString
    }
    
}

extension ViewController: ChartViewDelegate {
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = chartView.data?.dataSets[ highlight.dataSetIndex] {
            let sliceIndex: Int = dataSet.entryIndex(entry: entry)
            print("Seçilen dilim indeksi: \(sliceIndex.description)")
            print("$ \(viewModel.categoryTotalPrice[sliceIndex])")
            let selectedCategoryValue = viewModel.categoryTotalPrice[sliceIndex]
            
            let centerText = "$\(selectedCategoryValue)"
            configurePieChartCenterText(centerText: centerText)
            
            if let prevIndex = previousSelectedIndex {
                stackViewArray[prevIndex].backgroundColor = UIColor.clear
                stackViewArray[prevIndex].layer.borderColor = colors[prevIndex].cgColor
                stackViewArray[prevIndex].layer.borderWidth = 1
                
            }
            
            stackViewArray[sliceIndex].backgroundColor = colors[sliceIndex]
            stackViewArray[sliceIndex].layer.borderColor = UIColor.black.cgColor
            stackViewArray[sliceIndex].layer.borderWidth = 1
            
            previousSelectedIndex = sliceIndex
        }
        
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        let totalPrice = viewModel.categoryTotalPrice
        
        let total = totalPrice.reduce(0, +)
        
        configurePieChartCenterText(centerText: String(total))
        
        for index in 0...6{
            stackViewArray[index].backgroundColor = UIColor.clear
            stackViewArray[index].layer.borderColor = colors[index].cgColor
            stackViewArray[index].layer.borderWidth = 1
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
