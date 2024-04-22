import SwiftUI

struct UserDataView: View {
    @EnvironmentObject var userViewModel: UserViewModel
   
    
    var body: some View {
            VStack(spacing: 20) {
                Text("Account Information")
                    .font(.title)
                    .bold()
                
                HStack(spacing: 20) {
                    if let photoURL = URL(string: userViewModel.photoURLString) {
                        AsyncImage(url: photoURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(userViewModel.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(userViewModel.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                
            }
            .frame(maxWidth: .infinity, idealHeight: 200)
    }
}
