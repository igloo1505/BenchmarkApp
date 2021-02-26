//
//  LoginView.swift
//  BenchmarkApp
//
//  Created by Andrew Mueller on 2/23/21.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth


struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userAuth: UserAuth
    @State var currentNoonce: String?
    @State var userIdentifer: String?
    
    var body: some View {

        VStack {
                    Text(colorScheme == .dark ? "In dark mode" : "In light mode")
                    SignInWithAppleButton(.signIn,              //1
                          onRequest: { (request) in             //2
                            let noonce = randomNonceString()
                            currentNoonce = noonce
                            request.requestedScopes = [.fullName, .email]
                            request.nonce = sha256(noonce)
//                            request.state = myStateString()
                          },
                          onCompletion: { (result) in
                            switch result {
                            case .success(let authorization):
                                if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                            let userId = appleIDCredential.user
                                            let identityToken = appleIDCredential.identityToken
//                                            let authCode = appleIDCredential.authorizationCode
                                            let email = appleIDCredential.email
                                            let givenName = appleIDCredential.fullName?.givenName
                                            let familyName = appleIDCredential.fullName?.familyName
                                            print(userId, email, givenName, familyName)
//                                            let state = appleIDCredential.state
                                            authorizationController(didCompleteWithAuthorization: authorization)
                                            self.userAuth.authToken =  String(data: identityToken!, encoding: .utf8)!
                                            self.userAuth.isAuthenticated = true
                                            self.userAuth.userName = givenName
//                                            handleSuccessfulLogin(token: String(data: identityToken!, encoding: .utf8)!, userName: givenName)
                                        }
                                break
                            case .failure(let error):
                                //Handle error
                                print("SiginWithApple failed with : \(error)")
                                break
                            }
                          })
                        
        }
        .signInWithAppleButtonStyle(colorScheme == .dark ? .whiteOutline : .black)
//        .accentColor(.red)
        .frame(width: 280, height: 100, alignment: .center)
//        .cornerRadius(15)\
        .onAppear(perform: {
            currentNoonce = randomNonceString()
        })
    }
}

//MARK: - SIGNIN_WITH_APPLE fucntionality


extension LoginView {
    //        Create encrypted string to prevent attacks, similar to Mongodb secret
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}

extension LoginView {
    func authorizationController(didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNoonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
          // Initialize a Firebase credential.
            
            userIdentifer = idTokenString
          let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                    idToken: idTokenString,
                                                    rawNonce: nonce)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
              // Error. If error.code == .MissingOrInvalidNonce, make sure
              // you're sending the SHA256-hashed nonce as a hex string with
              // your request to Apple.
              print(error!.localizedDescription)
              return
            }
            // User is signed in to Firebase with Apple.
            // ...
          }
        }
      }
    func handleSuccessfulLogin(token: String, userName: String?) {
        print("Running shit down here")
        @ObservedObject var userAuth = UserAuth()
        userAuth.authToken = token
        userAuth.userName = userName
        userAuth.isAuthenticated = true
    }

      func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
      }
}




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
