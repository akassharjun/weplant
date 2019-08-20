class Constants {
  //      'https://173.82.130.86:9090/api/v1/users',
  static const IP_ADDRESS = '173.82.130.86';
  static const PORT = '9090';
  static const URL = 'http://$IP_ADDRESS:$PORT';

  static const USER_ENDPOINT = '/api/v1/users';
  static const PLANT_INFORMATION_ENDPOINT = '/api/v1/plantInformation';

  static const URL_USER = '$URL$USER_ENDPOINT';
  static const URL_PLANT_INFORMATION = '$URL$PLANT_INFORMATION_ENDPOINT';
}