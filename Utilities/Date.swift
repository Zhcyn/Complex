//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import Foundation
extension Date {
    func adding(_ components: DateComponents, in calendar: Calendar = .current) -> Date? {
        calendar.date(byAdding: components, to: self)
    }
    func subtracting(_ components: DateComponents, in calendar: Calendar = .current) -> Date? {
        adding(components.negated)
    }
}
extension DateComponents {
    var negated: DateComponents {
        let flip: (Int?) -> (Int?) = { $0.flatMap { -$0 } }
        return DateComponents(calendar: calendar, timeZone: timeZone, era: flip(era), year: flip(year), month: flip(month), day: flip(day), hour: flip(hour), minute: flip(minute), second: flip(second), nanosecond: flip(nanosecond))
    }
}
