//
//  BDBLog.swift
//  TeslaMon
//
//  Created by Brian Batchelder on 6/15/21.
//

import SwiftUI
import Foundation
import os

fileprivate let BDBLogAlwaysShow : Set<String>? = nil
fileprivate let BDBLogDontShowIfNotAlwaysShow: Set<String>? = nil

fileprivate let MaxMessages = 100
fileprivate let DefaultLogLevel = BDBLogLevel.debug

enum BDBLogLevel: Int {
    case undefined = 0
    case error = 1
    case warning = 2
    case info = 3
    case debug = 4
    case trace = 5
}

/**
Makes sure no other thread reenters the closure before the one running has not returned
*/
@discardableResult
public func synchronized<T>(_ lock: AnyObject, closure:() -> T) -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }

    return closure()
}

class BDBLog {
    static var logLevel : BDBLogLevel {
        get {
            return shared.logLevel
        }
        set(newLogLevel) {
            shared.logLevel = newLogLevel
        }
    }
    static var logMessages : [ String ] {
        get {
            return shared.logMessages
        }
    }

    class func logOnMainQueue(_ v: Any) {
        shared.logOnMainQueue(v)
    }

    class func log(_ v: Any) {
        shared.log(v)
    }

    class func log(_ logLevel: BDBLogLevel?, _ v: Any) {
        shared.log(logLevel, v)
    }

    class func log(_ id: UUID, _ v: Any) {
        shared.log(id, v)
    }

    class func logV(_ v: Any) -> some View {
        return shared.logV(v)
    }

    class func logV(_ logLevel: BDBLogLevel?, _ v: Any) -> some View {
        return shared.logV(logLevel, v)
    }

    private static let shared = BDBLog()

    private var logMessages = [ String ]()
    private var logLevel = DefaultLogLevel

    private var logger: Logger

    init() {
        self.logger = Logger()
    }

    private func logOnMainQueue(_ v: Any) {
        DispatchQueue.main.async {
            self.log(v)
        }
    }
    private func log(_ v: Any) {
        let logMessage = "\(v)"
        guard shouldShowLog(logMessage) else { return }

        synchronized(self) {
            if logMessages.count > MaxMessages {
                logMessages.removeFirst()
            }
            
            logMessages.append(logMessage)
        }
        logger.log("\(logMessage, privacy: .public)")
    }
    
    private func log(_ logLevel: BDBLogLevel?, _ v: Any) {
        if let logLevel = logLevel,
           logLevel.rawValue <= self.logLevel.rawValue {
            log(v)
        }
    }
    
    private func log(_ id: UUID, _ v: Any) {
        let logMessage = "(\(id)): \(v)"
        log(DefaultLogLevel, logMessage)
    }

    private func logV(_ v: Any) -> some View {
        log(v)
        return EmptyView()
    }

    private func logV(_ logLevel: BDBLogLevel?, _ v: Any) -> some View {
        if let logLevel = logLevel,
           logLevel.rawValue <= self.logLevel.rawValue {
            log(v)
        }
        return EmptyView()
    }

    private func shouldShowLog(_ message: String) -> Bool {
        let wordsInMessage = Set(message.components(separatedBy: CharacterSet(charactersIn: " <>().:")))
        
        if let BDBLogAlwaysShow = BDBLogAlwaysShow {
            if (wordsInMessage.intersection(BDBLogAlwaysShow).count > 0) { return true }
        }
        
        if let BDBLogDontShowIfNotAlwaysShow = BDBLogDontShowIfNotAlwaysShow {
            if (wordsInMessage.intersection(BDBLogDontShowIfNotAlwaysShow).count > 0) { return false }
        }
        
        return true
    }
}

extension App {
    func logV(_ id: UUID, _ v: Any) -> some View {
        log(id, v)
        return EmptyView()
    }
    
    func logV(_ id: Int, _ v: Any) -> some View {
        log(id, v)
        return EmptyView()
    }
    
    func log(_ v: Any) {
        log(DefaultLogLevel, v)
    }

    func log(_ id: UUID, _ v: Any) {
        log(DefaultLogLevel, id, v)
    }
    
    func log(_ id: Int, _ v: Any) {
        log(DefaultLogLevel, id, v)
    }
    
