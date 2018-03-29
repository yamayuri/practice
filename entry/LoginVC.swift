//
//  Login.swift
//  entry
//
//  Created by User13 on 2018/03/15.
//  Copyright © 2018年 SunQ Inc. All rights reserved.
//

import UIKit
import AudioUnit

class LoginVC: SuperVC,UITextFieldDelegate {

    //画面との紐付け
    @IBOutlet weak var loginBtnView : UIView!
    @IBOutlet weak var loginemailText : UITextField!
    @IBOutlet weak var loginpassword : UITextField!
    @IBOutlet weak var NGImageView : UIImageView!
    @IBOutlet weak var NGMessageView : UIView!
    private let userDefaults = UserDefaults.standard
    
    //コールバック
    var callbackReturnTapped:(()  -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.72, green: 0.84, blue: 0.86, alpha: 1.0)
        
        loginemailText.delegate = self
        loginpassword.delegate = self
        
    }
    
    
    @IBAction func loginButton(_ sender: AnyObject) {
        //入力内容が正しいかチェック
        if checklogin(){
        //正しい場合、検索画面へ遷移
        print("-LoginButton-")
                
        //画面をクローズし、コールバック処理実装
        self.dismiss(animated: true, completion: {
        self.callbackReturnTapped!()
                            })
        }
        else {
        //誤っている場合、×画像と音を鳴らす
            missmatch()
        }
        
    }
    
    //入力内容が正しいか確認
    private func checklogin() -> Bool{
        //メモリに保存されているユーザ情報を取得
        guard let data = userDefaults.object(forKey: "entry1") as? Data else {
            return false
        }
        
        if let unarchiveEntry = NSKeyedUnarchiver.unarchiveObject(with: data) as? Entry {
            print("useName:\(unarchiveEntry.userName)")
            
            //メールアドレスが正しいか確認
            if loginemailText.text != unarchiveEntry.email {
                //アドレスが一致しない場合falseを返す
                return false
            }else if loginpassword.text != unarchiveEntry.password{
                //パスワードが一致しない場合falseを返す
                return false
            }
        }
        return true
    }
    
    
    private func missmatch() {
        /*
        //エラーメッセージ
        let alertController = UIAlertController(title: nil, message:"メールアドレスまたはパスワードが間違っています。",preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        */
 
       //エラー音
        
        //パスを取得
        let soundUrl = Bundle.main.url(forResource:"button62",
                                      withExtension:"mp3")
        //サウンドIDを登録するための変数
        var soundId : SystemSoundID = 0
        
        //サウンドファイルを登録してサウンドIDを取得
        AudioServicesCreateSystemSoundID(soundUrl! as CFURL ,&soundId)
        
        //再生処理
        AudioServicesPlaySystemSoundWithCompletion(soundId){
        }
        
        //×の画像を出す
        UIView.animate(withDuration: 1.0, animations: {
            //アルファ値を1.0に変化させる（初期値はStoryboardで0.0に設定済み）
            self.NGImageView.alpha=1.0
            self.NGMessageView.alpha=1.0
        })
    }

}
extension LoginVC : StoryboardInstantiable {}
