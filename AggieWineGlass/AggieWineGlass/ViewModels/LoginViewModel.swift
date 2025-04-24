//
//  RestaurantViewModel.swift
//  AggieWineGlass
//
//  Created by Ariela Mitrani on 4/24/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class RestaurantViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoginMode = true
    @Published var errorMessage = ""
    @Published var isLoggedIn = false

    private var db = Firestore.firestore()

    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    self.errorMessage = ""
                    self.isLoggedIn = true
                }
            }
        }
    }

    func signUpUser() {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }

            if snapshot?.isEmpty == false {
                DispatchQueue.main.async {
                    self.errorMessage = "Email already in use"
                }
                return
            }

            Auth.auth().createUser(withEmail: self.email, password: self.password) { result, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                    return
                }

                guard let userId = result?.user.uid else { return }

                self.db.collection("users").document(userId).setData([
                    "email": self.email,
                    "name": "Default Name",
                    "profilePicture": "https://example.com/default-profile.png"
                ]) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = "Error saving user data: \(error.localizedDescription)"
                        } else {
                            self.isLoggedIn = true
                        }
                    }
                }
            }
        }
    }
}
