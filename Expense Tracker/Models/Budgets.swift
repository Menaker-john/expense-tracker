//
//  Budgets.swift
//  Expense Tracker
//
//  Created by John Menaker on 3/18/22.
//

import Foundation
import RealmSwift

final class Budgets: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var budgets: List<Budget>

    override init() {
        super.init()
        self.id = ObjectId.generate()
        self.budgets = List<Budget>()
    }
}
