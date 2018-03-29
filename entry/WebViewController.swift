//
//  WebViewController.swift
//  entry
//
//  Created by User13 on 2018/03/18.
//  Copyright © 2018年 SunQ Inc. All rights reserved.
//

import Foundation
import WebKit //WKWebViewを利用するために必要

//商品ページのを参照するための画面
class WebViewController: UIViewController{
    
    //商品ページのURL
    var itemUrl: String?
    
    //商品ページを参照するためのWebView
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //User-Agentをiphoneに設定する
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1"
        
        //webViewのurlを読み込ませてWebページを表示させる
        guard let itemUrl = itemUrl else{
            return
        }
        
        guard let url = URL(string: itemUrl) else{
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension WebViewController : StoryboardInstantiable {}
