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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
        
        setupPieChart()
    }
    
    func setTabBar(){
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: "circleChart")
        self.tabBarController?.tabBar.items?[0].title = "Dashboard"
        self.tabBarController?.tabBar.items?[1].image = UIImage(named: "document")
        self.tabBarController?.tabBar.items?[1].title = "Logs"
        
    }
    
    func setupPieChart(){
        var dataEntries: [ChartDataEntry] = []
        
        let values: [Double] = [30.0, 40.0, 20.0, 10.0]
        for (index, value) in values.enumerated() {
            let entry = PieChartDataEntry(value: value, label: "Segment \(index)")
            dataEntries.append(entry)
        }
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = ChartColorTemplates.vordiplom()
        dataSet.valueTextColor = .white
        dataSet.entryLabelColor = .white
        
        let data = PieChartData(dataSet: dataSet)
        pieView.data = data
        
        pieView.legend.enabled = true
        pieView.drawEntryLabelsEnabled = false
        pieView.drawHoleEnabled = false
        pieView.legend.enabled = false
        
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
