import SwiftUI
import Firebase

class UserViewModel: ObservableObject {
    @Published var uid: String = ""
    @Published var email: String = ""
    @Published var photoURLString: String = ""
    @Published var multiFactorString: String = "MultiFactor: "
    @Published var name: String = ""
    
    var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.updateUserData(user: user)
        }
    }
    
    func updateUserData(user: User?) {
        if let user = user {
            uid = user.uid
            email = user.email ?? ""
            name = user.displayName ?? ""
            photoURLString = user.photoURL?.absoluteString ?? ""
            multiFactorString = "MultiFactor: "
            for info in user.multiFactor.enrolledFactors {
                multiFactorString += "\(info.displayName ?? "[DisplayName]") "
            }
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
