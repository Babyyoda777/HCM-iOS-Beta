//
//  OnboardingView.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 12/08/2022.
//


import SwiftUI
import UIOnboarding
import Foundation


struct OnboardingView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIOnboardingViewController

    class Coordinator: NSObject, UIOnboardingViewControllerDelegate {
        func didFinishOnboarding(onboardingViewController: UIOnboardingViewController) {
            onboardingViewController.modalTransitionStyle = .crossDissolve
            onboardingViewController.dismiss(animated: true) {
                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
            
            }

        }
    }


    
    func makeUIViewController(context: Context) -> UIOnboardingViewController {
        let onboardingController: UIOnboardingViewController = .init(withConfiguration: .setUp())
        onboardingController.delegate = context.coordinator
        return onboardingController
    }
    
    func updateUIViewController(_ uiViewController: UIOnboardingViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return .init()
    }
    
}

