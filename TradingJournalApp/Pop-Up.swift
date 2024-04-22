
import SwiftUI

extension View {
    func alertError<T>(_ errorClosure: () throws -> T) -> ModifiedContent<Self, ErrorAlert> where Self: View {
        return modifier(ErrorAlert(errorMessage: catchErrorMessage(errorClosure)))
    }
    
    private func catchErrorMessage<T>(_ errorClosure: () throws -> T) -> String {
        do {
            try errorClosure()
            return "" // No error, return empty string
        } catch {
            return error.localizedDescription
        }
    }
}
struct ErrorAlert: ViewModifier {
    @State private var isShowingAlert = false
    let errorMessage: String
    
    func body(content: Content) -> some View {
            content
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Error Occurred!"), message: Text(self.errorMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                self.isShowingAlert = true
            }
    }
}

