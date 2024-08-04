String capitalizeWords(String str) {
  if (str.isEmpty) return str;
  return str.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}
