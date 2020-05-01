//
//  OnboardingViewController.swift
//  WorldVent
//
//  Created by Timothy Ekl on 4/30/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import UIKit

/// User defaults key for the last app version in which we showed (and completed) the
/// onboarding controller. Onboarding will be presented if the user defaults value for this
/// key is older than the onboarding update version key. The associated value is an integer.
private let LastCompletedOnboardingVersionKey = "LastCompletedOnboardingVersion"

/// User defaults key that, if set, forces the onboarding screen visible on app launch.
private let ForceOnboardingVisibleKey = "ForceOnboardingVisible"

/// Int constant for the last time this app updated its onboarding process. Onboarding
/// will be presented if the user defaults value for the "last version" key is older than
/// this value.
private let OnboardingVersion = 1

class OnboardingTabBarController: UITabBarController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showOnboardingIfNeeded()
    }
    
    private static var needsOnboarding: Bool {
        if UserDefaults.standard.bool(forKey: ForceOnboardingVisibleKey) {
            return true
        }
        
        let lastOnboardingVersion = UserDefaults.standard.integer(forKey: LastCompletedOnboardingVersionKey)
        return lastOnboardingVersion < OnboardingVersion
    }
    
    private func showOnboardingIfNeeded() {
        guard Self.needsOnboarding else { return }
        performSegue(withIdentifier: "showOnboarding", sender: self)
    }
    
    @IBAction func unwindFromOnboarding(_ segue: UIStoryboardSegue!) {
        UserDefaults.standard.set(OnboardingVersion, forKey: LastCompletedOnboardingVersionKey)
    }
}

// MARK: -

class OnboardingViewController: UIViewController {
    @IBOutlet var doneButtonItem: UIBarButtonItem!
    
    private var allowDismiss: Bool {
        get {
            return doneButtonItem.isEnabled
        }
        set {
            doneButtonItem.isEnabled = newValue
            
            if #available(iOS 13.0, *) {
                isModalInPresentation = !newValue
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allowDismiss = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.allowDismiss = true
        }
    }
}
