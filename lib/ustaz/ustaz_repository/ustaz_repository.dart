import '../../admin/class_model.dart';
import '../../student/models/login_model.dart';
import '../../student/models/student.dart';
import '../models/ustaz_login_details_model.dart';
import '../models/ustaz_model.dart';
import '../models/ustaz_signup_model.dart';
import '../ustaz_data_provider/ustaz_data_provider.dart';

class UstazRepository {
  final UstazDataProvider ustazdataProvider;
  UstazRepository({required this.ustazdataProvider});

  Future<void> signupUstaz(UstazSignUpModel ustaz) {
    return ustazdataProvider.signupUstaz(ustaz);
  }

  Future<UstazLoginDetailsModel> login(LoginModel loginModel) async {
    return ustazdataProvider.login(loginModel);
  }

  Future<void> logout(String email) async {
    await ustazdataProvider.logout(email);
  }

  fetchstudents(String classId) async {
    try {
      final students = await ustazdataProvider.getstudentsOfclass(classId);
      return students;
    } catch (error) {
      throw Exception('Failed to fetch user profile');
    }
  }

  fetchallstudents() async {
    try {
      final students = await ustazdataProvider.getallstudents();
      return students;
    } catch (error) {
      throw Exception('Failed to fetch user profile');
    }
  }

   fetchallclasses() async {
    try {
      final students = await ustazdataProvider.getallclasses();
      return students;
    } catch (error) {
      throw Exception('Failed to fetch user profile');
    }
  }

   fetchallustazes() async {
    try {
      final ustazes = await ustazdataProvider.getallustazs();
      return ustazes;
    } catch (error) {
      throw Exception('Failed to fetch user profile');
    }
  }

  updateUserProfile(Student student) async {
    try {
      return await ustazdataProvider.updateUserProfile(student);
    } catch (error) {
      throw Exception('Failed to update user profile');
    }
  }

  updateClassProfile(Classs classs) async {
    try {
      return await ustazdataProvider.updateClassProfile(classs);
    } catch (error) {
      throw Exception('Failed to update user profile');
    }
  }
  updateustazProfile(Ustaz ustaz) async {
    try {
      return await ustazdataProvider.updatestazProfile(ustaz);
    } catch (error) {
      throw Exception('Failed to update user profile');
    }
  }

  addmark(String student_id, int date, int score, int end_ayah,
      String end_surah) async {
    try {
      return await ustazdataProvider.addmark(
          student_id, date, score, end_ayah, end_surah);
    } catch (error) {
      throw Exception('Failed to update user profile');
    }
  }

  deltemark(
    String student_id,
    int date,
  ) async {
    try {
      return await ustazdataProvider.deletemark(
        student_id,
        date,
      );
    } catch (error) {
      throw Exception('Failed to update user profile');
    }
  }

  addabscent(String student_id, String class_id, int date) async {
    try {
      return await ustazdataProvider.addabscent(student_id, class_id, date);
    } catch (error) {
      throw Exception('Failed to update user profile');
    }
  }

  deleteabscent(String student_id, int date) async {
    try {
      return await ustazdataProvider.deleteAbscent(student_id, date);
    } catch (error) {
      throw Exception('Failed to update user profile');
    }
  }

  // fetchUserProfile(String email) async {
  //   try {
  //     final userProfile = await dataProvider.fetchUserProfile(email);
  //     return userProfile;
  //   } catch (error) {
  //     throw Exception('Failed to fetch user profile');
  //   }
  // }

  // updateUserProfile(Student student) async {
  //   try {
  //     return await dataProvider.updateUserProfile(student);
  //   } catch (error) {
  //     throw Exception('Failed to update user profile');
  //   }
  // }
}
