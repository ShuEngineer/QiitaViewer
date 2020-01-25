//
//  ArticleListViewController.swift
//  QiitaViewer
//
//  Created by 伊藤嵩 on 2020/01/24.
//  Copyright © 2020 Shu Ito. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleListViewController: UIViewController, UITableViewDataSource{
    
    var articles: [[String: String?]] = [] //記事を入れるプロパティを定義
    let table = UITableView() //プロパティにtableを追加
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "新着記事"  //Navigation Barのタイトルを設定
        
        table.frame = view.frame //tableの大きさをviewの大きさに合わせる
        view.addSubview(table)  //viewにtableをのせる
        table.dataSource = self //dataSouceプロパティにself（ArtcleListViewController)を代入

        getArticles()
    }
    
    
    func getArticles(){
        //Alamofire.request(method: Method, URLString: URLStringConvertible)
        let urlString = "https://qiita.com/api/v2/items"
        
        //APIへリクエストを送信
        Alamofire.request(urlString,method: .get)
            //返ってきた情報を取得
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                let json = JSON(object)
                json.forEach{ (_, json) in
                    let article: [String: String?] = [
                        "title": json["title"].string,
                        "userId": json["user"]["id"].string
                    ] //１つに記事を表すための辞書型を作成
                    self.articles.append(article) //配列に入れる
                }
                self.table.reloadData() // TableViewを更新
             }
    }
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    //セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell") // Subtitleのあるセルを生成
        let article = articles[indexPath.row]//行数番目の記事を取得
        cell.textLabel?.text = article["title"]! //記事のタイトルをtextLabelにセット
        cell.detailTextLabel?.text = article["userId"]! //投稿者のユーザーidをdetailTextLabelにセット
        return cell // cellを返す
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
