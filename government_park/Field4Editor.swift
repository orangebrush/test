//
//  Field4Editor.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//单选编辑器

import UIKit
class Field4Editor: FieldEditor {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let identifer = "cell"
    fileprivate var selectedData: String?
    
    var dataList = [String]()
    
    //MARK:- init------------------------------------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }
    
    private func config(){
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifer)
    }
    
    private func createContents(){
        
    }

    //MARK: 保存选择
    @IBAction func save(_ sender: Any) {
        guard let selData = selectedData else {
            return
        }
        
    }
}

extension Field4Editor: UITableViewDelegate, UITableViewDataSource{
    
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
        selectedData = dataList[indexPath.row]
    }
}
