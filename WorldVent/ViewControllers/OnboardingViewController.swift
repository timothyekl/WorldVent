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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneButtonItem.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.doneButtonItem.isEnabled = true
        }
    }
}