    func log(_ logLevel: BDBLogLevel, _ v: Any) {
        let logMessage = "\(type(of: self)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }

    func log(_ logLevel: BDBLogLevel, _ id: UUID, _ v: Any) {
        let logMessage = "\(type(of: self)) (\(id)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }

    func log(_ logLevel: BDBLogLevel, _ id: Int, _ v: Any) {
        let logMessage = "\(type(of: self)) (\(id)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }
}

extension Commands {
    func logV(_ id: UUID, _ v: Any) -> some View {
        log(id, v)
        return EmptyView()
    }
    
    func log(_ v: Any) {
        log(DefaultLogLevel, v)
    }

    func log(_ id: UUID, _ v: Any) {
        log(DefaultLogLevel, id, v)
    }
    
    func log(_ logLevel: BDBLogLevel, _ v: Any) {
        let logMessage = "\(type(of: self)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }

    func log(_ logLevel: BDBLogLevel, _ id: UUID, _ v: Any) {
        let logMessage = "\(type(of: self)) (\(id)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }
}


extension View {
    func logV(_ id: UUID, _ v: Any) -> some View {
        log(id, v)
        return EmptyView()
    }
    
    func log(_ v: Any) {
        log(DefaultLogLevel, v)
    }

    func log(_ id: UUID, _ v: Any) {
        log(DefaultLogLevel, id, v)
    }
    
    func log(_ logLevel: BDBLogLevel, _ v: Any) {
        let logMessage = "\(type(of: self)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }

    func log(_ logLevel: BDBLogLevel, _ id: UUID, _ v: Any) {
        let logMessage = "\(type(of: self)) (\(id)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }
}

extension Scene {
    func logV(_ id: UUID, _ v: Any) -> some View {
        log(id, v)
        return EmptyView()
    }
    
    func log(_ v: Any) {
        log(DefaultLogLevel, v)
    }

    func log(_ id: UUID, _ v: Any) {
        log(DefaultLogLevel, id, v)
    }
    
    func log(_ logLevel: BDBLogLevel, _ v: Any) {
        let logMessage = "\(type(of: self)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }

    func log(_ logLevel: BDBLogLevel, _ id: UUID, _ v: Any) {
        let logMessage = "\(type(of: self)) (\(id)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }
}

extension DropDelegate {
    func logV(_ id: UUID, _ v: Any) -> some View {
        log(id, v)
        return EmptyView()
    }
    
    func log(_ v: Any) {
        log(DefaultLogLevel, v)
    }

    func log(_ id: UUID, _ v: Any) {
        log(DefaultLogLevel, id, v)
    }
    
    func log(_ logLevel: BDBLogLevel, _ v: Any) {
        let logMessage = "\(type(of: self)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }

    func log(_ logLevel: BDBLogLevel, _ id: UUID, _ v: Any) {
        let logMessage = "\(type(of: self)) (\(id)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }
}

extension EnvironmentValues {
    func logV(_ id: UUID, _ v: Any) -> some View {
        log(id, v)
        return EmptyView()
    }
    
    func log(_ v: Any) {
        log(DefaultLogLevel, v)
    }

    func log(_ id: UUID, _ v: Any) {
        log(DefaultLogLevel, id, v)
    }
    
    func log(_ logLevel: BDBLogLevel, _ v: Any) {
        let logMessage = "\(type(of: self)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }

    func log(_ logLevel: BDBLogLevel, _ id: UUID, _ v: Any) {
        let logMessage = "\(type(of: self)) (\(id)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }
}

extension ObservableObject {
    func logV(_ id: UUID, _ v: Any) -> some View {
        log(id, v)
        return EmptyView()
    }
    
    func log(_ v: Any) {
        log(DefaultLogLevel, v)
    }

    func log(_ id: UUID, _ v: Any) {
        log(DefaultLogLevel, id, v)
    }
    
    func log(_ logLevel: BDBLogLevel, _ v: Any) {
        let logMessage = "\(type(of: self)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }

    func log(_ logLevel: BDBLogLevel, _ id: UUID, _ v: Any) {
        let logMessage = "\(type(of: self)) (\(id)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }
}

extension NSObject {
    class func log(_ v: Any) {
        let logMessage = "\(self): \(v)"
        BDBLog.log(logMessage)
    }
    
    func logOnMainQueue(_ v: Any) {
        DispatchQueue.main.async {
            self.log(v)
        }
    }
    
    func log(_ v: Any) {
        log(DefaultLogLevel, v)
    }

    func log(_ id: UUID, _ v: Any) {
        log(DefaultLogLevel, id, v)
    }
    
    func log(_ id: Int, _ v: Any) {
        log(DefaultLogLevel, id, v)
    }
    
    func log(_ logLevel: BDBLogLevel, _ v: Any) {
        let logMessage = "\(type(of: self)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }

    func log(_ logLevel: BDBLogLevel, _ id: UUID, _ v: Any) {
        let logMessage = "\(type(of: self)) (\(id)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }

    func log(_ logLevel: BDBLogLevel, _ id: Int, _ v: Any) {
        let logMessage = "\(type(of: self)) (\(id)): \(v)"
        BDBLog.log(logLevel, logMessage)
    }
}

