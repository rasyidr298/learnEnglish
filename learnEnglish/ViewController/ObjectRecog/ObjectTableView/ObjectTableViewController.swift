//
//  ObjectTableViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 26/06/22.
//

import UIKit

class ObjectTableViewController: UITableViewController {
        
    @IBOutlet weak var objectTableView: UITableView!
    //    @IBOutlet var objectTableView: UITableView!
    
    var listObject: [Object] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
    }
    
    func setupTable() {
        let nib = UINib(nibName: "ObjectTableViewCell", bundle: nil)
        objectTableView.register(nib, forCellReuseIdentifier: "ObjectTableViewCell")
        listObject.append(contentsOf: Object.dataObject())
//        self.view.addSubview(objectTableView)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objectListData = listObject[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectTableViewCell") as! ObjectTableViewCell
        
        cell.selectionStyle = .none
        cell.object = objectListData
        cell.updateObjectCell(itemIsMatch: true)
            
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listObject.count
    }
    
}
