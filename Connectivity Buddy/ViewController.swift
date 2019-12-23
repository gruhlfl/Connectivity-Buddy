import UIKit

class ViewController: UIViewController {
    
    private var reachability: Reachability?
    private let notificationCenter = NotificationCenter.default
    
    private var connectionStatusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            reachability = try Reachability()
        } catch {
            print()
        }
        
        if reachability != nil {
            notificationCenter.addObserver(self, selector: #selector(checkForReachability(_:)), name: Notification.Name.reachabilityChanged, object: reachability!)
        }
        
        startReachabilityNotifications()
    }
    
    // MARK: - Offline Handler
    private func startReachabilityNotifications() {
        do {
            try reachability!.startNotifier()
        } catch {
            debugPrint("Error with reachability: ", error)
        }
    }
    
    @objc public func checkForReachability(_ notification: Notification){
        startReachabilityNotifications()
        
        if let _reachability = notification.object as? Reachability {
            if _reachability.connection == .unavailable {
                print("systems down captain")
//                offline = true
            }
            else {
//                offline = false
                print("she's good to go!")
            }
        }
    }
}

