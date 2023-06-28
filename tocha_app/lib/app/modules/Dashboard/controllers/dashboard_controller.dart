import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DashboardController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? get currentUser => _auth.currentUser;
  Future<void> googleLogin() async {
    try {
      print("googleLogin method Called");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      await googleUser.authentication;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // final todoController = Get.find<TodosController>();
          // todoController.fetchTodos();
          Get.offNamed('/home');
        }
      } catch (error) {
        print(error);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    Get.offNamed('/dashboard');
  }
}
