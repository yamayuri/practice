//
//  okashiCell.swift
//  entry
//
//  Created by User13 on 2018/03/22.
//  Copyright © 2018年 SunQ Inc. All rights reserved.
//

import Foundation
import UIKit

class okashiViewCell : UITableViewCell{
    
    @IBOutlet weak var itemImageView: UIImageView! //商品画像
    @IBOutlet weak var itemTitleLabel: UILabel!    //商品タイトル
    @IBOutlet weak var itemPriceLabel: UILabel!    //商品価格
    @IBOutlet weak var itemMakerLabel: UILabel!    //商品メーカー
    
    var  itemUrl: String? //商品のURL。遷移先の画面で利用する
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func prepareForReuse(){
        //元々入っている情報を再利用時にクリア
        itemImageView.image = nil
    }
    
}
extension okashiViewCell : StoryboardInstantiable {}
