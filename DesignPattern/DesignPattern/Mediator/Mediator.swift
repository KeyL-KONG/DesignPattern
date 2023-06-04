//
//  Mediator.swift
//  DesignPattern
//
//  Created by ByteDance on 2023/6/4.
//

import Foundation

open class Mediator<ColleagueType> {
    
    private class ColleagueWrapper {
        var strongColleague: AnyObject?
        weak var weakColleague: AnyObject?
        
        var colleague: ColleagueType? {
            return (weakColleague ?? strongColleague) as? ColleagueType
        }
        
        init(weakColleague: ColleagueType) {
            self.strongColleague = nil
            self.weakColleague = weakColleague as AnyObject
        }
        
        init(strongColleague: ColleagueType) {
            self.strongColleague = strongColleague as AnyObject
            self.weakColleague = nil
        }
    }
    
    private var colleagueWrappers: [ColleagueWrapper] = []
    
    public var collegues: [ColleagueType] {
        var collegues = [ColleagueType]()
        colleagueWrappers = colleagueWrappers.filter({
            guard let colleague = $0.colleague else { return false }
            collegues.append(colleague)
            return true
        })
        return collegues
    }
    
    public init() {}
    
    public func addColleague(_ colleague: ColleagueType, strongReference: Bool = true) {
        let wrapper: ColleagueWrapper
        if strongReference {
            wrapper = ColleagueWrapper(strongColleague: colleague)
        } else {
            wrapper = ColleagueWrapper(weakColleague: colleague)
        }
        colleagueWrappers.append(wrapper)
    }
    
    public func removeColleague(_ colleague: ColleagueType) {
        guard let index = collegues.firstIndex(where: {
            ($0 as AnyObject) === (colleague as AnyObject)
        }) else { return }
        colleagueWrappers.remove(at: index)
    }
    
    public func invokeColleagues(closure: (ColleagueType) -> Void) {
        collegues.forEach(closure)
    }
    
    public func invokeColleagues(by colleague: ColleagueType, closure: (ColleagueType) -> Void) {
        collegues.forEach {
            guard ($0 as AnyObject) !== (colleague as AnyObject) else { return }
            closure($0)
        }
    }
    
}

public protocol Colleague: AnyObject {
    func colleague(_ colleague: Colleague?, didSendMessage message: String)
}

public protocol MediatorProtocol: AnyObject {
    func addColleague(_ colleague: Colleague)
    func sendMessage(_ message: String, by colleague: Colleague)
}

public class Musketeer {
    public var name: String
    public weak var mediator: MediatorProtocol?
    
    init(name: String, mediator: MediatorProtocol) {
        self.name = name
        self.mediator = mediator
        mediator.addColleague(self)
    }
    
    public func sendMessage(_ message: String) {
        print("\(name) sent: \(message)")
        mediator?.sendMessage(message, by: self)
    }
}

extension Musketeer: Colleague {
    
    public func colleague(_ colleague: Colleague?, didSendMessage message: String) {
        print("\(name) received: \(message) ")
    }
    
}

public class MusketeerMediator: Mediator<Colleague> {
    
}

extension MusketeerMediator: MediatorProtocol {
    
    public func addColleague(_ colleague: Colleague) {
        self.addColleague(colleague, strongReference: true)
    }
    
    public func sendMessage(_ message: String, by colleague: Colleague) {
        invokeColleagues(by: colleague) {
            $0.colleague(colleague, didSendMessage: message)
        }
    }
}

extension ViewController {
    
    func mediatorExample() {
        let mediator = MusketeerMediator()
        let athos = Musketeer(name: "Athos", mediator: mediator)
        let porthos = Musketeer(name: "porthoos", mediator: mediator)
        let armies = Musketeer(name: "armies", mediator: mediator)
        
        athos.sendMessage("One for all...!")
        print("")
        
        porthos.sendMessage("and all for one...!")
        print("")
        
        armies.sendMessage("Unus pro omnibus, omnes pro uno!")
        print("")
    }
    
}
