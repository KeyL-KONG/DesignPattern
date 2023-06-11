//
//  Coordinator.swift
//  DesignPattern
//
//  Created by keyl on 2023/6/11.
//

import UIKit

public protocol Router: AnyObject {
    func present(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?)
    func dismiss(animated: Bool)
}

extension Router {
    public func present(_ viewController: UIViewController, animted: Bool) {
        present(viewController, animated: animted, onDismissed: nil)
    }
}

public class NavigationRouter: NSObject {
    private let navigationController: UINavigationController
    private let routerRootController: UIViewController?
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.routerRootController = navigationController.viewControllers.first
        super.init()
    }
}

extension NavigationRouter: Router {
    public func present(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, onDismissed: nil)
    }
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismissed
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    public func dismiss(animated: Bool) {
        guard let routerRootController = routerRootController else {
            navigationController.popToRootViewController(animated: animated)
            return
        }
        performOnDismissed(for: routerRootController)
        navigationController.popToViewController(routerRootController, animated: animated)
    }
    
    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else {
            return
        }
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
}

extension NavigationRouter: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let dismissViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(dismissViewController) else {
            return
        }
        performOnDismissed(for: dismissViewController)
    }
}

public protocol Coordinator: AnyObject {
    var children: [Coordinator]  { get set }
    var router: Router { get }
    
    func present(animated: Bool, onDismissed: (() -> Void)?)
    func dismiss(animated: Bool)
    func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)?)
}

extension Coordinator {
    public func dismiss(animated: Bool) {
        router.dismiss(animated: animated)
    }
    
    public func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)? = nil) {
        children.append(child)
        child.present(animated: animated) { [weak self, weak child] in
            guard let self = self, let child = child else {
                return
            }
            self.removeChild(child)
            onDismissed?()
        }
    }
    
    private func removeChild(_ child: Coordinator) {
        guard let index = children.firstIndex(where: {
            $0 === child
        }) else {
            return
        }
        children.remove(at: index)
    }
}

/*
public class HowToCodeCoordinate: Coordinator {
    
    public var children: [Coordinator]
    public var router: Router
    
    private lazy var stepViewControllers = [
        StepViewController.instantiate(delegate: self, buttonColor: UIColor(red: 0.96, green: 0, blue: 0.11, alpha: 1), text: "When I wake up, well, I'm sure I'm gonna be \n\n" + "I'm gonna be the one writin' code for you", title: "I wake up"),
        StepViewController.instantiate(delegate: self, buttonColor: UIColor(red: 0.96, green: 0, blue: 0.11, alpha: 1), text: "When I wake up, well, I'm sure I'm gonna be \n\n" + "I'm gonna be the one writin' code for you", title: "I wake up"),
        StepViewController.instantiate(delegate: self, buttonColor: UIColor(red: 0.96, green: 0, blue: 0.11, alpha: 1), text: "When I wake up, well, I'm sure I'm gonna be \n\n" + "I'm gonna be the one writin' code for you", title: "I wake up")
    ]
    
    private lazy var startOverViewController = StartOverViewController.instantiate(delegate: self)
    
    public init(router: Router) {
        self.router = router
    }
    
    public func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = stepViewControllers.first!
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
    
}

extension HowToCodeCoordinate: StepViewControllerDelegate {
    public func stepViewControllerDidPressNext(_ controller: StepViewController) {
        if let viewController = stepViewController(after: controller) {
            router.present(viewController, animated: true)
        } else {
            router.present(startOverViewController, animated: true)
        }
    }
    
    private func stepViewController(after controller: StepViewController) -> StepViewController? {
        guard let index = stepViewControllers.firstIndex(where: { $0 === controller }), index < stepViewControllers.count - 1 else {
            return nil
        }
        return stepViewControllers[index + 1]
    }
}

extension HowToCodeCoordinate: StartOverViewControllerDelegate {
    public func startOverViewControllerDidPressStartOver(_ controller: StartOverViewController) {
        router.dismiss(animated: true)
    }
}

*/
