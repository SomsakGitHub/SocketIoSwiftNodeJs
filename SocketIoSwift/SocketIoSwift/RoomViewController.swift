//
//  RoomViewController.swift
//  SocketIoSwift
//
//  Created by somsak on 24/6/2564 BE.
//

import UIKit

class RoomViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var userCountLabel: UILabel!
    private var socketManager = Managers.socketManager
    var users: [UserData] = []
    
    var username: String!
    
    private var messages: [MessageData] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("users", users)
        startObservingUserList()
        startObservingMessages()
    }
    
    @IBAction func sendDataTouch(_ sender: Any) {
        let text = messageTextField.text ?? ""
        socketManager.send(message: text, username: self.username)
    }
    
    private func startObservingUserList() {
        socketManager.observeUserList(completionHandler: { [weak self] data in
            var currentUsers: [UserData] = []
            
            for userData in data {
                let name = userData["nickname"] as! String
                let isConnected = userData["isConnected"] as! Bool
                
                let user = UserData(username: name, status: isConnected ? .online : .offline)
                
                currentUsers.append(user)
            }
            
            self?.users = currentUsers
            self!.userCountLabel.text = "user count: \(currentUsers.count)"
        })
    }
    
    func startObservingMessages() {
        socketManager.observeMessages(completionHandler: { [weak self] data in
            let name = data["nickname"] as! String
            let text = data["message"] as! String
            
            let message = MessageData(text: text, sender: name)
            
            self?.messages.append(message)
            
        })
    }
}

extension RoomViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomTableViewCell", for: indexPath) as! RoomTableViewCell
        
        cell.messageLabel.text = "\(message.sender): \(message.text)"
        
        return cell
    }
}

struct MessageData {
    
    let text: String
    let sender: String
}
