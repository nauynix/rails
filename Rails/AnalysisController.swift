//
//  AnalysisController.swift
//  Rails
//
//  Created by Feng Xinyuan on 13/4/17.
//  Copyright © 2017 nyx. All rights reserved.
//

import Foundation
import Charts

class AnalysisController: UIViewController, ChartViewDelegate{
    let defaults = UserDefaults.init(suiteName: "group.nauynix.rails")
    var totalTimeUsedPerDay: [String: Int] = [:]
    var totalTimeLoggedPerDay: [String: Int] = [:] // The uptime when the widget timer is running ie. the uptime that is logged and the user is aware that he is using the phone
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var timeUsedLabel: UILabel!
    @IBOutlet weak var percentageLoggedLabel: UILabel!
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    //let tempData:[Date] = [Calendar.current.date(byAdding: .day, value: -3, to: Date())!, Calendar.current.date(byAdding: .day, value: -2, to: Date())!,Calendar.current.date(byAdding: .day, value: -1, to: Date())!]
    //let tempValue:[Double] = [80, 100, 70]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //displayLabelAndChart()
        barChartView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayLabelAndChart()
    }
    
    func displayLabelAndChart(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        //dateFormatter.dateFormat = "dd/MM"
        totalTimeUsedPerDay = (defaults?.object(forKey: "totalTimeUsedPerDay") as? [String:Int])!
        totalTimeLoggedPerDay = (defaults?.object(forKey: "totalTimeLoggedPerDay") as? [String:Int])!
        for key in totalTimeUsedPerDay.keys{
            print("date:\(key), used:\(totalTimeUsedPerDay[key]), logged:\(totalTimeLoggedPerDay[key])")
        }
        //totalTimeUsedPerDay = ["03/04":10000,"04/04":10000,"05/04":10000,"06/04":10000,"07/04":10000,"08/04":10000,"09/04":10000,"10/04":10000,"11/04":10000]
        //totalTimeLoggedPerDay = ["03/04":5000,"04/04":6000,"05/04":6000,"06/04":3000,"07/04":1000,"08/04":2000,"09/04":3000,"10/04":4000,"11/04":000]
        //totalTimeUsedPerDay = ["10/04":10000,"11/04":10000]
        //totalTimeLoggedPerDay = ["10/04":3000,"11/04":5000]
        var sortedKeys:[Date] = [] // This is used to correctly sort dates
        var sortedKeysInString:[String] = []
        for key in totalTimeUsedPerDay.keys {
            sortedKeys.append(dateFormatter.date(from: key)!)
        }
        sortedKeys.sort()
        var totalLoggedPercentage:[Double] = []
        for i in 0..<sortedKeys.count {
            totalLoggedPercentage.append(Double(totalTimeLoggedPerDay[dateFormatter.string(from: sortedKeys[i])]!) / Double(totalTimeUsedPerDay[dateFormatter.string(from: sortedKeys[i])]!))
            // sortedKeysInString will be used for lables in x-axis
            if i == sortedKeys.count - 1{ // Today
                sortedKeysInString.append("Today\n\(getHoursAndMinutesStringFromSecondsInColon(timeUsedInSeconds: totalTimeUsedPerDay[dateFormatter.string(from: sortedKeys[i])]!))\n")
            }
            else if i >= sortedKeys.count - 7{ // Past seven days
                let dateFormatterToDayOfWeek = DateFormatter()
                dateFormatterToDayOfWeek.dateFormat = "E"
                sortedKeysInString.append("\(dateFormatterToDayOfWeek.string(from: sortedKeys[i]))\n\(getHoursAndMinutesStringFromSecondsInColon(timeUsedInSeconds: totalTimeUsedPerDay[dateFormatter.string(from: sortedKeys[i])]!))\n")
            }
            else{ // Rest of the days
                let dateFormatterToDayAndMonth = DateFormatter()
                dateFormatterToDayAndMonth.dateFormat = "dd/MM"
                sortedKeysInString.append("\(dateFormatterToDayAndMonth.string(from: sortedKeys[i]))\n\(getHoursAndMinutesStringFromSecondsInColon(timeUsedInSeconds: totalTimeUsedPerDay[dateFormatter.string(from: sortedKeys[i])]!))\n")
            }
        }
        if sortedKeys.count == 0 { // No days yet
            setLabel(timeUsedInSeconds: 0, percentageLogged: 0)
        }
        else{
            setChart(dp: sortedKeysInString, v: totalLoggedPercentage)
            setLabel(timeUsedInSeconds: totalTimeUsedPerDay[dateFormatter.string(from: sortedKeys[sortedKeys.endIndex - 1])]!, percentageLogged: totalLoggedPercentage[sortedKeys.endIndex - 1]) // Get the last element which is the current day
        }
    }
    
    func setLabel(timeUsedInSeconds: Int, percentageLogged: Double){
        /*if let tracking = defaults?.bool(forKey: "isTracking"){
            if tracking {
                let timeUsedMutableString = NSMutableAttributedString(string: getHoursAndMinutesStringFromSecondsInHandM(timeUsedInSeconds: timeUsedInSeconds))
                timeUsedMutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 30), range: NSMakeRange(2, 1)) // Making "H" smaller
                timeUsedMutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 30), range: NSMakeRange(5, 1)) // Making "M" smaller
                timeUsedLabel.attributedText = timeUsedMutableString
                //percentageLoggedLabel.text = "\(Int(percentageLogged*100))%"
                percentageLoggedLabel.text = "\(timeUsedInSeconds)s"
            }
            else{
                timeUsedLabel.text = "-"
                percentageLoggedLabel.text = "-"
            }
        }
        else{ // True until user sets false...might need to change in the future
            let timeUsedMutableString = NSMutableAttributedString(string: getHoursAndMinutesStringFromSecondsInHandM(timeUsedInSeconds: timeUsedInSeconds))
            timeUsedMutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 30), range: NSMakeRange(2, 1)) // Making "H" smaller
            timeUsedMutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 30), range: NSMakeRange(5, 1)) // Making "M" smaller
            timeUsedLabel.attributedText = timeUsedMutableString
            percentageLoggedLabel.text = "\(Int(percentageLogged*100))%"
        }*/
        
        if (defaults?.bool(forKey: "isTracking"))! {
            let timeUsedMutableString = NSMutableAttributedString(string: getHoursAndMinutesStringFromSecondsInHandM(timeUsedInSeconds: timeUsedInSeconds))
            timeUsedMutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 30), range: NSMakeRange(2, 1)) // Making "H" smaller
            timeUsedMutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 30), range: NSMakeRange(5, 1)) // Making "M" smaller
            timeUsedLabel.attributedText = timeUsedMutableString
            //percentageLoggedLabel.text = "\(Int(percentageLogged*100))%"
            percentageLoggedLabel.text = "\(timeUsedInSeconds)s"
        }
        else{
            timeUsedLabel.text = "-"
            percentageLoggedLabel.text = "-"
        }

    }
    
    func getHoursAndMinutesStringFromSecondsInHandM(timeUsedInSeconds: Int) -> String{
        let stringHours = hoursFromSeconds(timeUsedInSeconds: timeUsedInSeconds)
        let stringMinutes = minutesFromSeconds(timeUsedInSeconds: timeUsedInSeconds)
        return stringHours + "H" + stringMinutes + "M"
    }
    
    func getHoursAndMinutesStringFromSecondsInColon(timeUsedInSeconds: Int) -> String{
        let stringHours = hoursFromSeconds(timeUsedInSeconds: timeUsedInSeconds)
        let stringMinutes = minutesFromSeconds(timeUsedInSeconds: timeUsedInSeconds)
        return stringHours + ":" + stringMinutes
    }
    
    func hoursFromSeconds(timeUsedInSeconds: Int) -> String{
        return String(format: "%02d", arguments: [timeUsedInSeconds / 3600])
    }
    
    func minutesFromSeconds(timeUsedInSeconds: Int) -> String{
        return String(format: "%02d", arguments: [(timeUsedInSeconds % 3600) / 60])
    }
    
    func setChart(dp: [String], v: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        barChartView.noDataText = "No data. Start using your phone!"
        var dataPoints = dp
        var values = v
        // Pad empty bar charts on the left if number of days is lesser than 7
        while dataPoints.count < 7{
            dataPoints.insert("", at: 0)
            values.insert(-1, at: 0)
        }
        for i in 0..<dataPoints.count {
            let dataEntry:BarChartDataEntry
            if values[i] == -1 { // Empty bar chart. Have to pad with array of [0,0] as the chart will cycle between the colours green and red
                dataEntry = BarChartDataEntry(x: Double(i), yValues: [0,0])
            }
            else{ // Normal bar chart
                dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i], 1 - values[i]])
            }
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Seconds Used")
        let chartData = BarChartData(dataSet: chartDataSet)
        chartDataSet.highlightEnabled = false
        chartDataSet.setColors(.green, .red)
        
        barChartView.data = chartData
        // Formatter
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        // Animation
        barChartView.animate(yAxisDuration: 0.5)
        
        // Limit line
        barChartView.leftAxis.removeAllLimitLines() // Remove existing limit lines to draw new ones
        let loggedGoalPercentage = defaults?.double(forKey: "loggedGoal")
        let ll:ChartLimitLine
        if let lGP = loggedGoalPercentage{
            ll = ChartLimitLine(limit: lGP, label: "Target")
            
            ll.drawLabelEnabled = false
            barChartView.leftAxis.drawLimitLinesBehindDataEnabled = true
            barChartView.leftAxis.addLimitLine(ll)
        }
        else{
            //ll = ChartLimitLine(limit: 0.8, label: "Target")
        }
        
        // Disabling everything to make it pretty
        // Disable showing values
        chartDataSet.drawValuesEnabled = false
        // Disable y-axis
        let left = barChartView.leftAxis
        left.drawLabelsEnabled = false
        left.drawAxisLineEnabled = false
        left.drawGridLinesEnabled = false
        left.drawZeroLineEnabled = true
        barChartView.rightAxis.enabled = false
        // Disable x-axis
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.labelPosition = .bottom
        // Disable legend
        barChartView.legend.enabled = false
        // Disable chart description
        barChartView.chartDescription?.text = ""
        //Disable zoom
        barChartView.setScaleEnabled(false)
        //Shows a maximum of 7 days (a week) and moves the view to the most recent day
        barChartView.setVisibleXRangeMaximum(7)
        barChartView.moveViewToX(1000000)
        barChartView.fitBars = false
    }
    /*
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        print("\(dataSetIndex)")
        print("\(entry.y)")
    }*/
}
