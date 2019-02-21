//
//  ReminderGroup.swift
//  ReminderAppWithNotifications
//
//  Created by Annemarie Ketola on 2/20/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import Foundation

struct ReminderGroup: Codable {
    var name: String
    var items: [Reminder]
}
