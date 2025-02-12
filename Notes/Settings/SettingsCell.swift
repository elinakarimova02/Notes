//
//  SettingsCell.swift
//  Notes
//
//  Created by Elina Karimova on 11/2/25.
//

import UIKit
import SnapKit

class SettingsCell: UITableViewCell {
    
    static let reuseID = "settings_cell"
    
    private lazy var settingsImg: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var settingsTitle: UILabel = {
        let view = UILabel()
        return view
    }()
    
    var button: UIButton = {
        let view = UIButton(type: .system)
        view.semanticContentAttribute = .forceLeftToRight
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        selectionStyle = .none
        setupUI()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupSettingsImg()
        setupSettingsTitle()
        setupSettingsButton()
    }
    
    private func setupSettingsImg(){
        addSubview(settingsImg)
        settingsImg.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }
    }
    
    private func setupSettingsTitle(){
        addSubview(settingsTitle)
        settingsTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(settingsImg.snp.trailing).offset(13)
            make.height.equalTo(24)
        }
    }
    private func setupSettingsButton(){
        addSubview(button)
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
    }
    
    func setup(settings: Settings) {
        settingsImg.image = UIImage(systemName: settings.image)?.withRenderingMode(.alwaysTemplate)
        settingsImg.tintColor = .label
        settingsTitle.text = settings.title
        settingsTitle.textColor = .label
    }
}
