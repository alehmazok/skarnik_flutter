import 'package:equatable/equatable.dart';

import 'dictionary.dart';

class Word extends Equatable {
  final int langId;

  final String letter;

  final int wordId;

  final String word;

  final String lword;

  final String? lwordMask;

  final Dictionary dictionary;

  @override
  List<Object?> get props => [
        wordId,
        langId,
      ];

  const Word({
    required this.langId,
    required this.letter,
    required this.wordId,
    required this.word,
    required this.lword,
    required this.dictionary,
    this.lwordMask,
  });

  @override
  String toString() => 'Word($langId, $letter, $wordId, $word, $lword, $lwordMask)';
}
