//
//  Item.swift
//  Kora
//
//  Created by Adrián Míguez Campos on 12/3/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
