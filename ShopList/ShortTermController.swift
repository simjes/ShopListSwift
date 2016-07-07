import UIKit
import SlackTextViewController
import RealmSwift

class ShortTermController: SLKTextViewController {
    
    var itemSource:Results<ShopItem>!
    
    override var tableView: UITableView {
        get {
            return super.tableView!
        }
    }
    override class func tableViewStyleForCoder(decoder: NSCoder) -> UITableViewStyle {
        return .Plain
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = itemSource[indexPath.row].itemName
        cell.transform = self.tableView.transform
        /* separator full width
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero*/
        return cell
    }
    	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inverted = true
        self.textInputbar.autoHideRightButton = true
        self.shouldScrollToBottomAfterKeyboardShows = false
        self.rightButton.setTitle(NSLocalizedString("Add", comment: ""), forState: .Normal)
        self.textView.placeholder = "Item"
        reloadTable()
        
        //self.tableView.separatorStyle = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTable()
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        let realm = try! Realm()
        let shopItem = ShopItem(value: [self.textView.text, "short", NSDate()])
        do {
            try realm.write {
                realm.add(shopItem)
            }
            // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
            self.textView.refreshFirstResponder()
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let rowAnimation: UITableViewRowAnimation = self.inverted ? .Bottom : .Top
            let scrollPosition: UITableViewScrollPosition = self.inverted ? .Bottom : .Top
            
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: rowAnimation)
            self.tableView.endUpdates()
            
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: true)
            
            // Fixes the cell from blinking (because of the transform, when using translucent cells)
            // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        } catch {
            print("error")
        }
        super.didPressRightButton(sender)
    }
    
    func reloadTable() {
        do {
            let realm = try! Realm()
            itemSource = realm.objects(ShopItem).filter("itemType = 'short'").sorted("timeOfInsert", ascending: false)
            tableView.reloadData()
        } catch {
            
        }
    }
}

