// models/vpn.dart
class Vpn {
  late final String hostname;
  late final String ip;
  late final int ping; // Changed to int
  late final int speed;
  late final String countryLong;
  late final String countryShort;
  late final int numVpnSessions;
  late final String openVPNConfigDataBase64;
  late final int score; // Added score for sorting
  late final double lat; // Latitude of the server
  late final double lon; // Longitude of the server

  Vpn({
    required this.hostname,
    required this.ip,
    required this.ping,
    required this.speed,
    required this.countryLong,
    required this.countryShort,
    required this.numVpnSessions,
    required this.openVPNConfigDataBase64,
    required this.score, // Added score
    required this.lat,
    required this.lon,
  });

  Vpn.fromJson(Map<String, dynamic> json) {
    hostname = json['HostName'] ?? '';
    ip = json['IP'] ?? '';
    // Safely parse ping to int, default to a high value if invalid
    ping = int.tryParse(json['Ping']?.toString() ?? '9999') ?? 9999;
    speed = json['Speed'] ?? 0;
    countryLong = json['CountryLong'] ?? '';
    countryShort = json['CountryShort'] ?? '';
    numVpnSessions = json['NumVpnSessions'] ?? 0;
    openVPNConfigDataBase64 = json['OpenVPN_ConfigData_Base64'] ?? '';
    score = json['Score'] ?? 0; // Assuming 'Score' is a field from VPNGate API
    lat = double.tryParse(json['Lat']?.toString() ?? '0.0') ?? 0.0;
    lon = double.tryParse(json['Lon']?.toString() ?? '0.0') ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['HostName'] = hostname;
    data['IP'] = ip;
    data['Ping'] = ping.toString(); // Store as string if needed by Prefs
    data['Speed'] = speed;
    data['CountryLong'] = countryLong;
    data['CountryShort'] = countryShort;
    data['NumVpnSessions'] = numVpnSessions;
    data['OpenVPN_ConfigData_Base64'] = openVPNConfigDataBase64;
    data['Score'] = score;
    data['Lat'] = lat;
    data['Lon'] = lon;
    return data;
  }
}