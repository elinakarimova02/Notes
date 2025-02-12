//
//  Note.swift
//  Notes
//

import Foundation

struct Note {
    let id: String
    let title: String
    let description: String
    let date: Date

    init(id: String = UUID().uuidString, title: String, description: String, date: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
    }
}
