//
//  NoteManager.swift
//  Notes
//
//  Created by Elina Karimova on 11/2/25.
//

import FirebaseFirestore
import FirebaseAuth

class NoteManager {
    
    static let shared = NoteManager() // Singleton
    private let db = Firestore.firestore()
    
    private init() {} // Prevents creating instances
    
    private func getUserUID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    // MARK: - Fetch Notes for Current User
    func fetchNotes(completion: @escaping (Result<[Note], Error>) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
            return
        }
        
        let userNotesRef = Firestore.firestore()
            .collection("users").document(userUID)
            .collection("notes")
        
        userNotesRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let notes: [Note] = documents.compactMap { doc in
                let data = doc.data()
                guard let title = data["title"] as? String,
                      let description = data["description"] as? String,
                      let dateValue = data["date"] as? Timestamp else { return nil }
                
                return Note(id: doc.documentID, title: title, description: description, date: dateValue.dateValue())
            }
            
            completion(.success(notes))
        }
    }
    
    // MARK: - Add Note
    func addNote(title: String, description: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        let noteID = UUID().uuidString
        let noteData: [String: Any] = [
            "id": noteID,
            "title": title,
            "description": description,
            "date": Timestamp(date: Date()),
            "userUID": userUID
        ]
        
        let noteRef = Firestore.firestore()
            .collection("users").document(userUID)
            .collection("notes").document(noteID)
        
        noteRef.setData(noteData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(noteID))
            }
        }
    }
    
    // MARK: - Update Note
    func updateNote(id: String, title: String, description: String, date: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        let noteRef = Firestore.firestore()
            .collection("users").document(userUID)
            .collection("notes").document(id)
        
        noteRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Note does not exist."])))
                return
            }
            
            let updatedData: [String: Any] = [
                "title": title,
                "description": description,
                "date": Timestamp(date: date)
            ]
            
            noteRef.updateData(updatedData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    // MARK: - Delete Note
    func deleteNote(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        let noteRef = Firestore.firestore()
            .collection("users").document(userUID)
            .collection("notes").document(id)
        
        print("Deleting note at path: users/\(userUID)/notes/\(id)")
        
        noteRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching note before deletion: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                print("Note does not exist. Cannot delete.")
                completion(.failure(NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Note not found."])))
                return
            }
            
            noteRef.delete { error in
                if let error = error {
                    print("Error deleting note: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Note deleted successfully!")
                    completion(.success(()))
                }
            }
        }
    }
    
    // MARK: - Delete All Notes
    func deleteAllNotes(completion: @escaping (Bool) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let notesRef = Firestore.firestore().collection("users").document(userUID).collection("notes")
        
        notesRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching notes for deletion: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No notes found for deletion.")
                completion(true)
                return
            }
            
            print("Found \(documents.count) notes to delete.")
            let batch = Firestore.firestore().batch()
            
            for document in documents {
                print("Deleting note: \(document.documentID)")
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { batchError in
                DispatchQueue.main.async {
                    if let batchError = batchError {
                        print("Error deleting notes: \(batchError.localizedDescription)")
                        completion(false)
                    } else {
                        print("All notes deleted successfully!")
                        completion(true)
                    }
                }
            }
        }
    }
}
