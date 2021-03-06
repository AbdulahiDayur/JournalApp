//
//  NotesModel.swift
//  JournalApp
//
//  Created by Abdul Dayur on 6/16/21.
//

import Foundation
import Firebase

protocol NotesModelProtocol {
    
    func notesRetrieved(_ notes: [Note])
}

class NotesModel {
    
    var delegate: NotesModelProtocol?
    
    var listener: ListenerRegistration?
    
    deinit {
        // Unregister database listener
        listener?.remove()
    }
    
    func getNotes(_ starredOnly: Bool = false) {
        
        // Detach any listener
        listener?.remove()
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        var query: Query = db.collection("notes")
        
        // If we're only looking for starred notes
        if starredOnly {
            query = query.whereField("isStarred", isEqualTo: true)
        }
        
        // Get all the notes
        self.listener = query.addSnapshotListener { (snapshot, error) in
            
            // Check for errors
            if error == nil && snapshot != nil {
                    
                var notes = [Note]()
                
                // Parse documents into notes
                for doc in snapshot!.documents {
                    
                    let createdAtDate = Timestamp.dateValue(doc["createdAt"] as! Timestamp)
                    let lastUpdatedAtDate = Timestamp.dateValue(doc["lastUpdatedAt"] as! Timestamp)
                    
                    
                    let n = Note(docID: doc["docId"] as! String, title: doc["title"] as! String, body: doc["body"] as! String, isStarred: doc["isStarred"] as! Bool, createdAt: createdAtDate(), lastUpdatedAt: lastUpdatedAtDate())
                    
                    notes.append(n)
                    
                    DispatchQueue.main.async {
                        self.delegate?.notesRetrieved(notes)
                    }
                }
            }
            
        }
        
    }
    
    func updateFaveStatus(_ docID: String, _ isStarred: Bool) {
        
        let db = Firestore.firestore()
        
        db.collection("notes").document(docID).updateData(["isStarred": isStarred])
        
    }
    
    
    func deleteNote(_ n: Note) {
        let db = Firestore.firestore()
        
        db.collection("notes").document(n.docID).delete()
        
    }
    
    func saveNote(_ n:Note) {
        let db = Firestore.firestore()
        
        db.collection("notes").document(n.docID).setData(noteToDict(n))
    }
    
    func noteToDict(_ n: Note) -> [String: Any]{
        
        var dict = [String: Any]()
        
        dict["docId"] = n.docID
        dict["title"] = n.title
        dict["body"] = n.body
        dict["isStarred"] = n.isStarred
        dict["createdAt"] = n.createdAt
        dict["lastUpdatedAt"] = n.lastUpdatedAt
        
        return dict
    }
    
    
    
}
