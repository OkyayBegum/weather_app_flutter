String getBackgroundImage(String condition) {
  switch (condition.toLowerCase()) {
    case 'clear':
      return 'assets/images/clear.jpg';
    case 'clouds':
      return 'assets/images/clouds.jpg';
    case 'rain':
      return 'assets/images/rain.jpg';
    case 'snow':
      return 'assets/images/snow.jpg';
    case 'thunderstorm':
      return 'assets/images/thunderstorm.jpeg';
    case 'mist':
    case 'fog':
      return 'assets/images/mist.jpg';
    default:
      return 'assets/images/clear.jpg';
  }
}

