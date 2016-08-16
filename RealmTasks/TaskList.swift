//
//  TaskList.swift
//  RealmTasks
//
//  Created by Brad Woodard on 8/16/16.
//  Copyright © 2016 Brad Woodard. All rights reserved.
//

import Foundation
import RealmSwift

class TaskList: Object {
    
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    let tasks = List<Task>()
    // List<Task> is used for One->Many relationships
    // List is similar to array and is typed so all contained objects must be the same
    // List<Task> is a GENERIC data type and that is why it is not prefixed with *dynamic*
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
