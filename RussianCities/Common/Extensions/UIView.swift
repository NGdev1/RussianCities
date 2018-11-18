//
//  UIView.swift
//  idtp
//
//  Created by Михаил Андреичев on 28.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit

extension UIView {
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}
