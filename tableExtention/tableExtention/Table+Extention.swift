//
//  Table+Extention.swift
//  tableExtention
//
//  Created by JIDTP1408 on 24/02/25.
//

import Foundation
import UIKit

extension UITableView {
    
    // Register a UITableViewCell using its class type
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        let identifier = String(describing: cellType)
        self.register(cellType, forCellReuseIdentifier: identifier)
    }
    
    // Register a cell with XIB
    func registerNib<T: UITableViewCell>(_ cellType: T.Type) {
        let identifier = String(describing: cellType)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    // Dequeue a UITableViewCell with generic type
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Error dequeuing cell with identifier: \(identifier)")
        }
        return cell
    }
}

extension UITableView {
    
    func scrollToLastRow(animated: Bool = true) {
        let lastSection = self.numberOfSections - 1
        if lastSection >= 0 {
            let lastRow = self.numberOfRows(inSection: lastSection) - 1
            if lastRow >= 0 {
                let indexPath = IndexPath(row: lastRow, section: lastSection)
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
}

extension UITableView {
    
    func reloadWithAnimation() {
        self.reloadData()
        let cells = self.visibleCells
        let tableHeight = self.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(delayCounter), usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
