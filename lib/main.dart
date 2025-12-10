import 'dart:io';

void main() {
  // Provided List
  print("Given 6 integers");
  List<int> numbers = [1, 2, 3, 4, 5, 6];

  // Initialization
  int sumOdd = 0;

  // loop condition
  for (int j = 0; j < numbers.length; j++) {
    if (numbers[j] % 2 != 0) {
      sumOdd += numbers[j];
    }
  }

  // Find smallest number using for loop + if
  int smallest = numbers[0]; // assume first number is smallest
  for (int i = 1; i < numbers.length; i++) {
    if (numbers[i] < smallest) {
      smallest = numbers[i];
    }
  }

  // Print results
  print("Numbers entered: ${numbers.join(', ')}");
  print("Sum of odd numbers: $sumOdd");
  print("Smallest number: $smallest");
}
