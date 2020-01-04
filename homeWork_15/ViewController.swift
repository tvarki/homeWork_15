//
//  ViewController.swift
//  homeWork_15
//
//  Created by Дмитрий Яковлев on 26.12.2019.
//  Copyright © 2019 Дмитрий Яковлев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let directoryName = "imgs"
    let postModel  = PostModel(dName: "imgs")
    let postCellIdentifier = "PostTableViewCell"
    
    @IBOutlet weak var myTableView: UITableView!
    
    var dataUpdating = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        postModel.delegate = self

        myTableView.register(UINib(nibName: postCellIdentifier, bundle: nil), forCellReuseIdentifier: postCellIdentifier)

        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.tableFooterView = UIView()
        
        
//        print(postModel.getModelCount())
    }
    
    @IBAction func showFolders(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "AllFiles") as? AllFiles else { return }
        
        viewController.postModel = postModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
//    @IBAction func showFolders(_ sender: UIButton) {
//        let controller = AllFiles()
//        navigationController?.pushViewController(controller, animated: true)
//    
//    }
}


// MARK: - TableView Delegate extension
extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate, scrollView.decelerationRate == .normal {
            
            //            postModel.initModel(t:false)
            //            self.myTableView.isScrollEnabled = false
        }
    }
    
    
}

// MARK: - TableView Data Sourse extension
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postModel.getModelCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: postCellIdentifier, for: indexPath) as? PostTableViewCell ,
            let post = postModel.getPost(at: indexPath.row) else {return PostTableViewCell()}
        
        cell.setPost(post: post)
        
        print("postModel.getModelCount() - \(postModel.getModelCount()) indexPath.row - \(indexPath.row)  postModel.batchSize \( postModel.batchSize)")
        if (postModel.getModelCount() - indexPath.row) == 1 ,
            !dataUpdating{
            
            dataUpdating = true
            postModel.initModel(t:false)
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}


extension ViewController: ModelUpdating{
    func showError(error: String) {
        self.makeAlert(title: "Внимание", text: "Ошибка во время работы с сетью: \n \(error)")
        self.myTableView.isScrollEnabled = true
        
    }
    
    func updateModel() {
        DispatchQueue.main.async {
            self.myTableView.reloadData()
            //                self.refreshControl.endRefreshing()
            self.dataUpdating = false
            self.myTableView.isScrollEnabled = true
        }
    }
    
    func makeAlert(title: String , text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
}
