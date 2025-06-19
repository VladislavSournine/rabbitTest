// Function for calculate multiply to 10
int factorial(int n) {
  if (n < 0) {
    throw ArgumentError('Negative numbers are not allowed.');
  }
  if (n == 0 || n == 1) {
    return 1;
  }
  return n * factorial(n - 1);
}
