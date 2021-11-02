//
//  SOCDBRequest.swift
//  MDB Social No Starter
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation
import FirebaseFirestore

class SOCDatabaseRequest {
    
    static let shared = SOCDatabaseRequest()
    
    let db = Firestore.firestore()
    
    private var eventListener: ListenerRegistration?
    
    func setUser(_ user: SOCUser, completion: (()->Void)?) {
        guard let uid = user.uid else { return }
        do {
            try db.collection("users").document(uid).setData(from: user)
            completion?()
        }
        catch { }
    }
    
    func setEvent(_ event: SOCEvent, completion: (()->Void)?) {
        guard let id = event.id else { return }
        do {
            try db.collection("events").document(id).setData(from: event)
            completion?()
        } catch { }
    }
    
    func getEvents(vc: FeedVC)->[SOCEvent] {
        var events: [SOCEvent] = []
        if (SOCAuthManager.shared.isSignedIn()) {
            eventListener = db.collection("events").order(by: "startTimeStamp", descending: true)
                    .addSnapshotListener { querySnapshot, error in
                        events = []
                        guard let documents = querySnapshot?.documents else { return }
                        for document in documents {
                            guard let event = try? document.data(as: SOCEvent.self) else { return }
                            events.append(event)
                        }
                        vc.updateEvents(newEvents: events)
                    }
        }
        return events
    }

}
