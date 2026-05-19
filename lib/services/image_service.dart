class ImageService {
  static String getImage(String productName) {
    final name = productName.toLowerCase();

    if (name.contains('aceite')) {
      return 'assets/images/aceite_aguacate.jpg';
    }

    if (name.contains('arroz')) {
      return 'assets/images/arroz_lentejas.jpg';
    }

    if (name.contains('anacardo')) {
      return 'assets/images/crema_anacardos.jpg';
    }

    if (name.contains('mani')) {
      return 'assets/images/crema_mani.jpeg';
    }

    if (name.contains('diclofenaco')) {
      return 'assets/images/diclofenaco.png';
    }

    if (name.contains('frutilla')) {
      return 'assets/images/frutilla_mermelada.png';
    }

    if (name.contains('galletas')) {
      return 'assets/images/galletas.jpg';
    }

    if (name.contains('helado')) {
      return 'assets/images/helado_coco.jpeg';
    }

    if (name.contains('ibuprofeno')) {
      return 'assets/images/ibuprofeno.jpg';
    }

    if (name.contains('chocolate')) {
      return 'assets/images/leche_chocolate.jpg';
    }

    if (name.contains('almendra')) {
      return 'assets/images/leche_almendra.jpg';
    }

    if (name.contains('mantequilla')) {
      return 'assets/images/mantequilla_vegana.jpg';
    }

    if (name.contains('naproxeno')) {
      return 'assets/images/naproxeno.png';
    }

    if (name.contains('omeprazol')) {
      return 'assets/images/omeprazol.jpg';
    }

    if (name.contains('paracetamol')) {
      return 'assets/images/paracetamol.jpg';
    }

    if (name.contains('rotini')) {
      return 'assets/images/rotini_lentejas.png';
    }

    return 'assets/images/logo.png';
  }
}
