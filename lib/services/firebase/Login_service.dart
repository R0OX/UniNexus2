import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/student_model.dart';
import '../../model/faculty_model.dart';
import '../../model/staff_model.dart';

// Enum to clearly distinguish login results
enum LoginResult {
  success,
  userNotFound,
  passwordMismatch,
  invalidPrefix,
  signUpRequired,
  error
}

// Model for a successful login to pass around the app
class AuthData {
  final dynamic user;
  final UserType type;
  AuthData({required this.user, required this.type});
}

// Enum to track the user type
enum UserType { student, faculty, staff }

class LoginService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Main entry point: Dispatches to specific functions based on prefix
  Future<Map<String, dynamic>> login(String code, String password) async {
    try {
      // Clean input: remove spaces and uppercase for comparison
      final cleanCode = code.toUpperCase().trim();
      final cleanPassword = password.trim();

      if (cleanCode.length < 2) {
        return {'status': LoginResult.invalidPrefix};
      }

      final prefix = cleanCode.substring(0, 2);

      // Route to the correct function based on the first two letters
      switch (prefix) {
        case 'ST':
          return await _loginStudent(cleanCode, cleanPassword);

        case 'FA':
          return await _loginFaculty(cleanCode, cleanPassword);

        case 'IT':
        case 'SC':
        case 'AD':
          return await _loginStaff(cleanCode, cleanPassword);

        default:
          return {'status': LoginResult.invalidPrefix};
      }
    } catch (e) {
      print('Login Dispatch Error: $e');
      return {'status': LoginResult.error};
    }
  }

  // -------------------------------------------------------------------
  // --- Specific Login Function for Students (with 'app' check) ---
  // -------------------------------------------------------------------
  Future<Map<String, dynamic>> _loginStudent(String code, String password) async {
    try {
      final querySnapshot = await _firestore
          .collection('students')
          .where('ID', isEqualTo: code)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return {'status': LoginResult.userNotFound};
      }

      final docData = querySnapshot.docs.first.data();
      final student = Student.fromJson(docData);

      // 1. Verify Password
      if (student.pass == password) {

        // 2. CHECK: Is the 'app' field true?
        if (student.app == true) {
          return {
            'status': LoginResult.success,
            // SEND NAMES for SharedPrefs
            'firstName': student.fName,
            'lastName': student.lName,
            // KEEP AUTH DATA for App State
            'data': AuthData(
              user: student,
              type: UserType.student,
            ),
          };
        } else {
          return {'status': LoginResult.signUpRequired};
        }

      } else {
        return {'status': LoginResult.passwordMismatch};
      }
    } catch (e) {
      print('Student Login Error: $e');
      return {'status': LoginResult.error};
    }
  }

  // -------------------------------------------------------------------
  // --- Specific Login Function for Faculty ---
  // -------------------------------------------------------------------
  Future<Map<String, dynamic>> _loginFaculty(String code, String password) async {
    try {
      final querySnapshot = await _firestore
          .collection('faculty')
          .where('ID', isEqualTo: code)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return {'status': LoginResult.userNotFound};
      }

      final docData = querySnapshot.docs.first.data();
      final faculty = Faculty.fromJson(docData);

      // 1. Verify Password
      if (faculty.pass == password) {
        return {
          'status': LoginResult.success,
          // SEND NAMES for SharedPrefs
          'firstName': faculty.fName,
          'lastName': faculty.lName,
          // KEEP AUTH DATA for App State
          'data': AuthData(
            user: faculty,
            type: UserType.faculty,
          ),
        };
      } else {
        return {'status': LoginResult.passwordMismatch};
      }
    } catch (e) {
      print('Faculty Login Error: $e');
      return {'status': LoginResult.error};
    }
  }

  // -------------------------------------------------------------------
  // --- Specific Login Function for Staff ---
  // -------------------------------------------------------------------
  Future<Map<String, dynamic>> _loginStaff(String code, String password) async {
    try {
      final querySnapshot = await _firestore
          .collection('staff')
          .where('ID', isEqualTo: code)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return {'status': LoginResult.userNotFound};
      }

      final docData = querySnapshot.docs.first.data();
      final staff = Staff.fromJson(docData);

      // 1. Verify Password
      if (staff.pass == password) {
        return {
          'status': LoginResult.success,
          // SEND NAMES for SharedPrefs
          'firstName': staff.fName,
          'lastName': staff.lName,
          // KEEP AUTH DATA for App State
          'data': AuthData(
            user: staff,
            type: UserType.staff,
          ),
        };
      } else {
        return {'status': LoginResult.passwordMismatch};
      }
    } catch (e) {
      print('Staff Login Error: $e');
      return {'status': LoginResult.error};
    }
  }
}