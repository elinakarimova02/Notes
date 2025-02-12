//
//  HomeController.swift
//  Notes
//
//  Created by Elina Karimova on 7/2/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeController: UIViewController {
    
    private var homeView: HomeView {
        return view as! HomeView
    }
    
    private var notes: [Note] = []
    private var filteredNotes: [Note] = [] // Filtered notes for search
    private var isSearching = false // Flag to track if search is active
    
    override func loadView() {
        view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupCollectionView()
        setupActions()
        fetchNotes()
        setupSearchBar()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Home"
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func setupCollectionView() {
        homeView.notesCollectionView.delegate = self
        homeView.notesCollectionView.dataSource = self
        homeView.notesCollectionView.register(NoteCell.self, forCellWithReuseIdentifier: NoteCell.reuseID)
    }
    
    private func setupActions() {
        homeView.addNoteAction = { [weak self] in
            self?.openNoteView()
        }
    }
    
    private func fetchNotes() {
        NoteManager.shared.fetchNotes { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedNotes):
                    self.notes = fetchedNotes
                    self.homeView.notesCollectionView.reloadData()
                    print("Notes reloaded in UI.")
                case .failure(let error):
                    print("Error fetching notes: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func settingsButtonTapped() {
        let vc = SettingsController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    
    private func openNoteView(note: Note? = nil) {
        let noteViewController = NoteController(note: note)
        noteViewController.noteUpdated = { [weak self] in
            self?.fetchNotes() // Refresh notes when returning from NoteView
        }
        navigationController?.pushViewController(noteViewController, animated: true)
    }
    
    private func setupSearchBar() {
        homeView.searchBar.delegate = self
    }
}

extension HomeController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredNotes.count : notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCell.reuseID, for: indexPath) as! NoteCell
        let note = isSearching ? filteredNotes[indexPath.row] : notes[indexPath.row]
        cell.fill(title: note.title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNote = notes[indexPath.row]
        openNoteView(note: selectedNote)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 24 // Adjust padding
        return CGSize(width: width, height: 120) // Increase height
    }
}

extension HomeController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredNotes = notes
        } else {
            isSearching = true
            filteredNotes = notes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        DispatchQueue.main.async {
            self.homeView.notesCollectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        filteredNotes = notes
        DispatchQueue.main.async {
            self.homeView.notesCollectionView.reloadData()
        }
    }
}

extension HomeController: SettingsControllerDelegate {
    func didDeleteAllNotes() {
        print("Refreshing notes after deletion")
        fetchNotes()
    }
}
