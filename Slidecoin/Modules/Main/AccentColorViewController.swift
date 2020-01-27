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
    
    private let colors: [(UIColor, String)] = [(.systemRed, "Red"),
                                               (.systemBlue, "Blue"),
                                               (.systemPink, "Pink"),
                                               (.systemTeal, "Teal"),
                                               (.systemGreen, "Green"),
                                               (.systemIndigo, "Indigo"),
                                               (.systemOrange, "Orange"),
                                               (.systemPurple, "Purple"),
                                               (.systemYellow, "Yellow")]
    
    private let cellID = "\(UITableViewCell.self)"
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Акцентный цвет"
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
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
        return cell
    }
}




// MARK: - UITableViewDelegate

extension AccentColorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userDefaultsService.setColor(colors[indexPath.row].0)
        
        let alert = alertService.alert("Изменения вступят в силу после перезапуска приложения", title: .attention)
        present(alert, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
