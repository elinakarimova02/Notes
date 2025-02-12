//
//  NoteCell.swift
//  Notes
//
//  Created by Elina Karimova on 11/2/25.
//

import UIKit
import SnapKit

protocol NoteCellDelegate: AnyObject {
    func didSwitchOn(isOn: Bool)
}

class NoteCell: UICollectionViewCell {
    
    static var reuseID = "note_cell"
        
    let colors: [UIColor] = [UIColor().rgb(r: 217, g: 187, b: 249, alpha: 1),
                             UIColor().rgb(r: 215, g: 237, b: 248, alpha: 1)]
    
    weak var delegate: NoteCellDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        backgroundColor = colors.randomElement()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(title: String) {
        titleLabel.text = title
    }
    
    private func setupConstraints(){
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
