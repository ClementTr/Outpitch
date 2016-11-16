//
//  Friend.swift
//  Outpitch
//
//  Created by Clément Tailleur on 17/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit
import Charts

class Friend: UIViewController {

    @IBOutlet weak var LBL_TITLE: UINavigationItem!
    
    
    @IBOutlet weak var IV_CLUB: UIImageView!
    @IBOutlet weak var IV_NATION: UIImageView!
    @IBOutlet weak var LBL_FIRSTNAME: UILabel!
    @IBOutlet weak var LBL_LASTNAME: UILabel!
    @IBOutlet weak var LBL_AGE: UILabel!
    @IBOutlet weak var LBL_POSITION: UILabel!
    @IBOutlet weak var LBL_GOALS: UILabel!
    @IBOutlet weak var LBL_ASSISTS: UILabel!
    @IBOutlet weak var LBL_PENALTIES: UILabel!
    @IBOutlet weak var LBL_PREASSISTS: UILabel!
    @IBOutlet weak var LBL_YC: UILabel!
    @IBOutlet weak var LBL_RC: UILabel!
    
    @IBOutlet weak var LBL_MY_NAME: UILabel!
    @IBOutlet weak var LBL_FRIEND_NAME: UILabel!
    
    @IBOutlet weak var LBL_MY_GOALS: UILabel!
    @IBOutlet weak var PC_GOALS: PieChartView!
    @IBOutlet weak var LBL_FRIEND_GOALS: UILabel!
    
    @IBOutlet weak var LBL_MY_ASSISTS: UILabel!
    @IBOutlet weak var PC_ASSISTS: PieChartView!
    @IBOutlet weak var LBL_FRIEND_ASSISTS: UILabel!
    
    @IBOutlet weak var LBL_MY_PENALTIES: UILabel!
    @IBOutlet weak var PC_PENALTIES: PieChartView!
    @IBOutlet weak var LBL_FRIEND_PENALTIES: UILabel!
    
    @IBOutlet weak var LBL_MY_PREASSISTS: UILabel!
    @IBOutlet weak var PC_PREASSISTS: PieChartView!
    @IBOutlet weak var LBL_FRIEND_PREASSISTS: UILabel!
    
    @IBOutlet weak var LBL_MY_YC: UILabel!
    @IBOutlet weak var PC_YC: PieChartView!
    @IBOutlet weak var LBL_FRIEND_YC: UILabel!
    
    @IBOutlet weak var LBL_MY_RC: UILabel!
    @IBOutlet weak var PC_RC: PieChartView!
    @IBOutlet weak var LBL_FRIEND_RC: UILabel!
    
    
    
    var compare :[String] = ["Him", "You"]
    var goalsCompared :[Double] = [0.0, 0.0]
    var assistsCompared :[Double] = [0.0, 0.0]
    var penaltiesCompared :[Double] = [0.0, 0.0]
    var preassistsCompared :[Double] = [0.0, 0.0]
    var ycCompared :[Double] = [0.0, 0.0]
    var rcCompared :[Double] = [0.0, 0.0]
    
    var friend = String()
    
    var nationlink = String()
    var clublink = String()
    
    var position = String()
    var firstname = String()
    var lastname = String()
    var age = String()
    var goals = String()
    var assists = String()
    var penalties = String()
    var preassists = String()
    var ycard = String()
    var rcard = String()
    
    var Diaby = String()
    var MOTM = String()
    var FOTM = String()
    var Ronaldinho = String()
    var Dejong = String()
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LBL_TITLE.title = friend
        
        IV_NATION.image = UIImage(named: nationlink)
        IV_CLUB.image = UIImage(named: clublink)
        
        LBL_MY_NAME.text = (maVariableIneffacable.valueForKey("FIRSTNAME") as? String)!
        LBL_FRIEND_NAME.text = firstname
        
        LBL_POSITION.text = position
        LBL_FIRSTNAME.text = firstname
        LBL_LASTNAME.text = lastname
        LBL_AGE.text = age + " years old"
        LBL_GOALS.text = goals
        LBL_ASSISTS.text = assists
        LBL_PENALTIES.text = penalties
        LBL_PREASSISTS.text = preassists
        LBL_YC.text = ycard
        LBL_RC.text = rcard
        
        self.LBL_MY_GOALS.text = (maVariableIneffacable.valueForKey("GOALS") as? String)!
        self.LBL_MY_ASSISTS.text = (maVariableIneffacable.valueForKey("ASSISTS") as? String)!
        self.LBL_MY_PREASSISTS.text = (maVariableIneffacable.valueForKey("PREASSISTS") as? String)!
        self.LBL_MY_PENALTIES.text = (maVariableIneffacable.valueForKey("PENALTIES") as? String)!
        self.LBL_MY_YC.text = (maVariableIneffacable.valueForKey("YC") as? String)!
        self.LBL_MY_RC.text = (maVariableIneffacable.valueForKey("RC") as? String)!
        
        LBL_FRIEND_GOALS.text = goals
        LBL_FRIEND_ASSISTS.text = assists
        LBL_FRIEND_PREASSISTS.text = preassists
        LBL_FRIEND_PENALTIES.text = penalties
        LBL_FRIEND_YC.text = ycard
        LBL_FRIEND_RC.text = rcard
        
        goalsCompared = [Double(goals)!, Double(LBL_MY_GOALS.text!)!]
        assistsCompared = [Double(assists)!, Double(LBL_MY_ASSISTS.text!)!]
        penaltiesCompared = [Double(penalties)!, Double(LBL_MY_PENALTIES.text!)!]
        preassistsCompared = [Double(preassists)!, Double(LBL_MY_PREASSISTS.text!)!]
        ycCompared = [Double(ycard)!, Double(LBL_MY_YC.text!)!]
        rcCompared = [Double(rcard)!, Double(LBL_MY_RC.text!)!]
        
        setChart(compare, values: goalsCompared, chart: PC_GOALS)
        setChart(compare, values: assistsCompared, chart: PC_ASSISTS)
        setChart(compare, values: penaltiesCompared, chart: PC_PENALTIES)
        setChart(compare, values: preassistsCompared, chart: PC_PREASSISTS)
        setChart(compare, values: ycCompared, chart: PC_YC)
        setChart(compare, values: rcCompared, chart: PC_RC)
        
    }
    func setChart(dataPoints: [String], values: [Double], chart: PieChartView) {
        
        
        chart.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        chart.data = pieChartData
        chart.descriptionText = ""
        chart.legend.enabled = false
        var colors: [UIColor] = []
        colors = [UIColor.redColor(), UIColor.greenColor()]
        
        pieChartDataSet.colors = colors
    }
    
        

    
}
