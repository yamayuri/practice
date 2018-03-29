//
//  EntryVC.swift
//  entry
//
//  Created by yasushi saitoh on 2017/12/19.
//  Copyright © 2017年 SunQ Inc. All rights reserved.
//

import UIKit

protocol EntryVCDelegate {
    
    func entryBtn(userName:String)
}

class EntryVC: SuperVC,UITextFieldDelegate {

    let pickerView: UIPickerView = UIPickerView()
  /*  let sweetlist = ["","ショコラパルフェ","大きな白玉クリームぜんざい",
                "大きな窯出しとろけるプリン","ふんわり生どら焼（白玉入り）","香ばしほうじ茶ラテ"] */
    
    var kind:ButtonKind!
    // コールバック　Optional 型で保持します。　ラベルは省力します。
    var callbackReturnTapped: ((_ userName: String) -> Void)? = nil
    // デリゲート(委譲)　デリゲートの設定は任意なので Optional 型で保持します。
    var delegate: EntryVCDelegate?
    
    //private var sex:Int = 0
    //private var sweet:Int = 0  */
    private let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var editBtnView: UIView!
    @IBOutlet weak var newBtnView: UIView!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var userNameMeiText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userBirthday: UITextField!
    //@IBOutlet weak var sweetText: UITextField!
    //@IBOutlet weak var sexSeg: UISegmentedControl!
    //@IBOutlet weak var mailSwitch: UISwitch!
    
    //今日の日付を代入
    let nowDate = NSDate()
    let dateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    
    // MARK: life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI(kind:self.kind)
        //setupPicker()
        self.view.backgroundColor = UIColor(red: 0.72, green: 0.84, blue: 0.86, alpha: 1.0)
        
        //生年月日入力欄の設定
        dateFormat.dateFormat = "yyyy年MM月dd日"
        guard (userDefaults.object(forKey: "entry1") as? Data) != nil else {
            userBirthday.text = dateFormat.string(from: nowDate as Date)
            return
        }
        self.userBirthday.delegate = self
        
        // DatePickerの設定(日付用)
        inputDatePicker.datePickerMode = UIDatePickerMode.date
        inputDatePicker.locale = Locale(identifier: "ja_JP")
        userBirthday.inputView = inputDatePicker
        
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .blackTranslucent
        pickerToolBar.tintColor = UIColor.white
        pickerToolBar.backgroundColor = UIColor.black
        
        //ボタンの設定
        //右寄せのためのスペース設定
        let spaceBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,target: self,action: #selector(self.done))
        
