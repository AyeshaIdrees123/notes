import 'dart:math';

class RandomId {
  generateRandomId() {
    final random = Random();
    int randomNumber = 1000 + random.nextInt(9000);
    return randomNumber.toString();
  }
}
