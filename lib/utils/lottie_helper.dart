String getLottiePath(String condition) {
  switch (condition.toLowerCase()) {
    case 'clear':
      return 'assets/animations/clear.json';
    case 'clouds':
      return 'assets/animations/clouds.json';
    case 'rain':
      return 'assets/animations/rain.json';
    case 'thunderstorm':
      return 'assets/animations/thunderstorm.json';
    case 'snow':
      return 'assets/animations/snow.json';
    case 'fog':
    case 'mist':
    case 'haze':
      return 'assets/animations/fog.json';
    default:
      return 'assets/animations/clear.json';
  }
}
