//
//  SettingsView.swift
//  Notes
//
//  Created by Elina Karimova on 11/2/25.
//

import UIKit
import SnapKit

protocol SettingsViewDelegate: AnyObject {
    func didTapClearData()
    func didTapLogOut()
}

class SettingsView: UIView {
    
    weak var delegate: SettingsViewDelegate?
    
    private let settingsTableView = UITableView()
    
    private lazy var setData: [Settings] = [
        Settings(image: "trash", title: "Clear data"),
        Settings(image: "rectangle.portrait.and.arrow.right", title: "Log Out")
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        setupSettingsTableView()
    }
    
    private func setupData() {
        setData = [Settings(image: "trash", title: "Clear data")]
        settingsTableView.reloadData()
    }
    
    private func setupSettingsTableView() {
        settingsTableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseID)
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.backgroundColor = .systemBackground
        settingsTableView.separatorStyle = .singleLine
        addSubview(settingsTableView)
        settingsTableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }
    }

}

extension SettingsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseID, for: indexPath) as! SettingsCell
        cell.setup(settings: setData[indexPath.row])
        return cell
    }
}

extension SettingsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if setData[indexPath.row].title == "Clear data" {
            delegate?.didTapClearData()
        }
        if setData[indexPath.row].title == "Log Out" {
            delegate?.didTapLogOut()
        }
    }
}
