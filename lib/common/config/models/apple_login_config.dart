class AppleLoginConfig {
  const AppleLoginConfig({this.iOSBundleId, this.appleAccountTeamID});

  final String? iOSBundleId;
  final String? appleAccountTeamID;

  factory AppleLoginConfig.fromJson(Map json) {
    return AppleLoginConfig(
        iOSBundleId: json['iOSBundleId'],
        appleAccountTeamID: json['appleAccountTeamID']);
  }

  Map<String, dynamic> toJson() {
    return {
      'iOSBundleId': iOSBundleId,
      'appleAccountTeamID': appleAccountTeamID
    };
  }
}
