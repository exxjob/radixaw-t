import 'dart:math';

const bool duplicateCharactersAllowed = false;
const String illegalCharacters = "";

String radicesConvert(final String input, final String inRadix, final String outRadix){

  RegExp detectDuplicateCharacters = RegExp(r'(.)(?=.*\1)');
  bool uniqueCharacters (String radix)=> !detectDuplicateCharacters.hasMatch(radix);
  String sanitizeDuplicateCharacters (String string)=> string.replaceAll(detectDuplicateCharacters, "");
  bool conforms(String basis, String examine,bool shouldContain){ for(String i in examine.split('')){ if(shouldContain != basis.contains(i)){ return false; } } return true; }

  assert(input.isNotEmpty, "Value to convert must not be empty");
  assert(inRadix.length >= 2 && outRadix.length >= 2, "Radices must be larger");
  assert(inRadix != outRadix, "Can't convert between identical representations");
  assert(duplicateCharactersAllowed || (uniqueCharacters(inRadix) && uniqueCharacters(outRadix)), "Radices must not have duplicate characters");
  assert(illegalCharacters.isEmpty || (conforms(illegalCharacters,(duplicateCharactersAllowed? sanitizeDuplicateCharacters(inRadix):inRadix),false) && conforms(illegalCharacters,(duplicateCharactersAllowed? sanitizeDuplicateCharacters(outRadix):outRadix),false)), "Radices must not include illegal characters");
  assert(conforms(inRadix,sanitizeDuplicateCharacters(input),true),"Input must only include characters from its Radix");


  add (List<int> x, List<int> y, int base){
    List<int> z = <int>[];
    final n = max(x.length, y.length);
    var carry = 0;
    var i = 0;
    while (i < n || carry > 0){
      final xi = i < x.length ? x[i] : 0;
      final yi = i < y.length ? y[i] : 0;
      final zi = carry + xi + yi;
      z.add(zi % base);
      carry = (zi / base).floor();
      i++;
    }
    return z;
  }
  multiplyByNumber (int num, List<int> power, int base){
    if(num==0){ return [0]; }
    List<int> result = <int>[];
    while (true) {
      if(num & 1 > 0) { result = add(result, power, base); }
      num = num >> 1;
      if (num == 0) break;
      power = add(power, power, base);
    }
    return result;
  }
  decodeInput(String input){
    final digits = input.split('');
    List<int> arr = [];
    for (int i = digits.length - 1; i >= 0; i--) {
      final n = inRadix.indexOf(digits[i]);
      arr.add(n);
    }
    return arr;
  }


  final fromBase = inRadix.length;
  final toBase = outRadix.length;
  final digits = decodeInput(input);
  List<int> outArray = <int>[];
  List<int> power = <int>[1];

  for (int i = 0; i < digits.length; i++) {
    outArray = add(outArray, multiplyByNumber(digits[i], power, toBase), toBase);
    power = multiplyByNumber(fromBase, power, toBase);
  }

  String out = '';
  for (int i = outArray.length - 1; i >= 0; i--) { out += outRadix[outArray[i]]; }
  return out;
}
