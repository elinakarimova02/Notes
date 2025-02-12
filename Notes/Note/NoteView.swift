//
//  NoteView.swift
//  Notes
//
//  Created by Elina Karimova on 11/2/25.
//

import UIKit
import SnapKit

class NoteView: UIView {
    
    var titleBox: UITextView = {
        let view = UITextView()
        view.autocorrectionType = .no
        view.layer.cornerRadius = 17
        view.layer.borderWidth = 0.5
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.textContainer.lineBreakMode = .byWordWrapping
        return view
    }()
    
    var textBox: UITextView = {
        let view = UITextView()
        view.autocorrectionType = .no
        view.layer.cornerRadius = 20
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.backgroundColor = UIColor().rgb(r: 250, g: 248, b: 246, alpha: 1)
        return view
    }()
    
    var notesDateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .secondaryLabel
        view.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return view
    }()
    
    var copyButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        view.tintColor = .lightGray
        return view
    }()
    
    var saveButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Save", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor().rgb(r: 255, g: 61, b: 61, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        setupTitleBox()
        setupTextBox()
        setupNotesDateLabel()
        setupCopyButton()
        setupSaveButton()
    }
    
    private func setupTitleBox() {
        addSubview(titleBox)
        titleBox.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(22)
            make.height.equalTo(34)
        }
    }
    
    private func setupTextBox() {
        addSubview(textBox)
        textBox.snp.makeConstraints { make in
            make.top.equalTo(titleBox.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(22)
            make.height.equalTo(475)
        }
    }
    
    private func setupNotesDateLabel(){
        addSubview(notesDateLabel)
        notesDateLabel.snp.makeConstraints { make in
            make.top.equalTo(textBox.snp.bottom).offset(6)
            make.trailing.equalTo(textBox.snp.trailing).offset(-20)
            make.height.equalTo(17)
        }
    }
    
    private func setupCopyButton(){
        addSubview(copyButton)
        copyButton.snp.makeConstraints { make in
            make.bottom.equalTo(textBox.snp.bottom).offset(-12)
            make.trailing.equalTo(textBox.snp.trailing).offset(-15)
            make.height.width.equalTo(32)
        }
    }
    
    private func setupSaveButton() {
        addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.leading.trailing.equalToSuperview().inset(22)
            make.height.equalTo(42)
        }
    }
}
