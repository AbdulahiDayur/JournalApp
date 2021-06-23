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
            
            // User is viewing an existing note, so populate the fields
            titleTextField.text = note?.title
            bodyTextView.text = note?.body
            
            // Set the status of the star button
            setStarButton()
        } else {
            
            // Create brand new note
           let n = Note(docID: UUID().uuidString, title: titleTextField.text ?? "", body: bodyTextView.text ?? "", isStarred: false, createdAt: Date(), lastUpdatedAt: Date())
           
           self.note = n
        }
        
    }
    
    
    @IBAction func deleteTapped(_ sender: Any) {
        
        if self.note != nil {
            notesModel?.deleteNote(self.note!)
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
       
        // This is an update to the existing note
        self.note?.title = titleTextField.text ?? ""
        self.note?.body = bodyTextView.text ?? ""
        self.note?.lastUpdatedAt = Date()
        
    
        
        // Send it to the notes model
        self.notesModel?.saveNote(self.note!)
        
        dismiss(animated: true, completion: nil)
      
    }
    
    
    func setStarButton() {
        
        if note!.isStarred {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    @IBAction func startTapped(_ sender: Any) {
        
        // Change property in the note
        note?.isStarred.toggle()
        
        // Update the db
        notesModel?.updateFaveStatus(note!.docID, note!.isStarred)
        
        // update the button
        setStarButton()
        
    }

}
