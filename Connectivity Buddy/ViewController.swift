import UIKit

class ViewController: UIViewController {
    
    private var reachability: Reachability?
    private let notificationCenter = NotificationCenter.default
    
    private var connectionStatusLabel = UILabel()
    private var retryButton = UIButton()
    private var testConnectionButton = UIButton()

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
        retryButton.backgroundColor = .lightGray
        retryButton.addTarget(self, action: #selector(handleRetryButtonTapped), for: .touchUpInside)
        view.addSubview(retryButton)
        
        retryButton.topAnchor.constraint(equalTo: connectionStatusLabel.bottomAnchor, constant: 48).isActive = true
        retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        retryButton.widthAnchor.constraint(equalToConstant: 152).isActive = true
        
        testConnectionButton.setTitle("Test connection", for: .normal)
        testConnectionButton.translatesAutoresizingMaskIntoConstraints = false
        testConnectionButton.backgroundColor = .lightGray
        testConnectionButton.addTarget(self, action: #selector(handleTestConnectionButtonTapped), for: .touchUpInside)
        view.addSubview(testConnectionButton)
        
        testConnectionButton.topAnchor.constraint(equalTo: retryButton.bottomAnchor, constant: 48).isActive = true
        testConnectionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
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
    
    @objc func handleTestConnectionButtonTapped() {

        if let url = URL(string: "https://sv443.net/jokeapi/category/Any") {
            
            testConnectionButton.setTitle("Testing...", for: .normal)
            testConnectionButton.isEnabled = false
        
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    
                    DispatchQueue.main.async {
                        
                        self.testConnectionButton.setTitle("Network call failed", for: .normal)
                        
                        let _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in

                            self.testConnectionButton.setTitle("Test connection", for: .normal)
                            self.testConnectionButton.isEnabled = true
                        }
                    }
                }
                                
                if let urlResponse = response as? HTTPURLResponse  {
                    
                    if urlResponse.statusCode == 200 {
                        
                        DispatchQueue.main.async {
                            
                            self.testConnectionButton.setTitle("Network call successful!", for: .normal)
                            
                            let _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                                
                                self.testConnectionButton.setTitle("Test connection", for: .normal)
                                self.testConnectionButton.isEnabled = true
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            
                            self.testConnectionButton.setTitle("Network call failed", for: .normal)
                            
                            let _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in

                                self.testConnectionButton.setTitle("Test connection", for: .normal)
                                self.testConnectionButton.isEnabled = true
                            }
                        }
                    }
                }
            }
            task.resume()
        }
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

