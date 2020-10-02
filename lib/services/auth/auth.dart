import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Stream get userStream {
  return auth.authStateChanges();
}

Future<User> signInWithFacebook() async {
  try {
    final FacebookLogin facebookLogIn = FacebookLogin();

    final result = await facebookLogIn.logIn(['email']);
    final token = result.accessToken.token;
    if (result.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.credential(token);
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      return userCredential.user;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User> signInWithGoogle() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount account = await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication =
        await account.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken);

    final UserCredential userCredential =
        await auth.signInWithCredential(authCredential);

    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<void> logOut() async {
  await auth.signOut();
}