        //完了ボタンを設定
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(self.toolBarBtnPush(sender:)))
        
        //ツールバーにボタンを表示
        pickerToolBar.items = [spaceBarBtn,toolBarBtn]
        userBirthday.inputAccessoryView = pickerToolBar
    }
    
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnPush(sender: UIBarButtonItem){
        let pickerDate = inputDatePicker.date
        userBirthday.text = dateFormat.string(from: pickerDate)
        
        self.userBirthday.endEditing(true)
    }
    
    // MARK: IBAction
    
    @IBAction func tapButtonClose(_ sender: AnyObject) {
        closeScreen()
    }
    
    @IBAction func tapButtonNew(_ sender: AnyObject) {
        let  output = validate()
        if output.ck == true {
            registEntry()
            closeScreen()
        } else {
            validateMsg(funny:output.msg)
        }
        
    }
    
    @IBAction func tapButtonEdit(_ sender: AnyObject) {
        let  output = validate()
        if output.ck == true {
            registEntry()
            closeScreen()
        } else {
            validateMsg(funny: output.msg)
        }
        
    }
    
    /*
    @IBAction func sexSegmentedControl(sender: UISegmentedControl) {
        //データを取る
        print("性別:\(sender.selectedSegmentIndex)")
        sex = sender.selectedSegmentIndex
 }
 */
 

    
    
    // MARK: private
    private func closeScreen() {
        //キーボードを閉じる
        self.view.endEditing(true)
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI(kind:ButtonKind) {
        
        //共通
        // UITextFieldDelegate を受ける為
        self.userNameText.delegate = self
        self.userNameMeiText.delegate = self
        self.emailText.delegate = self
        self.password.delegate = self
        self.userBirthday.delegate = self
        
        switch kind {
        case .new:
            //新規画面
            setupNew()
            
        case .edit:
            //編集画面
            setupEdit()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*private func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EntryVC.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EntryVC.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)
     
        //選択
        pickerView.selectRow(self.sweet, inComponent: 0, animated: true)
        sweetText.text = sweetlist[self.sweet]
 
        // タップした時のView（通常はキーボード）
        self.sweetText.inputView = pickerView
        // アクセサリー追加
        self.sweetText.inputAccessoryView = toolbar
 
    } */
    
    @objc private func cancel() {
        //self.sweetText.text = ""
        //Pickerを閉じる
        //self.sweetText.endEditing(true)
    }
    
    @objc private func done() {
        //Pickerを閉じる
        //self.sweetText.endEditing(true)
    }
    
    private func setupNew() {
        newBtnView.isHidden = false
        editBtnView.isHidden = true
    }
    
    private func setupEdit() {
        newBtnView.isHidden = true
        editBtnView.isHidden = false
        
        guard let data = userDefaults.object(forKey: "entry1") as? Data else {
            return
        }
        
        if let unarchiveEntry = NSKeyedUnarchiver.unarchiveObject(with: data) as? Entry {
            print("useName:\(unarchiveEntry.userName)")
            userNameText.text = unarchiveEntry.userName
            userNameMeiText.text = unarchiveEntry.userNameMei
            emailText.text = unarchiveEntry.email
            userBirthday.text = unarchiveEntry.userBirthday
            //sex = unarchiveEntry.sex
            //sexSeg.selectedSegmentIndex = unarchiveEntry.sex
            //sweet = unarchiveEntry.sweetKind
            //ailSwitch.setOn(unarchiveEntry.mailPermissionFlg, animated: false)
            password.text = unarchiveEntry.password
        }
    }
    
    private func validateMsg(funny:String) {
        let alertController = UIAlertController(title: nil, message:"\(funny)を入力して下さい。", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func validate() -> (ck:Bool,msg:String) {
        
        var check = true
        var funny:String = ""
        
        if self.userNameText.text?.count == 0 {
            check = false
            funny="名前（姓）"
            userNameText?.becomeFirstResponder()
        }
        else if self.userNameMeiText.text?.count == 0 {
            check = false
            funny="名前（名）"
            userNameMeiText?.becomeFirstResponder()
        }
        else if self.emailText.text?.count == 0 {
            check = false
            funny="メール"
            emailText?.becomeFirstResponder()
        }
        else if self.password.text?.count == 0 {
            check = false
            funny="パスワード"
            password?.becomeFirstResponder()
        }
        let tpl = (ck:check, msg:funny)
        return tpl
    }
    
    private func registEntry() {
        let entry = Entry(
            userName:self.userNameText.text!,
            userNameMei:self.userNameMeiText.text!,
            email:self.emailText.text!,
            password:self.password.text!,
            userBirthday:self.userBirthday.text!
        )
        //シリアライズ
        let archive = NSKeyedArchiver.archivedData(withRootObject: entry)
        userDefaults.set(archive, forKey:"entry1")
        userDefaults.synchronize()
        
        //コールバックの処理
        callbackReturnTapped?(self.userNameText.text!)
        
        //デリゲートの処理
        delegate?.entryBtn(userName: self.userNameText.text!)
        
    }
    
    /**
        CGRectMake　Swift3で変更した対応
     
     - parameter x: 横
     - parameter y: 縦
     - parameter width: 幅
     - parameter height: 高さ
     
     - returns:　CGRectのインスタンス
     
     */
    private func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

/*
extension EntryVC : UIPickerViewDataSource {
    //Picerviewの列の数は1とする
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //PicerViewの要素の数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return sweetlist.count
    }
}


extension EntryVC : UIPickerViewDelegate {
    
    //タイトル
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return sweetlist[row]
    }
    
    選択時の処理
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        self.sweet = row
        self.sweetText.text = sweetlist[row]
    }
}
 */
 
extension EntryVC {
    // Returnキーを押したと判定される直前イベント
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}

extension EntryVC : StoryboardInstantiable {}
