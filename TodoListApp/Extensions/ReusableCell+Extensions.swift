//
//  ReusableCell+Extensions.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 23.05.2025.
//

import UIKit

extension UITableView {
    
    func reusableCell<Cell: UITableViewCell>(indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.className, for: indexPath) as? Cell else {
            fatalError("Could not dequeue reusable cell of type \(Cell.className) ")
        }
        return cell
    }
}

extension UICollectionView {
    
    func reusableCell<Cell: UICollectionViewCell>(indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.className, for: indexPath) as? Cell else {
            fatalError("Could not dequeue reusable cell of type \(Cell.className) ")
        }
        return cell
    }
}

extension NSObject {
    
    var className: String {
        String(describing: type(of: self))
    }
    
    class var className: String {
        String(describing: self)
    }
}
