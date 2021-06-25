//
//  ViewController.swift
//  SocketIoSwift
//
//  Created by somsak on 22/6/2564 BE.
//

import UIKit
import SocketIO

class ViewController: UIViewController {
    
    var username: String!
    
    //MARK: - Nested Types
    
    private enum SeguesViewController {
        static let goToRoom = "goToRoom"
    }
    
    //MARK: - Instance Properties
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    //MARK: -
    
    private var socketManager = Managers.socketManager
    
    //MARK: Pass data with segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let roomViewController = segue.destination as? RoomViewController {
            roomViewController.username = self.username
        }
    }
    
    //MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        socketManager.establishConnection()
    }
    
    //MARK: - Instance Methods
    
    @IBAction private func loginTouch(_ sender: Any) {
        self.username = userNameTextField.text
        socketManager.connectToRoom(with: self.username ?? "")
        self.performSegue(withIdentifier: SeguesViewController.goToRoom, sender: nil)
    }
}

struct UserData {
    
    let username: String
    let status: Status
}

enum Status {
    
    //MARK: - Enumeration Cases
    
    case online
    case offline
}

