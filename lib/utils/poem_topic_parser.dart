

import 'package:nevesomiy/domain/entites/ettities.dart';

mixin PoemParser {
  static (String, String) byTopicId(String poemId) {
    var parsedKey = poemId.replaceAll(RegExp('[0-9]'), '');
    switch (parsedKey) {
      case 'love':
        return (Topics.love.nameAndLocation);
      case 'urban':
        return (Topics.urban.nameAndLocation);
      case 'philosophy':
        return (Topics.philosophy.nameAndLocation);
      case 'civil':
        return (Topics.civil.nameAndLocation);
      case 'landscape':
        return (Topics.landscape.nameAndLocation);                     
     default:
        return ('', '');   
    }
  }
  
  static String byBreakContent(String content) {
    return content.replaceAllMapped(RegExp(r'[А-Я]'), (match) {
      return '\n${match.group(0)}';
    });
  }  

  static String byPreviewContent(String content) {
    int previewContentLength = byBreakContent(content).split('\n').sublist(0, 3).join('\n').length;
    return byBreakContent(content).split('\n').sublist(0, 3).join('\n').
    replaceRange(previewContentLength - 1, previewContentLength, '...');
  }   
}


