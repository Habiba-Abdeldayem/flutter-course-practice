import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google sign in
  signInWithGoogle() async {
    // begin interactive sign in process (choose google email)
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // finally, lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   // GoogleSignIn signIn = GoogleSignIn.instance;

//   signInWithGoogle() async {
//     String webClientId =
//         "872382998383-vaqua7kqqe26i4kkc91meltk34bg0f71.apps.googleusercontent.com";

//     // begin interactive sign in process
//     // await signIn.initialize(serverClientId: "");
//     // signIn.authenticate();

//     try {
      
//       GoogleSignIn signIn = GoogleSignIn.instance;
//       await signIn.initialize(serverClientId: webClientId);
//       // gives us list of all the google accounts logged in the mobile, user picks 1 account and it will be saved in account variable
//       GoogleSignInAccount? googleAccount = await signIn.authenticate();

//       if (googleAccount == null) {
//         print("User canceled the google sign-in");
//         return null;
//       }
//       final GoogleSignInAuthentication googleAuth =
//           await googleAccount.authentication;
//       final credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//       );

//       // after we got user google account, log in with it into firebase
//       return await FirebaseAuth.instance.signInWithCredential(credential);
//     } on Exception catch (e) {
//       print(e);
//       return null;
//     }
//   }
// }
