//
//  TabExploreViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 25/06/22.
//

import UIKit
import SwiftUI
import CoreMedia

class TabExploreViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var uiScrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var missionTableView: UITableView!
    @IBOutlet weak var lvButton: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableWidth: NSLayoutConstraint!
    
    private var listObject: [Mission] = []
    
    private var viewModel = ObjectRecogViewModel()
    
    //For Timer
    var timer = Timer()
    var timerCounter = 1
    @AppStorage("totalRunning") var showRunning = 0;
    
    //For count days use apps
    var openAppCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTable()
    }
    
    private func setupView() {
        headerView.layer.cornerRadius = 8
        
        let name = UserDefaults.standard.string(forKey: loginNameDef)
        loginNameLabel.text = "Hi \(name ?? "")"
        
        //push data to watch
        viewModel.sendMessageToIwatch(name: name, time: 0, startExplore: false)
        
        //tableview inside scroll
        tableHeight.constant = self.view.frame.height-350
        self.missionTableView.isScrollEnabled = false
        //no need to write following if checked in storyboard
        self.uiScrollView.bounces = false
        self.missionTableView.bounces = true
        
        //For Timer
        if (showRunning) > 0 {
            timerCounter += showRunning
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        //Count Days in here
        forCountingDays()
    }
    
    @objc func updateCounter() {
        if timerCounter > 0 {
            timerCounter += 1
            UserDefaults.standard.set(timerCounter, forKey: "totalRunning")
        }
    }
    
    func forCountingDays() {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        //print(formatter.string(from: .now))
        formatter.setLocalizedDateFormatFromTemplate("dd-MM-yyyy")
        let todayToString = formatter.string(from: .now)
        //print(todayToString)
        print(openAppCount)
        if(showRunning) == 0 {
            openAppCount += 1
            UserDefaults.standard.set(openAppCount, forKey: "totalDays")
            UserDefaults.standard.set(todayToString, forKey: "latestDate")
        }
        else {
            @AppStorage("totalDays") var openAppCount = 0;
            print(openAppCount)
            @State var latestDateToString = UserDefaults.standard.string(forKey: "latestDate")
            
            if(todayToString != latestDateToString) {
                openAppCount += 1
                UserDefaults.standard.set(openAppCount, forKey: "totalDays")
                UserDefaults.standard.set(todayToString, forKey: "latestDate")
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.uiScrollView {
            missionTableView.isScrollEnabled = (self.uiScrollView.contentOffset.y >= 200)
        }
        
        if scrollView == self.missionTableView {
            self.missionTableView.isScrollEnabled = (missionTableView.contentOffset.y > 0)
        }
    }
    
}

extension TabExploreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTable() {
        self.listObject.append(contentsOf: Mission.dataObject())
        UITableView.appearance().separatorColor = .clear
        
        missionTableView.dataSource = self
        missionTableView.delegate = self
        
        let nib = UINib(nibName: "MissionTableViewCell", bundle: nil)
        
        missionTableView.register(nib, forCellReuseIdentifier: "MissionTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let missionListData = listObject[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MissionTableViewCell") as! MissionTableViewCell
        
        cell.selectionStyle = .none
        cell.missions = missionListData
        cell.updateMissionsCell()
            
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listObject.count
    }
}
