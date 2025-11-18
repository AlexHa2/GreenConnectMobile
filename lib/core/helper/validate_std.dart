import 'package:phone_numbers_parser/phone_numbers_parser.dart';

String? validateAndFormatToE164(String raw, {IsoCode isoCode = IsoCode.VN}) {
  try {
    final phone = PhoneNumber.parse(raw, destinationCountry: isoCode);

    final isValid = phone.isValid(type: PhoneNumberType.mobile);
    if (!isValid) return null;

    final e164 = phone.international;

    return e164;
  } catch (e) {
    print('Error parsing phone: $e');
    return null;
  }
}
