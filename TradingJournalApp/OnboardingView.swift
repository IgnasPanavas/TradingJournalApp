import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore
import FirebaseAuth


struct OnboardingView1: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(.init(red: 0.2, green: 0.2, blue: 0.25))
                    .cornerRadius(20)
                    .frame(width: min(geometry.size.width, geometry.size.height) * 0.8, height: min(geometry.size.width, geometry.size.height) * 0.8)

                VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        
                        Text("Track All Your Trades")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                        
                        Text("Easily add and manage Option, Future, or Stock Trades all in one place.")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .frame(width: 250)
                    }
                .offset(y: -50)
                .padding([.top], 20)
                .padding([.leading], 8)
            }
            .padding(.horizontal, (geometry.size.width - (min(geometry.size.width, geometry.size.height) * 0.8)) / 2)
            .offset(x: 0, y: (geometry.size.height - (min(geometry.size.width, geometry.size.height) * 0.8)) / 2)
        }
    }
}
struct OnboardingView2: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(.init(red: 0.2, green: 0.2, blue: 0.25))
                    .cornerRadius(20)
                    .frame(width: min(geometry.size.width, geometry.size.height) * 0.8, height: min(geometry.size.width, geometry.size.height) * 0.8)
                
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60) // Explicitly set the size of the image
                        .foregroundColor(.blue)
                    
                    Text("Track Your Progress")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                    
                    Text("See important statistics and visuals of your trading journey.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(width: 250)
                }
                .offset(y: -60)
                .padding([.top], 20)
                .padding([.leading], 8)
            }
            .padding(.horizontal, (geometry.size.width - (min(geometry.size.width, geometry.size.height) * 0.8)) / 2)
            .offset(x: 0, y: (geometry.size.height - (min(geometry.size.width, geometry.size.height) * 0.8)) / 2)
        }
    }
}
struct OnboardingView3: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(.init(red: 0.2, green: 0.2, blue: 0.25))
                    .cornerRadius(20)
                    .frame(width: min(geometry.size.width, geometry.size.height) * 0.8, height: min(geometry.size.width, geometry.size.height) * 0.8)
                
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "icloud.and.arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60) // Explicitly set the size of the image
                        .foregroundColor(.blue)
                    
                    Text("Connect With ThinkOrSwim")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                    
                    Text("Seamlessly connect your ThinkOrSwim account and port your trades automatically.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(width: 250)
                }
                .offset(y: -30)
                .padding([.top], 20)
                .padding([.leading], 8)
            }
            .padding(.horizontal, (geometry.size.width - (min(geometry.size.width, geometry.size.height) * 0.8)) / 2)
            .offset(x: 0, y: (geometry.size.height - (min(geometry.size.width, geometry.size.height) * 0.8)) / 2)
        }
    }
}
struct LoginView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    @Binding var isLoggedIn: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(.init(red: 0.2, green: 0.2, blue: 0.25))
                    .cornerRadius(20)
                    .frame(width: min(geometry.size.width, geometry.size.height) * 0.8, height: min(geometry.size.width, geometry.size.height) * 0.8)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sign In")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Sign In to Continue")
                        .font(.title2) // made the font size bigger
                        .foregroundColor(.white) // changed text color to white
                        .multilineTextAlignment(.leading)
                    
                }
                .padding(.top, -100) // added top padding of 5
                .padding([.leading], -50) // added leading padding of 15
                
                
                Button("Sign In with Google") {
                    self.viewModel.signInWithGoogle()
                    self.isLoggedIn = self.viewModel.isLoggedIn
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(40)
                .padding([.top], 100)
            }
            .padding(.horizontal, (geometry.size.width - (min(geometry.size.width, geometry.size.height) * 0.8)) / 2)
            .offset(x: 0, y: (geometry.size.height - (min(geometry.size.width, geometry.size.height) * 0.8)) / 2)
        }
    }
}



// Dynamic Onboarding View
struct OnboardingView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    
    var views: [AnyView] {
        return [
            AnyView(OnboardingView1()),
            AnyView(OnboardingView2()),
            AnyView(OnboardingView3()),
            AnyView(LoginView(isLoggedIn: $viewModel.isLoggedIn)
                .environmentObject(viewModel)),
            // Add more views as needed
        ]
    }

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color.black)
                .ignoresSafeArea()
            TabView {
                ForEach(views.indices, id: \.self) { index in
                    self.views[index]
                }
                
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
    }
}


// Example parent view (unchanged)
struct ContentView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    @ObservedObject var userViewModel = UserViewModel()
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    // Single source of truth for the main view to display
    @State private var activeView: ActiveViewType = .onboarding

    enum ActiveViewType {
        case onboarding
        case welcome
        case mainTabView
        case login
    }

    var body: some View {
        VStack {
            switch activeView {
            case .onboarding:
                            OnboardingView()
                                .environmentObject(viewModel)
                                .onAppear {
                                    hasOnboarded = true
                                }
            case .welcome:
                            WelcomeView()
                                .environmentObject(userViewModel)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        activeView = viewModel.isLoggedIn ? .mainTabView : .login
                                    }
                                }
            case .login:
                            LoginView(isLoggedIn: $viewModel.isLoggedIn)
                                .environmentObject(viewModel)
            case .mainTabView:
                            MainTabView()
                                .environmentObject(userViewModel)
                        }
                    }
                    .onAppear {
                        if !hasOnboarded {
                            activeView = .onboarding
                        } else {
                            activeView = viewModel.isLoggedIn ? .mainTabView : .login
                        }
                    }
                    .onChange(of: viewModel.isLoggedIn) { newValue in
                        if newValue == false { // Check if logged out
                            activeView = .login
                        } else {
                            activeView = .welcome
                        }
                    }
    }
}

struct WelcomeView: View {
    @State private var opacity: Double = 1.0
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .fill(Color.black)
                .opacity(0.5)
                .frame(width: 320, height: 480)
            
            VStack(alignment: .center) {
                Text("Welcome, \(userViewModel.name.components(separatedBy: " ").first ?? "")")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    
                    // Apply the fade-in animation to the VStack
                    .animation(Animation.linear(duration: 1.0).delay(0.0))
            }
        }
        
        .transition(.opacity)
    }
}
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SignInViewModel())
        
    }
}
