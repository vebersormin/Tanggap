//
//  RoundedViewClass.swift
//  Tanggap
//
//  Created by Veber on 08/06/20.
//  Copyright © 2020 Veber. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }
}

class RoundedShadowView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.shadowColor = Const.AppColor.Blue.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}

class RoundedImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}
