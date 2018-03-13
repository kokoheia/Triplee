//
//  ContainerView.swift
//  Set
//
//  Created by Kohei Arai on 2018/02/24.
//  Copyright © 2018年 新井康平. All rights reserved.
//

import UIKit

protocol LayoutViews: class {
    func updateViewFromModel()
}

class ContainerView: UIView {
    
    var delegate: LayoutViews?
    
    override func layoutSubviews(){
        super.layoutSubviews()
        delegate?.updateViewFromModel()
    }
    
}
