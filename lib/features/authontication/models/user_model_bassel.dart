
// Model class representing user data.
import '../../../../utils/formatter/formatter.dart';
/*
{"message":"Sign in success","status":"true","info":{"ID":"67","TOKEN":"67::2::3621c0153f2b059ac9d30f54826302f7",
"FName":"muhammad","LName":"muhammad","ActiveAccount":"1","EMail":"eng.muhammadaliah@gmail.com","Rate":"0",
"Balance":"0","UserName":"eng.muhammadaliah@gmail.com","Sex":"0","Mobile":"89015058234",
"CountryCode":"RU","CountryName":"Russian Federation","AdminMessage":"Need to be activated",
"AudioGender":"0","alnashra_active":"false"}},{"message":"Unable to register token","status":"false"}
 */
class UserModelBassel {
  // Keep those values final which you do not want to update
  final String id;
  String firstName;
  String lastName;
   String username;
   String email;
  String phoneNumber;
  String profilePicture;
  final String password;
  String country;
  String sex;
  String token;
  String activeAccount ='0';
// Constructor for UserModel.
  UserModelBassel({
    this.id='',
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.profilePicture='',
  this.token ='',
    this.sex='1',
    this.activeAccount='0',
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
  static UserModelBassel empty() =>
      UserModelBassel(id: '',
          firstName: '',
          lastName: '',
          username: '',
          email: '',
          password: '',
          phoneNumber: '',
          activeAccount: '0',
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
      'TOKEN':token,
      'country':country,
      'mobile': phoneNumber,
      'ActiveAccount':activeAccount,
      'ProfilePicture': profilePicture,};
  }

  /// Factory method to create a UserModel from a Firebase document snapshot.


/*
{"ID":"22","TOKEN":"22::2::c19cf4b32a13f4697c970f4fe91672c0","FName":"bassel","LName":"sm",
"ActiveAccount":"1","EMail":"bassel@e-gate.me","Rate":"0","Balance":"0","UserName":"bassel","Sex":"1","Mobile":"963944233037",
"CountryCode":null,"CountryName":"","AdminMessage":"Account need activation","AudioGender":"0","alnashra_active":"false"}}
 */
  factory UserModelBassel.fromJson(Map<String, dynamic> data) {
    if (data != null) {
      return UserModelBassel(
        id: data['ID'] ?? '',
        firstName: data['FName'] ?? '',
        lastName: data['LName'] ?? '',
        username: data['UserName'] ?? '',
        email: data['EMail'] ?? '',
        phoneNumber: data['Mobile'] ?? '',
        password: data['password'] ?? '',
        sex: data['Sex'] ?? '',
        activeAccount: data['ActiveAccount'] ?? '0',
        token: data['TOKEN'] ?? '',
        country: data['CountryCode'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
      );
    } else {
      return UserModelBassel.empty();
      // Either return a default value or throw an exception
      // return UserModel(id: '', firstName: '', lastName: '', ...); // Default values
      //throw Exception('Document data is null'); // Or throw an exception
    }
  }

  factory UserModelBassel.fromJsonShared(Map<String, dynamic> data) {
    if (data != null) {
      return UserModelBassel(
        //id: data['ID'] ?? '',
        firstName: data['fname'] ?? '',
        lastName: data['lname'] ?? '',
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        phoneNumber: data['mobile'] ?? '',
        password: data['password'] ?? '',
        sex: data['sex'] ?? '',
        activeAccount: data['ActiveAccount'] ?? '0',
        token: data['TOKEN'] ?? '',
        country: data['country'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
      );
    } else {
      return UserModelBassel.empty();
      // Either return a default value or throw an exception
      // return UserModel(id: '', firstName: '', lastName: '', ...); // Default values
      //throw Exception('Document data is null'); // Or throw an exception
    }
  }
}
