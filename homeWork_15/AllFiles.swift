//
//  AllFiles.swift
//  homeWork_15
//
//  Created by Дмитрий Яковлев on 03.01.2020.
//  Copyright © 2020 Дмитрий Яковлев. All rights reserved.
//

import UIKit

class AllFiles: UIViewController {
    
    var tmp :[URL] = []
    
    let cellIdentifier = "fileCell"
    
    var postModel: PostModel?
    
    @IBOutlet weak var filesTable: UITableView!
    
    private struct cellActionSettings{
        var title : String //"Check"
        var bColor : UIColor
        var aType : UITableViewCell.AccessoryType
        
        init(initTitle : String , initColor : UIColor, initAType : UITableViewCell.AccessoryType){
            title = initTitle
            bColor = initColor
            aType = initAType
        }
    }
    enum cellActions{
        case delete
        case deleteAll
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        tmp = FileManager.default.urls(for: docURL.appendingPathComponent("imgs")) ?? []
        
        
        filesTable.delegate = self
        filesTable.dataSource = self
        
    }
}

// MARK: - TableView Delegate extension
extension AllFiles : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath)
        let actionSettings = createTypeActionSettings(cell: cell!,toDo: .delete)
        let action = UIContextualAction(style: .normal, title: actionSettings.title) { (action, view, completionHandler) in
            self.deleteItem(indexPath: indexPath, tableView: tableView)
            completionHandler(true)
        }
        action.backgroundColor = actionSettings.bColor
        
        let actionDeleteAllSettings = createTypeActionSettings(cell: cell!,toDo: .deleteAll)
        let actionDeleteAll = UIContextualAction(style: .normal, title: actionDeleteAllSettings.title) { (action, view, completionHandler) in
            self.deleteAllItem(tableView: tableView)
            
            completionHandler(true)
        }
        actionDeleteAll.backgroundColor = actionDeleteAllSettings.bColor
        
        let configuration = UISwipeActionsConfiguration(actions: [action, actionDeleteAll])
        return configuration
        
        
    }
    
    private func createTypeActionSettings(cell: UITableViewCell, toDo : cellActions) -> cellActionSettings{
        var settings : cellActionSettings
        
        switch toDo {
        case .delete:
            settings = cellActionSettings(initTitle: "Удалить", initColor: UIColor.red, initAType: .none)
        case .deleteAll:
            settings = cellActionSettings(initTitle: "Очистить таблицу", initColor: UIColor.purple, initAType: .none)
        }
        return settings
    }
    
    private func deleteItem(indexPath: IndexPath ,tableView : UITableView){
        tableView.beginUpdates()
        tableView.deleteRows(at: [ indexPath ], with: .automatic)
        print(tmp[indexPath.row].absoluteString)
        
        postModel?.fileModel.deleteFile(url: tmp[indexPath.row])
        
        tmp.remove(at: indexPath.row)
        tableView.endUpdates()
    }
    
    //MARK:- function for delete all items from TableView and tableModel
    
    private func deleteAllItem(tableView : UITableView){
        for url in tmp {
            postModel?.fileModel.deleteFile(url: url)
        }
        tmp.removeAll()
        tableView.reloadData()
    }
    
}

// MARK: - TableView Data Sourse extension
extension AllFiles : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row) - \(tmp[indexPath.row].lastPathComponent)"
        
        return cell
    }
}
