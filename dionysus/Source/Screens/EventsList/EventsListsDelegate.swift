//
//  EventsListsDelegate.swift
//  dionysus
//
//  Created by Diogo on 10/08/2025.
//

import Foundation

protocol EventListsViewDelegate: AnyObject {
    func didSelectEvent(eventId: UUID)
}
