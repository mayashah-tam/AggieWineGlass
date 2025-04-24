import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.isLoginMode ? "Login" : "Sign Up")
                    .font(.largeTitle)
                    .padding()

                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 10)

                if !viewModel.isLoginMode {
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                }

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 10)
                }

                Button(action: {
                    viewModel.isLoginMode ? viewModel.loginUser() : viewModel.signUpUser()
                }) {
                    Text(viewModel.isLoginMode ? "Login" : "Sign Up")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    viewModel.isLoginMode.toggle()
                }) {
                    Text(viewModel.isLoginMode ? "Don't have an account? Sign Up" : "Already have an account? Log In")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }

                if viewModel.isLoggedIn {
                    Text("Welcome! You are logged in.")
                        .padding()
                        .font(.title2)
                }
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
