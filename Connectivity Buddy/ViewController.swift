import UIKit

class ViewController: UIViewController {
    
    private var reachability: Reachability?
    private let notificationCenter = NotificationCenter.default
    
    private var connectionStatusLabel = UILabel()
    private var retryButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        connectionStatusLabel.textColor = traitCollection.userInterfaceStyle == .light ? .black : .white
        connectionStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectionStatusLabel)
        
        connectionStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectionStatusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.setTitle("Retry connection", for: .normal)
        retryButton.isEnabled = false
        retryButton.alpha = 0.25
//        retryButton.backgroundColor = traitCollection.userInterfaceStyle == .light ? .lightGray : .gray
        retryButton.addTarget(self, action: #selector(handleRetryButtonTapped), for: .touchUpInside)
        view.addSubview(retryButton)
        
        retryButton.topAnchor.constraint(equalTo: connectionStatusLabel.bottomAnchor, constant: 48).isActive = true
        retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        retryButton.widthAnchor.constraint(equalToConstant: 152).isActive = true
        
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
    
    @objc func handleRetryButtonTapped() {
        
        startReachabilityNotifications()
        retryButton.setTitle("Retrying..", for: .normal)
        retryButton.isEnabled = false
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
        retryButton.setTitle("Retry connection", for: .normal)
        
        if let _reachability = notification.object as? Reachability {
            if _reachability.connection == .unavailable {
                connectionStatusLabel.text = "you are not connected to the network"
                retryButton.isEnabled = true
                retryButton.alpha = 1
            }
            else {
                connectionStatusLabel.text = "you have a network connection"
                retryButton.isEnabled = false
                retryButton.alpha = 0.25
            }
        }
    }
}

