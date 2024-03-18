class Endpoints {
  static const String _baseUrl = "http://capefmobile.myeasycards.com/agents";

  static String get login => '$_baseUrl/login';
  static String get refresh => '$_baseUrl/refreshtoken';
  static String get generalReport => '$_baseUrl/getgeneralreport';
}
