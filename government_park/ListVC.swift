//
//  ListVC.swift
//  government_park
//
//  Created by YiGan on 26/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class ListVC: UIViewController {
    
    @IBOutlet weak var neededTableView: UITableView!
    @IBOutlet weak var preparedTableView: UITableView!
    
    //MARK:- init-------------------------------------------------------
    override func viewDidLoad() {
        
    }
}

//MARK:- tableview delegate
extension ListVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tag = tableView.tag
        
        if tag == 0{
            return 12
        }
        return 32
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tag = tableView.tag
        return tag == 0 ? "需要准备的材料" : "已经准备好的材料"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = preparedTableView.dequeueReusableCell(withIdentifier: "cell") as! ListCell
        return cell
    }
}
