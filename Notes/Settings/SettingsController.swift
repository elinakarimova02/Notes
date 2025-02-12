//
//  SettingsController.swift
//  Notes
//
//  Created by Elina Karimova on 11/2/25.
//

import UIKit
import FirebaseFirestoreInternal
import FirebaseAuth

protocol SettingsControllerDelegate: AnyObject {
    func didDeleteAllNotes()
}

class SettingsController: UIViewController {
    
    weak var delegate: SettingsControllerDelegate?
    
    private var settingsView: SettingsView {
        return view as! SettingsView
    }
    
    override func loadView() {
        view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        settingsView.delegate = self
        settingsView.backgroundColor = .systemBackground
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Settings"
    }
}

extension SettingsController: SettingsViewDelegate {
    func didTapClearData() {
        let alert = UIAlertController(
            title: "Clear All Notes",
            message: "Are you sure you want to delete all notes? This action cannot be undone.",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            NoteManager.shared.deleteAllNotes { success in
                DispatchQueue.main.async {
                    if success {
                        print("All notes deleted.")
                        
                        self.delegate?.didDeleteAllNotes()
                        
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        let errorAlert = UIAlertController(
                            title: "Error",
                            message: "Failed to delete all notes.",
                            preferredStyle: .alert
                        )
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self.present(errorAlert, animated: true)
                    }
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true)
    }
    
    func didTapLogOut() {
        let alertController = UIAlertController(
            title: "Log Out",
            message: "Are you sure you want to log out?",
            preferredStyle: .alert
        )
        
        // "Yes" Action - Proceed with Logout
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in
            guard let self else { return }
            
            AuthService.shared.signOut { error in
                if let error = error {
                    AlertManager.showLogOutErrorAlert(on: self, with: error)
                    return
                }
                
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            }
        }
        
        // "Cancel" Action - Dismiss Alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    

    private func clearAllNotes() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let notesCollection = Firestore.firestore()
            .collection("users").document(userUID)
            .collection("notes")
        
        notesCollection.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching notes for deletion: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No notes found for deletion.")
                return
            }
            
            let batch = Firestore.firestore().batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { batchError in
                DispatchQueue.main.async {
                    if let batchError = batchError {
                        print("Error deleting notes: \(batchError.localizedDescription)")
                        let alert = UIAlertController(
                            title: "Error",
                            message: "Failed to delete all notes.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self.present(alert, animated: true)
                    } else {
                        print("All notes deleted successfully!")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
