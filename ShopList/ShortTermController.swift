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
        let shopItem = ShopItem(value: [self.textView.text, "short", NSDate()])
        writeToRealm(shopItem, controller: self)
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
    
    
    // swipe and delete
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            let cellText = self.tableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text
            deleteFromRealm(cellText!, itemType: "short") //todo: if no error: remove from rows
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
}

