//
//  Entry.swift
//  entry
//
//  Created by yasushi saitoh on 2017/12/20.
//  Copyright © 2017年 SunQ Inc. All rights reserved.
//
import Foundation

class Entry: NSObject, NSCoding {
    var userName:String
    var userNameMei:String
    
    //必須ではないのでオプショナル
    var email:String
    //２択で男性を選択肢状態の為、非オプショナル
    //var sex:Int
    //””でも0を選択する為、非オプショナル
    //var sweetKind:Int
    
    // on/off
    //var mailPermissionFlg:Bool
    
    //パスワード
    var password:String
    
    //生年月日
    var userBirthday:String?
    
    // イニシャライザ
    init(
        userName: String,
        userNameMei: String,
        email: String,
        //sex: Int,
        //sweetKind: Int,
        //mailPermissionFlg:Bool,
        password:String,
        userBirthday:String?
        )
    {
        self.userName = userName
        self.userNameMei = userNameMei
        self.email = email
        //self.sex = sex
        //self.sweetKind = sweetKind
        //self.mailPermissionFlg = mailPermissionFlg
        self.password = password
        self.userBirthday = userBirthday
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userName, forKey:"userName")
        aCoder.encode(userNameMei,forKey:"userNameMei")
        aCoder.encode(email, forKey:"email")
        //aCoder.encode(sex, forKey:"sex")
        //aCoder.encode(sweetKind, forKey:"sweetKind")
        //aCoder.encode(mailPermissionFlg, forKey:"mailPermission")
        aCoder.encode(password, forKey:"password")
        aCoder.encode(userBirthday, forKey:"userBirthday")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.userName = aDecoder.decodeObject(forKey: "userName") as! String
        self.userNameMei = aDecoder.decodeObject(forKey: "userNameMei") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        //self.sex = aDecoder.decodeInteger(forKey: "sex")
        //self.sweetKind = aDecoder.decodeInteger(forKey: "sweetKind")
        //self.mailPermissionFlg = aDecoder.decodeBool(forKey: "mailPermission")
        self.password = aDecoder.decodeObject(forKey: "password") as! String
        self.userBirthday = aDecoder.decodeObject(forKey: "userBirthday") as? String
    }
    
    
}
