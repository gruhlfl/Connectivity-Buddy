import UIKit

class ViewController: UIViewController {
    
    private var reachability: Reachability?
    private let notificationCenter = NotificationCenter.default
    
    private var connectionStatusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionStatusLabel.textColor = traitCollection.userInterfaceStyle == .light ? .black : .white
        connectionStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectionStatusLabel)
        
        connectionStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectionStatusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
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
                connectionStatusLabel.text = "you are not connected to the network"
            }
            else {
                connectionStatusLabel.text = "you have a network connection"
            }
        }
    }
}

