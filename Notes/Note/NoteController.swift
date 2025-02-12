//
//  NoteController.swift
//  Notes
//

import UIKit

class NoteController: UIViewController {
    
    private lazy var noteView = NoteView()
    private var note: Note?
    var noteUpdated: (() -> Void)?
    
    init(note: Note? = nil) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = noteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupActions()
        loadNoteData()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = note == nil ? "New Note" : "Edit Note"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            style: .plain,
            target: self,
            action: #selector(trashButtonTapped)
        )
    }
    
    private func setupActions() {
        noteView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func loadNoteData() {
        guard let note = note else { return }
        noteView.titleBox.text = note.title
        noteView.textBox.text = note.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        noteView.notesDateLabel.text = dateFormatter.string(from: note.date)
    }
    
    @objc private func saveButtonTapped() {
        let title = noteView.titleBox.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = noteView.textBox.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !title.isEmpty, !description.isEmpty else {
            AlertManager.showAlert(title: "Error", message: "Title and description cannot be empty.")
            return
        }
        
        if let note = note {
            NoteManager.shared.updateNote(id: note.id, title: title, description: description, date: Date()) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.noteUpdated?()
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        AlertManager.failureUpdateNote(on: self, with: error)
                    }
                }
            }
        } else {
            NoteManager.shared.addNote(title: title, description: description) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.noteUpdated?()
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        AlertManager.failureAddNote(on: self, with: error)
                    }
                }
            }
        }
    }
    
    @objc private func trashButtonTapped() {
        guard let note = note else { return }
        
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            NoteManager.shared.deleteNote(id: note.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.noteUpdated?()
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        AlertManager.failureDeleteNote(on: self, with: error)
                    }
                }
            }
        }))
        
        present(alert, animated: true)
    }
}
