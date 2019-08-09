//
//  ViewController.swift
//  SimpleChatProject
//
//  Created by 安藤奨 on 2019/08/08.
//  Copyright © 2019 安藤奨. All rights reserved.
//

import UIKit

import FirebaseFirestore

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
        
//        firestoreへ接続
        let db = Firestore.firestore()
//        自分以外の人も編集できる
//        コレクションが変更されたかを検知するリスナーを登録、ずっと監視しておく
        
//        変数だから小文字にしておく
        db.collection("room").addSnapshotListener { (querySnapshot, error) in
//            querySnapshotの中にはroomに中の全データが入っている
            guard let documents = querySnapshot?.documents else{
//                roomの中に何もない場合、処理を中断
                return
            }
//            登録をしているから一回登録するだけでオッケー
//            全件のデータをroomの中に入れ直している
//            扱いやすくするため
//            変数documentsにroomの全データがあるので
//            それを元に配列を作成し、画面を更新する
//            documentはnameやcreatedが入っている
//            .get()で値取得  any が入る　キャストする realmでも？
//            Roomを新しく作っている
//            documentIDはよくわからん文字列のやつ
            var results: [Room] = []
            for document in documents {
                let roomName = document.get("name") as! String
                let room = Room(name: roomName,documentId: document.documentID)
                
                results.append(room)
                
            }
            
//            変数roomを書き換える
            self.rooms = results
            
        }
        
        // Do any additional setup after loading the view.
    }
//ルーム作成のボタンがクリックされたとき
    @IBAction func didClickButton(_ sender: UIButton) {
//        空文字のとき
        if roomNameTextField.text!.isEmpty{
//            処理中断
            return
        }
        
//        部屋の名前を変数に保存
        let roomName = roomNameTextField.text!
        
//        firestoreにの新しい接続情報取得
        let db = Firestore.firestore()
//        firestoreに新しい部屋を追加
//        serverTimestampは登録日時
        db.collection("room").addDocument(data: ["name":roomName,"createdAt": FieldValue.serverTimestamp()]) { err in
            if let err = err{
                print("チャットルームの作成に失敗しました")
                print(err)
            } else {
                print("チャットルームを作成しました：\(roomName)")
            }
        }
        
        roomNameTextField.text = ""
        
        
        
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

