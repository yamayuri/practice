//
//  SuperVC.swift
//  entry
//
//  Created by User13 on 2018/03/08.
//  Copyright © 2018年 SunQ Inc. All rights reserved.
//
import Foundation
import UIKit
import SwiftCop

class SuperVC: UIViewController {
    
    let swiftCop = SwiftCop()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    class ViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            // ->背景色を空色に変更する
            self.view.backgroundColor = UIColor(red: 0.8, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
}
