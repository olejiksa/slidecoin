//
//  AccentColorViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 27.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AccentColorViewController: UIViewController {

    private let alertService = Assembly.alertService
    private let userDefaultsService = Assembly.userDefaultsService
    
    private let colors: [(UIColor, String)] = [(.systemRed, "Красный"),
                                               (.systemBlue, "Синий"),
                                               (.systemPink, "Розовый"),
                                               (.systemTeal, "Бирюзовый"),
                                               (.systemGreen, "Зеленый"),
                                               (.systemIndigo, "Фиолетовый"),
                                               (.systemOrange, "Оранжевый"),
                                               (.systemPurple, "Пурпурный"),
                                               (.systemYellow, "Желтый")]
    
    private let cellID = "\(UITableViewCell.self)"
    
    private var lastSelectedIndexPath: IndexPath?
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let row = colors.firstIndex { userDefaultsService.getColor() == $0.0 } ?? 1
        lastSelectedIndexPath = IndexPath(row: row, section: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Акцентный цвет"
        navigationItem.largeTitleDisplayMode = .never
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(close))
                
        navigationItem.rightBarButtonItem = closeButton
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}




// MARK: - UITableViewDataSource

extension AccentColorViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = colors[indexPath.row].1
        cell.textLabel?.textColor = colors[indexPath.row].0
        cell.accessoryType = (lastSelectedIndexPath?.row == indexPath.row) ? .checkmark : .none
        return cell
    }
}




// MARK: - UITableViewDelegate

extension AccentColorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userDefaultsService.setColor(colors[indexPath.row].0)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row != lastSelectedIndexPath?.row {
            if let lastSelectedIndexPath = lastSelectedIndexPath {
                let oldCell = tableView.cellForRow(at: lastSelectedIndexPath)
                oldCell?.accessoryType = .none
            }

            let newCell = tableView.cellForRow(at: indexPath)
            newCell?.accessoryType = .checkmark

            lastSelectedIndexPath = indexPath
        }
    }
}
