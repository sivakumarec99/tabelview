import UIKit

class ViewController: UIViewController {
    
    // Table View
    let tableView = UITableView()
    
    // Sample Data
    var items = ["Apple", "Banana", "Orange", "Mango", "Grapes", "Pineapple", "Watermelon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Setup TableView
    func setupTableView() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        // Register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Assign delegates
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true // Enable drag
        
    }
}

// MARK: - UITableViewDataSource (Required)
extension ViewController: UITableViewDataSource {
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // Cell Configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    // Number of Sections (Optional)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    // Row Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        print("Selected: \(selectedItem)")
    }
    
    // Custom Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // Swipe to Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching (Performance Optimization)
extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            print("Prefetching row at \(indexPath.row)")
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            print("Cancelled prefetching for row at \(indexPath.row)")
        }
    }
}

// MARK: - UITableViewDragDelegate (Enable Drag)
extension ViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let draggedItem = items[indexPath.row]
        let itemProvider = NSItemProvider(object: draggedItem as NSString)
        return [UIDragItem(itemProvider: itemProvider)]
    }
}

// MARK: - UITableViewDropDelegate (Enable Drop)
extension ViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let lastRow = tableView.numberOfRows(inSection: 0)
            destinationIndexPath = IndexPath(row: lastRow, section: 0)
        }
        
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                tableView.performBatchUpdates {
                    let movedItem = items.remove(at: sourceIndexPath.row)
                    items.insert(movedItem, at: destinationIndexPath.row)
                    tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
                }
                coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
}
