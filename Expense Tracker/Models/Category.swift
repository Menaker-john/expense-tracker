//
//  Category.swift
//  Expense Tracker
//
//  Created by John Menaker on 1/12/22.
//

import Foundation
import RealmSwift

final class Category: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var image: String

    convenience init(name: String, image: String = "") {
        self.init()
        self._id = ObjectId.generate()
        self.name = name
        self.image = image
    }
}
