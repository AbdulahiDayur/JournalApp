//
//  ViewController.swift
//  JournalApp
//
//  Created by Abdul Dayur on 6/16/21.
//

// Async operation. We don't want main thread to be waiting for this to complete, do it in background.
// Notify vc by using custom protocol. vc will be delegate for notes model.

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var starButton: UIBarButtonItem!
    
    
    private var notesModel = NotesModel()
    private var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and datasource for the table
        tableView.delegate = self
        tableView.dataSource  = self
        
        // set self as the delegate for the notesModel
        notesModel.delegate = self
        
        // Retrieve all notes
        notesModel.getNotes()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let noteViewController = segue.destination as! NoteViewController
        
        // if user selected a row, transition to note VC
        if tableView.indexPathForSelectedRow != nil {
            noteViewController.note = notes[tableView.indexPathForSelectedRow!.row]
            
            // Deselect row to avoid interference with new note creation
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }
        
        noteViewController.notesModel = self.notesModel
        
    }
    
    
    @IBAction func starFilterTapped(_ sender: Any) {
        
    }

}


extension ViewController: NotesModelProtocol {
    
    func notesRetrieved(_ notes: [Note]) {
        
        // Set notes property and refresh the table view
        self.notes = notes
        print(notes[0].title)
        
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        let titleLabel = cell.viewWithTag(1) as? UILabel
        titleLabel?.text = notes[indexPath.row].title
        
        let bodyLabel = cell.viewWithTag(2) as? UILabel
        bodyLabel?.text = notes[indexPath.row].body
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    
    
}

