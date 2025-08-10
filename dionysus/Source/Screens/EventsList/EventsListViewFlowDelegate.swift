//
//  EventsListViewFlowDelegate.swift
//  dionysus
//
//  Created by Diogo on 10/08/2025.
//

import Foundation

protocol EventsListViewFlowDelegate: AnyObject {
    func goToEventDetails(eventId: UUID)
}
