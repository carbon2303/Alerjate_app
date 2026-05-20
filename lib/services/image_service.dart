class ImageService {
  static String getImage(String name) {
    final n = name.toLowerCase();

    switch (n) {
      case "barra_almendra":
        return "assets/images/barra_almendra.png";

      case "barra_cacahuate":
        return "assets/images/barra_cacahuate.png";

      case "bebida_soya":
        return "assets/images/bebida_soya.png";

      case "crema_avellana":
        return "assets/images/crema_avellana.png";

      case "crema_cacahuate":
        return "assets/images/crema_cacahuate.png";

      case "croquetas_pescado":
        return "assets/images/croquetas_pescado.png";

      case "filete_tilapia_sin_gluten":
        return "assets/images/filete_tilapia_sin_gluten.png";

      case "galletas_cacahuate":
        return "assets/images/galletas_cacahuate.png";

      case "galletas_libres_huevo":
        return "assets/images/galletas_libres_huevo.png";

      case "hamburguesa_soya":
        return "assets/images/hamburguesa_soya.png";

      case "harina-pescado":
        return "assets/images/harina_pescado.png";

      case "helado_vainilla":
        return "assets/images/helado_vainilla.png";

      case "leche_almendra":
        return "assets/images/leche_almendra.png";

      case "mayonesa_vegana_libre_huevo":
        return "assets/images/mayonesa_vegana_libre_huevo.png";

      case "mezcla_panqueques_sin_gluten":
        return "assets/images/mezcla_panqueques_sin_gluten.png";

      case "pan_blanco_sin_gluten":
        return "assets/images/pan_blanco_sin_gluten.png";

      case "pan_integral_libre_huevo":
        return "assets/images/pan_integral_libre_huevo.png";

      case "pasta_arroz_sin_gluten":
        return "assets/images/pasta_arroz_sin_gluten.png";

      case "queso_cheddar":
        return "assets/images/queso_cheddar.png";

      case "salsa_ostion":
        return "assets/images/salsa_ostion.png";

      case "salsa_soya":
        return "assets/images/salsa_soya.png";

      case "sopa_instantanea":
        return "assets/images/sopa_instantanea.png";

      case "yogurt":
        return "assets/images/yogurt.png";

      default:
        return "assets/images/default.png";
    }
  }
}
