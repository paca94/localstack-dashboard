abstract class GenerateUtils {
  static String genId() {
    return (DateTime.now().millisecondsSinceEpoch - 1657961863274).toString();
  }
}
