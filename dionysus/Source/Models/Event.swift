//
//  Event.swift
//  dionysus
//
//  Created by Diogo on 07/08/2025.
//
import Foundation

struct Event: Decodable {
    let id: UUID
    let title: String
    let details: String?
    let slug: String
    let date: Date?
    let maxAttendees: Int?
    let attendeesCount: Int?
}
