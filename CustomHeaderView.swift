//
//  CustomHeaderView.swift
//  Rails
//
//  Created by Feng Xinyuan on 21/4/17.
//  Copyright © 2017 nyx. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {
    
    @IBOutlet var label: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.preferredMaxLayoutWidth = label.bounds.width
    }
}
