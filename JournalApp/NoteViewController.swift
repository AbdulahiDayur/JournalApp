//
//  NoteViewController.swift
//  JournalApp
//
//  Created by Abdul Dayur on 6/16/21.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var starButton: UIButton!
    
    
    var note: Note?
    var notesModel: NotesModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        if note != nil {
            
            titleTextField.text = note?.title
            bodyTextView.text = note?.body
        }
        
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        
        if self.note != nil {
            notesModel?.deleteNote(self.note!)
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        if self.note == nil {
             // Create brand new note
            let n = Note(docID: UUID().uuidString, title: titleTextField.text ?? "", body: bodyTextView.text ?? "", isStarred: false, createdAt: Date(), lastUpdatedAt: Date())
            
            self.note = n
            
    
        } else {
            // This is an update to the existing note
            self.note?.title = titleTextField.text ?? ""
            self.note?.body = bodyTextView.text ?? ""
            self.note?.lastUpdatedAt = Date()
            
        }
        
        // Send it to the notes model
        self.notesModel?.saveNote(self.note!)
        
        dismiss(animated: true, completion: nil)
      
    }
    
    @IBAction func startTapped(_ sender: Any) {
        
        
    }

}
