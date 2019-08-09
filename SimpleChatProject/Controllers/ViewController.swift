//
//  ViewController.swift
//  SimpleChatProject
//
//  Created by 安藤奨 on 2019/08/08.
//  Copyright © 2019 安藤奨. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var roomNameTextField: UITextField!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
//    チャットの部屋一覧を保持する配列
    var rooms: [Room] = []{
//    変数が変わった時
        didSet{
//            テーブルを更新する
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    @IBAction func didClickButton(_ sender: UIButton) {
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let room = rooms[indexPath.row]
        
        cell.textLabel?.text = room.name

//        右矢印設定
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
}

