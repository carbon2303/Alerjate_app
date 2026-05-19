class ImageHelper {
  static String fixImage(String path) {
    if (path.startsWith('http')) return path;

    return 'https://alerjate-production.up.railway.app/$path';
  }
}
