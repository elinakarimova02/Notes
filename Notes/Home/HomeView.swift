//
//  HomeView.swift
//  Notes
//
//  Created by Elina Karimova on 11/2/25.
//

import UIKit
import SnapKit

class HomeView: UIView {
    
    var addNoteAction: (() -> Void)?
    
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Search"
        view.showsCancelButton = true 
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var notesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 21
        button.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupSearchBar()
        setupTitleLabel()
        setupNotesCollectionView()
        setupAddButton()
    }
    
    private func setupSearchBar() {
        addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    private func setupNotesCollectionView() {
        addSubview(notesCollectionView)
        notesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func setupAddButton() {
        addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(50)
        }
    }
    
    @objc private func addNoteButtonTapped() {
        addNoteAction?()
    }
}
