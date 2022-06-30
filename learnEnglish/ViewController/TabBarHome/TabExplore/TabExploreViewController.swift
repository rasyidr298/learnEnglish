//
//  TabExploreViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 25/06/22.
//

import UIKit

class TabExploreViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var uiScrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var missionTableView: UITableView!
    @IBOutlet weak var lvButton: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableWidth: NSLayoutConstraint!
    
    var listObject: [Mission] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTable()
        tableHeight.constant = self.view.frame.height-350
        self.missionTableView.isScrollEnabled = false
        //no need to write following if checked in storyboard
        self.uiScrollView.bounces = false
        self.missionTableView.bounces = true
    }
    
    func setupView() {
        headerView.layer.cornerRadius = 8
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
