import 'dart:convert';

/// Helper class for string operations, especially for database constraints
class StringHelper {
  /// Truncate string to fit VARCHAR(255) with UTF-8 encoding
  /// 
  /// MySQL VARCHAR(255) means 255 characters, but UTF-8 Vietnamese characters
  /// can take 3-4 bytes each. To be safe, we limit to a smaller character count.
  /// 
  /// For Vietnamese text:
  /// - Safe limit: ~200 characters (to account for multibyte chars)
  /// - This ensures the byte length stays well under 255 bytes
  /// 
  /// Example:
  /// ```dart
  /// final text = "Very long Vietnamese text...";
  /// final safe = StringHelper.truncateForVarchar255(text);
  /// ```
  static String truncateForVarchar255(String text, {int maxChars = 200}) {
    if (text.isEmpty) return text;
    
    // Check character count first
    if (text.length <= maxChars) {
      // Double-check byte length for safety
      final bytes = utf8.encode(text);
      if (bytes.length <= 255) {
        return text;
      }
    }
    
    // Truncate by characters first
    String truncated = text.substring(0, maxChars.clamp(0, text.length));
    
    // Check if byte length is still too long
    var bytes = utf8.encode(truncated);
    
    // If still too long, reduce further
    while (bytes.length > 255 && truncated.isNotEmpty) {
      // Remove 10 characters at a time for efficiency
      final reduceBy = (truncated.length * 0.1).ceil().clamp(1, 10);
      truncated = truncated.substring(0, truncated.length - reduceBy);
      bytes = utf8.encode(truncated);
    }
    
    // Add ellipsis if truncated
    if (truncated.length < text.length) {
      // Make sure we have room for "..."
      if (truncated.length > 3) {
        truncated = truncated.substring(0, truncated.length - 3);
      }
      truncated += '...';
      
      // Final check
      bytes = utf8.encode(truncated);
      if (bytes.length > 255) {
        // Edge case: remove more
        truncated = '${truncated.substring(0, truncated.length - 10)}...';
      }
    }
    
    return truncated;
  }
  
  /// Get byte length of a string in UTF-8 encoding
  static int getByteLength(String text) {
    return utf8.encode(text).length;
  }
  
  /// Check if string fits in VARCHAR(255)
  static bool fitsInVarchar255(String text) {
    return getByteLength(text) <= 255;
  }
}
