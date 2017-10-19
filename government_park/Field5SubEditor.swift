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
    
    var optionList = [Option]()
    var closure: ((Option)->())?
    
    //MARK:- init----------------------------------------
    override func viewDidLoad() {
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createContents()
    }
    
    private func config(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifer)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func createContents(){
        tableView.reloadData()
    }
}

//MARK:- tableView delegate
extension Field5SubEditor: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer) ?? UITableViewCell(style: .default, reuseIdentifier: identifer)
        cell.textLabel?.text = optionList[row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let selectedOption = optionList[row]
        closure?(selectedOption)
        navigationController?.popViewController(animated: true)
    }
}
