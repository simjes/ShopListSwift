import UIKit
import SlackTextViewController
import RealmSwift

func writeToRealm (item: ShopItem, controller: SLKTextViewController) {
    let realm = try! Realm()
    do {
        try realm.write {
            //if item in DB dont add and tell user?
            realm.add(item)
        }
        // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
        controller.textView.refreshFirstResponder()
        
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let rowAnimation: UITableViewRowAnimation = controller.inverted ? .Bottom : .Top
        let scrollPosition: UITableViewScrollPosition = controller.inverted ? .Bottom : .Top
        
        controller.tableView!.beginUpdates()
        controller.tableView!.insertRowsAtIndexPaths([indexPath], withRowAnimation: rowAnimation)
        controller.tableView!.endUpdates()
        
        controller.tableView!.scrollToRowAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: true)
        
        // Fixes the cell from blinking (because of the transform, when using translucent cells)
        // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
        controller.tableView!.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    } catch {
        print("error")
    }
}

func deleteFromRealm(itemName: String, itemType: String) {
    let realm = try! Realm()
    try! realm.write {
        let predicate = NSPredicate(format: "itemName = %@ AND itemType = %@", itemName, itemType)
        let shopItem = realm.objects(ShopItem.self).filter(predicate)
        realm.delete(shopItem[0])
    }

}