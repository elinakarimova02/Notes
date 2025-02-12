//
//  SettingsController.swift
//  Notes
//
//  Created by Elina Karimova on 11/2/25.
//

import UIKit
import FirebaseFirestoreInternal
import FirebaseAuth

class SettingsController: UIViewController {
    
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
            self.clearAllNotes()
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
        
        let db = Firestore.firestore()
        let notesCollection = db.collection("notes").whereField("userUID", isEqualTo: userUID)
        
        notesCollection.getDocuments { snapshot, error in
            if let error = error {
                print("Error deleting notes: \(error.localizedDescription)")
                return
            }
            
            let batch = db.batch()
            snapshot?.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit { batchError in
                DispatchQueue.main.async {
                    if batchError == nil {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        let alert = UIAlertController(
                            title: "Error",
                            message: "Failed to delete all notes.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
}
