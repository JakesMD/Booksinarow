/// A exception thrown when an OTP verification fails.
enum BRawOTPVerificationException {
  /// Indicates that the provided OTP token is not valid.
  invalidToken,

  /// Indicates the cause in unknown.
  unknown,
}
