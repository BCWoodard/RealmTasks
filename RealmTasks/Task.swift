//
//  Task.swift
//  RealmTasks
//
//  Created by Brad Woodard on 8/16/16.
//  Copyright © 2016 Brad Woodard. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var notes = ""
    dynamic var isCompleted = false
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
