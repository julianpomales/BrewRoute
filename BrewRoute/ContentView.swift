import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct ContentView: View {
    @State private var isSignedIn = false
    @State private var userName: String = ""

    var body: some View {
        VStack {
            if isSignedIn {
                VStack {
                    Text("Welcome, \(userName)! ✅")
                        .font(.title)
                        .padding()

                    Button(action: signOut) {
                        Text("Sign Out")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            } else {
                Button(action: handleSignIn) {
                    HStack {
                        Image(systemName: "g.circle") // Google-style icon
                            .font(.title)
                        Text("Sign in with Google")
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .onAppear {
            checkSignInStatus()
        }
    }

    // MARK: - Handle Google Sign-In
    func handleSignIn() {
        guard let rootViewController = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController else {
            print("❌ No root view controller found.")
            return
        }


        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error {
                print("❌ Google Sign-In Error: \(error.localizedDescription)")
                return
            }

            guard let user = signInResult?.user, let idToken = user.idToken else {
                print("❌ Google Sign-In: No User Found")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("❌ Firebase Sign-In Error: \(error.localizedDescription)")
                    return
                }

                print("✅ User Signed In: \(user.profile?.name ?? "No Name")")
                self.userName = user.profile?.name ?? "User"
                self.isSignedIn = true
            }
        }
    }

    // MARK: - Check If User is Already Signed In
    func checkSignInStatus() {
        if let user = Auth.auth().currentUser {
            self.userName = user.displayName ?? "User"
            self.isSignedIn = true
        }
    }

    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            self.isSignedIn = false
            print("✅ User Signed Out")
        } catch {
            print("❌ Sign-Out Error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
