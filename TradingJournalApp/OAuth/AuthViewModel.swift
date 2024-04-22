import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift



class SignInViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")

    func signInWithGoogle(){
        // Assuming GIDSignIn.sharedInstance has been properly configured
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = config
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController, completion: { [weak self] result, error in
                if let error = error {
                    // Handle any errors here
                    print(error.localizedDescription)
                    return
                }
                guard let user = result?.user,
                    let idToken = user.idToken?.tokenString
                else {
                    print(SignInError.unknownError.localizedDescription)
                    return
                }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                accessToken: user.accessToken.tokenString)
                Auth.auth().signIn(with: credential) { result, error in

                  // At this point, our user is signed in
                }
                // Process the sign-in user object
                print("Set isLoggedIn to true")
                self?.isLoggedIn = true
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            })
        }
    }
    func signOut() {
        // Sign out from Firebase Authentication
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out from Firebase Authentication: \(error.localizedDescription)")
        }

        // Sign out from Google Sign-In
        GIDSignIn.sharedInstance.signOut()

        // Update the isLoggedIn property
        self.isLoggedIn = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}
