//
//  EventDetailsViewModel.swift
//  dionysus
//
//  Created by Diogo on 10/08/2025.
//

import Foundation

struct EventDetails{
    let id: UUID
    let title: String
    let details: String
    let slug: String
    let maxAttendees: Int
    let attendeesCount: Int
}

class EventDetailsViewModel {
    
    let eventId: UUID
    
    var onDetailsLoaded: ((EventDetails) -> Void)?
    
    init(eventId: UUID) {
        self.eventId = eventId
    }
    
    func fetchDetails() {
        let details = EventDetails(
            id: eventId,
            title: "Workshop Fastify",
            details: "Aprenda Fastify com especialistas.",
            slug: "workshop-fastify",
            maxAttendees: 50,
            attendeesCount: 2
        )
        
        self.onDetailsLoaded?(details)
    }



}
