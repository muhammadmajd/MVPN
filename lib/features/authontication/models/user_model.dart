
// Model class representing user data.
import '../../../../utils/formatter/formatter.dart';

class UserModel {
  // Keep those values final which you do not want to update
  final String id;
  String firstName;
  String lastName;
  final String username;
  final String email;
  String phoneNumber;
  String profilePicture;
  final String password;
   String country;
   String sex;

// Constructor for UserModel.
  UserModel({
     this.id='',
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
     this.profilePicture='',

    this.sex='1',
    this.country='sy'
  });

// Helper function to get the full name.
  String get fullName => '$firstName $lastName';

// Helper function to format phone number.
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  /// Static function to split full name into first and last name.
  static List<String> nameParts(fullName) => fullName.split(" ");

  /// Static function to generate a username from the full name.
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts [0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts [1].toLowerCase() : "";
    String camelCaseUsername = "$firstName$lastName"; // Combine first and last name
    String usernameWithPrefix = "cwt_$camelCaseUsername"; // Add "cwt_" prefix
    return usernameWithPrefix;
  }

  // Static function to create an empty user model.
  static UserModel empty() =>
      UserModel(id: '',
          firstName: '',
          lastName: '',
          username: '',
          email: '',
          password: '',
          phoneNumber: '',
          country: '',
          sex: '',
          profilePicture: '');

  /// Convert model to JSON structure for storing data in Firebase.
  ///
  /*
  https://alnashra.org/karna/trial/app/api/services.php?service=register&email=bassel@e-gate.me&
  user_name=bassel&fname=bassel&lname=sm&mobile=963944233037&sex=1&country=sy&password=123456

*/
  Map<String, dynamic> toJson() {
    return {

      'fname': firstName,
      'lname': lastName,
      'username': username,
      'email': email,
      'mobile': phoneNumber,
      'password': password,
      'sex':sex,
      'country':country,
      'mobile': phoneNumber,
      'ProfilePicture': profilePicture,};
  }

  /// Factory method to create a UserModel from a Firebase document snapshot.



  factory UserModel.fromJson(Map<String, dynamic> data) {
    if (data != null) {
      return UserModel(

        firstName: data['fname'] ?? '',
        lastName: data['lname'] ?? '',
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        phoneNumber: data['mobile'] ?? '',
        password: data['password'] ?? '',
        sex: data['sex'] ?? '',
        country: data['country'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
      );
    } else {
      return UserModel.empty();
      // Either return a default value or throw an exception
      // return UserModel(id: '', firstName: '', lastName: '', ...); // Default values
      //throw Exception('Document data is null'); // Or throw an exception
    }
  }
}