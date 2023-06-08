//
//  MulticastDelegate.swift
//  DesignPattern
//
//  Created by keyl on 2023/6/3.
//

import Foundation


public class MulticastDelegate<ProtocolType> {
    
    private class DelegateWrapper {
        weak var delegate: AnyObject?
        
        init(delegate: AnyObject? = nil) {
            self.delegate = delegate
        }
    }
    
    private var delegateWrappers: [DelegateWrapper]
    
    public var delegates: [ProtocolType] {
        delegateWrappers = delegateWrappers.filter { $0.delegate != nil }
        return delegateWrappers.map { $0.delegate } as! [ProtocolType]
    }
    
    public init(delegates: [ProtocolType] = []) {
        self.delegateWrappers = delegates.map({
            DelegateWrapper(delegate: $0 as AnyObject)
        })
    }
    
    public func addDelegate(_ delegate: ProtocolType) {
        let wrapper = DelegateWrapper(delegate: delegate as AnyObject)
        delegateWrappers.append(wrapper)
    }
    
    public func removeDelegate(_ delegate: ProtocolType) {
        guard let index = delegateWrappers.firstIndex(where: {
            $0.delegate === (delegate as AnyObject)
        }) else {
            return
        }
        delegateWrappers.remove(at: index)
    }
    
    public func invokeDelegates(_ closure: (ProtocolType) -> ()) {
        delegates.forEach {
            closure($0)
        }
    }

}

public protocol EmergencyResponding {
    func notifyFire(at location: String)
    func notifyCarCrash(at location: String)
}

public class FireStation: EmergencyResponding {
    
    public func notifyFire(at location: String) {
        print("FireFighters were notified about a fire at " + location)
    }
    
    public func notifyCarCrash(at location: String) {
        print("FireFighters were notified about a car crash at " + location)
    }
    
}

public class PoliceStation: EmergencyResponding {
    
    public func notifyFire(at location: String) {
        print("Police were notified about a fire at " + location)
    }
    
    public func notifyCarCrash(at location: String) {
        print("Police were notified about a car crash at " + location)
    }
    
}


public class DispatchSystem {
    let multicastDelegate = MulticastDelegate<EmergencyResponding>()
}

extension ViewController {
    
    func multicastExample() {
        let dispatch = DispatchSystem()
        let policeStation = PoliceStation()
        var fireStation: FireStation! = FireStation()
        
        dispatch.multicastDelegate.addDelegate(policeStation)
        dispatch.multicastDelegate.addDelegate(fireStation)
        
        dispatch.multicastDelegate.invokeDelegates {
            $0.notifyFire(at: "Ray's house!")
        }
        
        fireStation = nil
        dispatch.multicastDelegate.invokeDelegates {
            $0.notifyCarCrash(at: "Ray's garage!")
        }
    }
    
}
