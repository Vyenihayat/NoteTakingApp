//
//  EditVC.swift
//  NoteTakingApp
//
//  Created by Vahit Yenihayat on 12.06.2022.
//

import UIKit
import CoreData


class EditVC: UIViewController,UINavigationControllerDelegate {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
 
    var note: NoteModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.text = note?.textNote ?? ""
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    @IBAction func doneButtonClicked(_ sender: Any) {
        if noteTextView.text == "" {
                    makeAlert(titleInput: "Error!", messageInput: "Note is Empty!")
                    }
        updateNote(id: note?.id.uuidString, note: noteTextView.text)
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
        }
    func makeAlert(titleInput: String, messageInput: String) {
    let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
    alert.addAction(okButton)
    self.present(alert, animated: true, completion: nil)
    }
    
    func updateNote(id: String?, note: String?) {
        guard let id = id else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Notes")
        let predicate = NSPredicate(format: "id = '\(id)'")
        fetchRequest.predicate = predicate
        do {
            let object = try context.fetch(fetchRequest)
            if object.count == 1 {
                let objectUpdate = object.first as! NSManagedObject
                objectUpdate.setValue(note ?? "", forKey: "note")
                do {
                    try context.save()
                }
                catch {
                    print(error)
                }
            }
        }
        catch {
            print(error)
        }
    }
}

