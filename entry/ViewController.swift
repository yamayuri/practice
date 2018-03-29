//
//  ViewController.swift
//  entry
//
//  Created by yasushi saitoh on 2017/12/19.
//  Copyright © 2017年 SunQ Inc. All rights reserved.
//
// github url :https://github.com/syassi/NewEntry

import UIKit

class ViewController: SuperVC {

    private let userDefaults = UserDefaults.standard
    

    @IBOutlet weak var newBtnView: UIView!
    @IBOutlet weak var editBtnView: UIView!
    @IBOutlet weak var startBtnView: UIView!
    
    
    // MARK: life Cycle
    
    /**
      画面ロード完了時イベント
     
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // background image
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "BackgroundImage.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
    }
    
    /**
     画面　表示される直前イベント
     
     - parameter animated:　アニメーションフラグ
     
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: IBAction
    // TODO: テスト
    // FIXME: 最終的に直す
    // https://qiita.com/roworks/items/cd5cb05bd83585325db7
    
    @IBAction func tapButtonNew(_ sender: AnyObject) {
        print("- NewButton -")
        createEntry(kind:.new)
    }
    
    @IBAction func StartButton(_ sender: AnyObject) {
        print("-StartButton-")
        let logvc = LoginVC.instantiate()
        logvc.modalPresentationStyle = .overCurrentContext
        
        //画面がクローズされた際のコールバック処理を実施
        logvc.callbackReturnTapped = { () -> Void in
            //ナビゲーション表示
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            //検索画面へ遷移
            let storyboard = UIStoryboard(name: "OkashiSerch", bundle: nil).instantiateViewController(withIdentifier: "OkashiSerch")
            self.navigationController?.pushViewController(storyboard, animated: true)
        }
        //モーダル表示
        present(logvc, animated: true, completion: nil)
        
    }
    
    @IBAction func tapButtonEdit(_ sender: AnyObject) {
        print("- EditButton -")
        createEntry(kind:.edit)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("完了")
    }
    
    // MARK: private
    
    private func createEntry(kind:ButtonKind) {
        let vc = EntryVC.instantiate()
        vc.kind = kind
        vc.modalPresentationStyle = .overCurrentContext
        
        //デリゲート設定
        vc.delegate = self
        
        // コールバック処理
        vc.callbackReturnTapped = {(userName:String) -> Void in
            print("- callback - userName:\(userName)")
            self.setupUI()
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    /**
     画面セットアップ用
     
     */
    private func setupUI() {
        
        guard let data = userDefaults.object(forKey: "entry1") as? Data else {
            newBtnView.isHidden = false
            startBtnView.isHidden = true
            editBtnView.isHidden = true
            return
        }
        newBtnView.isHidden = true
        startBtnView.isHidden = false
        editBtnView.isHidden = false
        
        if let unarchiveEntry = NSKeyedUnarchiver.unarchiveObject(with: data) as? Entry {
            print("useName:\(unarchiveEntry.userName)")
        }
    }
}

extension ViewController : EntryVCDelegate {
    func entryBtn(userName:String) {
        print("- delegate - userName:\(userName)")
        
    }
}

