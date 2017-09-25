//
//  Field5SubEditor.swift
//  government_park
//
//  Created by YiGan on 21/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class Field5SubEditor: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let identifer = "cell"
    
    var dataList = [String]()
    var closure: ((Int, String)->())?
    
    //MARK:- init----------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    private func config(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifer)
    }
    
    private func createContents(){
        
    }
}

//MARK:- tableView delegate
extension Field5SubEditor: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer) ?? UITableViewCell(style: .default, reuseIdentifier: identifer)
        cell.textLabel?.text = dataList[row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let data = dataList[row]
        closure?(row, data)
        navigationController?.popViewController(animated: true)
    }
}
