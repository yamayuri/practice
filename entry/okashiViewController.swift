//
//  okashiViewController.swift
//  entry
//
//  Created by User13 on 2018/03/21.
//  Copyright © 2018年 SunQ Inc. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class okashiViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SFSafariViewControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.72, green: 0.84, blue: 0.86, alpha: 1.0)

        //search Barのdelegate通知先を設定
        searchText.delegate = self
        
        //入力のヒントとなるプレースホルダを設定
        searchText.placeholder = "お菓子の名前を入力してください。"
        
        //table VierのdataSourceを設定
        tableView.dataSource = self
        
        //table viewのdelegateを設定
        tableView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //お菓子のリスト（タプル配列）
    var okashiList : [(maker:String , name: String , link:URL , image:URL , price:String)] = []
    
    
    //検索ボタンをクリック時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //キーボードを閉じる
        view.endEditing(true)
        
        if let searchWord = searchBar.text{
            //デバックエリアに出力
            print(searchWord)
            
            //入力されていたらお菓子を検索
            searchOkashi(keyword: searchWord)

        }
    }
    
    //キャッシュ用
    var imageCache = NSCache<AnyObject, UIImage>()
    
    //JSONのitemデータ構造
    struct ItemJson : Codable {
        //お菓子の名称
        let name: String?
        //メーカー
        let maker: String?
        //掲載URL
        let url: URL?
        //画像URL
        let image: URL?
        //価格
        let price: String?
    }
    
    //JSONのデータ構造
    struct ResultJson : Codable {
        //複数要素
        let item:[ItemJson]?
    }
    
    //searchOkashiメソッド
    //第一引数：keyword 検索したいワード
    func searchOkashi(keyword : String){
        //お菓子の検索キーワードをURLエンコードする
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters : .urlQueryAllowed)else{
            return
        }
        
        //リクエストのURLの組み立て
        guard let req_url = URL(string: "http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else{
            return
        }
        print(req_url)
        
        
        //リクエストに必要な情報を生成
        let req = URLRequest(url: req_url)
        //データ転送を管理するためのセッションを生成
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data ,response ,error)in
            //セッションを終了
            session.finishTasksAndInvalidate()
            
            //do try catchエラーハンドリング
            do{
                //JSONDecoderのインスタンス取得
                let decoder = JSONDecoder()
                //受け取ったJSONのデータをパース（解析）して格納
                //データが入ってなかったらここで落ちる→initでdecodeの処理を決められる
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                //お菓子の情報が取得できているか確認
                if let items = json.item{
                    //お菓子のリストを初期化
                    self.okashiList.removeAll()
                    //取得しているお菓子の数だけ処理
                    for item in items {
                        //メーカー名、お菓子の名称、掲載URL、画像URLをアンラップ
                        if let maker = item.maker, let name = item.name ,let link = item.url , let image = item.image , let price = item.price{
                            //１つのお菓子をタプルでまとめて管理
                            let okashi = (maker,name,link,image,price)
                            //お菓子の配列へ追加
                            self.okashiList.append(okashi)
                        }
                    }
                    
                    //Table View を更新する
                    self.tableView.reloadData()
                    
                    if let okashidbg = self.okashiList.first{
                        print("---------------------------------")
                        print("okashiList[0] = \(okashidbg)")
                    }
                }
                
                
            }catch{
                //エラー処理
                print("エラーが出ました")
            }
        })
        
        //ダウンロード開始
        task.resume()
    }
    
    //cellの総数を返すdatasourceメソッド、必ず記述する必要があります。
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        //お菓子リストの総数
        return okashiList.count
    }
    
    //cellに値を設定するdatasourceメソッド。必ず記載する必要があります。
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //今回表示を行う、cellオブジェクト（１行）を取得する
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "okashiCell", for: indexPath) as?okashiViewCell else{
            return UITableViewCell()
        }
        //お菓子のタイトル設定
        cell.itemTitleLabel?.text = okashiList[indexPath.row].name
        //お菓子のメーカー設定
        cell.itemMakerLabel?.text = okashiList[indexPath.row].maker
        //お菓子の価格設定
        cell.itemPriceLabel?.text = okashiList[indexPath.row].price
        
        //キャッシュの画像を取り出す
        let itemImageUrl = okashiList[indexPath.row].image
        
        if let cacheImage = imageCache.object(forKey: itemImageUrl as AnyObject){
            //キャッシュ画像の設定
            cell.itemImageView.image = cacheImage
            return cell
        }
        
        //キャッシュに画像がなかった
        //お菓子の画像を取得
        if let imageData = try? Data(contentsOf: okashiList[indexPath.row].image){
            //正常に取得できた場合はUIImageで画像オブジェクトを生成してcellにお菓子画像を設定
            cell.itemImageView?.image = UIImage(data: imageData)
            
            //ダウンロードした画像をキャッシュに登録しておく
            self.imageCache.setObject(UIImage(data: imageData)!, forKey: itemImageUrl as AnyObject)
        }
        //設定済みのcellオブジェクトを画面に反映
        return cell
    }
    
    //cellが選択された際に呼び出されるdelegateメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //ハイライト解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        //SFSafariviewを開く
        let safariViewController = SFSafariViewController(url: okashiList[indexPath.row].link)
        
        //delegateの通知先を自分自身
        safariViewController.delegate = self
        
        //safariviewが開かれる
        present(safariViewController, animated: true, completion: nil)
        
    }

    //safariViewが閉じられた時に呼ばれるdelegateメソッド
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        //safariview を閉じる
        dismiss(animated: true, completion: nil)
        
    }
    
}
extension okashiViewController : StoryboardInstantiable {}
