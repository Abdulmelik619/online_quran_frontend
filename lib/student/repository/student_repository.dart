import 'package:online_quran_frontend/student/data_providers/student_data_provider.dart';
import 'package:online_quran_frontend/student/models/models.dart';
import 'package:online_quran_frontend/student/models/signup_model.dart';

import '../models/login_details.dart';
import '../models/login_model.dart';

class StudentRepository {
  final StudentDataProvider dataProvider;
  StudentRepository({required this.dataProvider});

  Future<void> signup(SignUpModel student) {
    print("level: SignupRepository");

    return dataProvider.signup(student);
  }

  Future<void> addClass(String className, String dateCreated, String assignedTeacherId) {
    print("level: SignupRepository");

    return dataProvider.addClass(className, dateCreated, assignedTeacherId);
  }

  login(LoginModel loginModel) async {
    return dataProvider.login(loginModel);
  }

  Future<void> logout(String email) async {
    await dataProvider.logout(email);
  }

  Future<void> deletestudent(String email) async {
    await dataProvider.deletestudent(email);
  }
  Future<void> deleteclass(String id) async {
    await dataProvider.deleteclass(id);
  }

  Future<void> deleteustaz(String email) async {
    await dataProvider.deleteustaz(email);
  }

  fetchUserProfile(String email) async {
    try {
      final userProfile = await dataProvider.fetchUserProfile(email);
      return userProfile;
    } catch (error) {
      throw Exception('Failed to fetch user profile');
    }
  }

  updateUserProfile(Student student) async {
    try {
      return await dataProvider.updateUserProfile(student);
    } catch (error) {
      throw Exception('Failed to update user profile');
    }
  }

}
