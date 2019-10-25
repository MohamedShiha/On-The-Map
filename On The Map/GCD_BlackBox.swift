//
//  GCD_BlackBox.swift
//  On The Map
//
//  Created by Mohamed Shiha on 7/10/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation

func updateUI(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
