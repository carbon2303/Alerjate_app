class ImageService {
  static String getImage(String productName) {
    final name = productName.toLowerCase();

    if (name.contains('yogurt')) {
      return 'assets/images/yogurt.png';
    }

    if (name.contains('leche')) {
      return 'assets/images/leche.png';
    }

    if (name.contains('pan integral')) {
      return 'assets/images/pan_integral.png';
    }

    if (name.contains('pan blanco')) {
      return 'assets/images/pan_blanco.png';
    }

    if (name.contains('mayonesa')) {
      return 'assets/images/mayonesa.png';
    }

    if (name.contains('cacahuate')) {
      return 'assets/images/cacahuates.png';
    }

    if (name.contains('carlos v')) {
      return 'assets/images/carlosv.png';
    }

    if (name.contains('atun')) {
      return 'assets/images/atun.png';
    }

    if (name.contains('salsa soya')) {
      return 'assets/images/salsasoya.png';
    }

    return 'assets/images/default.jpg';
  }
}
