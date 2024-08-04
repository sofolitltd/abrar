String slugGenerator(String input) {
  // Convert to lowercase
  String lowercaseInput = input.toLowerCase();

  // Replace spaces with hyphens
  String hyphenated = lowercaseInput.replaceAll(' ', '-');

  //Remove non-alphanumeric characters except hyphens
  String slug = hyphenated.replaceAll(RegExp(r'[^a-z0-9-]'), '');

  return slug;
}
