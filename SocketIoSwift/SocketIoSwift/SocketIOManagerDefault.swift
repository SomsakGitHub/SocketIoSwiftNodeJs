//
//  SocketIOManagerDefault.swift
//  SocketIoSwift
//
//  Created by somsak on 23/6/2564 BE.
//

import Foundation
import SocketIO

enum Managers {
    
    //MARK: - Type Properties
    
    static let socketManager: SocketIOManager = SocketIOManagerDefault()
}

class SocketIOManagerDefault: NSObject, SocketIOManager {
    
    //MARK: - Instance Properties
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    //MARK: - Initializers
    
    override init() {
        super.init()
        
        manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!)
        socket = manager.defaultSocket
    }
    
    //MARK: - Instance Methods
    
    func establishConnection() {
        socket.connect()
    }
    
    func connectToRoom(with name: String) {
        socket.emit("connectUser", name)
    }
    
    func send(message: String, username: String) {
        socket.emit("chatMessage", username, message)
    }
    
    func observeUserList(completionHandler: @escaping ([[String: Any]]) -> Void) {
        socket.on("userList") { dataArray, _ in
            completionHandler(dataArray[0] as! [[String: Any]])
        }
    }
    
    func observeMessages(completionHandler: @escaping ([String: Any]) -> Void) {
        socket.on("newChatMessage") { dataArray, _ in
            var messageDict: [String: Any] = [:]
            
            messageDict["nickname"] = dataArray[0] as! String
            messageDict["message"] = dataArray[1] as! String
            
            completionHandler(messageDict)
        }
    }
}

protocol SocketIOManager {
    
    func establishConnection()
    func connectToRoom(with name: String)
    func observeUserList(completionHandler: @escaping ([[String: Any]]) -> Void)
    func send(message: String, username: String)
    func observeMessages(completionHandler: @escaping ([String: Any]) -> Void)
    
}

