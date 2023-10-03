enum Topics {
  all(('Все', 'assets/icons/book-open.svg')),
  love(('О любви', 'assets/icons/heart.svg')),
  urban(('О городах', 'assets/icons/urban.svg')), 
  philosophy(('Философия', 'assets/icons/globe.svg')), 
  civil(('Гражданская лирика', 'assets/icons/glasses.svg')),
  landscape(('О природе', 'assets/icons/sun.svg')),
  favorite(('Избранные', 'assets/icons/medal.svg'));

  const Topics(this.nameAndLocation);
  final (String, String) nameAndLocation;
}


