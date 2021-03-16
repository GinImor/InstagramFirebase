//
//  Date+timeAgo.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/16/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current) + " ago"
    }
}
