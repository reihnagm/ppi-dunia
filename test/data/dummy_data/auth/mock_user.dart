import 'package:ppidunia/data/models/auth/user.dart';

class MockUser {
  static const UserData expectedUserData = UserData(
    id: "83bb0fe2-6a14-49d7-bb03-14ad9e4f12f7",
    email: "test@mail.com",
    emailActivated: true,
    firstName: "Test",
    lastName: "Testing",
    role: "Automation Unit",
  );

  // static final Map<String, dynamic> dummyUserJson = expectedUserData.toJson();

  // static final Map<String, dynamic> expectedResponseModel = {
  //   "status": 200,
  //   "error": false,
  //   "message": "Ok",
  //   "data": {
  //     "token": "token",
  //     "refresh_token": "refreshToken",
  //     "user": dummyUserJson,
  //   },
  // };
}
