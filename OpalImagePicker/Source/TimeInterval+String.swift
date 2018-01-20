//
//  TimeInterval+String.swift
//  OpalImagePicker
//
//  Created by Kristos Katsanevas on 1/20/18.
//  Copyright © 2018 Opal Orange LLC. All rights reserved.
//

import Foundation

extension TimeInterval {
    func string() -> String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        if hours == 0 {
            return String(format: "%d:%02d", minutes, seconds)
        }
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }
}
