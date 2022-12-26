//
//  CardViewVC.swift
//  FlexSwiftDemo
//
//  Created by dyw on 2022/12/22.
//  Copyright © 2022 wbg. All rights reserved.
//

import UIKit
import FlexLib

class CardViewVC: FlexBaseVC {

    let dict = ["imageUrl":"https://image3.kfangcdn.com/prod/survey/e0dcaf63f53b43ca80f539edc92b6b47.jpg-f800x600w",
                "titleStr":"AIUSD阿萨德不吧俗话把就是不断"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "CardViewVC";

//        @objc var _modal : FlexModalView!
        class_addIvar(Self.self, "_titleLabel", sizeof, <#T##alignment: UInt8##UInt8#>, <#T##types: UnsafePointer<CChar>?##UnsafePointer<CChar>?#>)        
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
