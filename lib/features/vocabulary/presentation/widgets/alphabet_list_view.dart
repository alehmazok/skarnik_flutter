import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skarnik_flutter/features/app/domain/entity/skarnik_word_ext.dart';
import 'package:skarnik_flutter/features/app/domain/entity/word.dart';
import 'package:vibration/vibration.dart';

class SimpleListView extends StatefulWidget {
  static const rusBelAlphabet = [
    'А',
    'Б',
    'В',
    'Г',
    'Д',
    'Е',
    'Ё',
    'Ж',
    'З',
    'И',
    'Й',
    'К',
    'Л',
    'М',
    'Н',
    'О',
    'П',
    'Р',
    'С',
    'Т',
    'У',
    'Ф',
    'Х',
    'Ц',
    'Ч',
    'Ш',
    'Щ',
    'Э',
    'Ю',
    'Я',
  ];
  static const belRusAlphabet = [
    'А',
    'Б',
    'В',
    'Г',
    'Д',
    'Е',
    'Ё',
    'Ж',
    'З',
    'І',
    'Й',
    'К',
    'Л',
    'М',
    'Н',
    'О',
    'П',
    'Р',
    'С',
    'Т',
    'У',
    'Ў',
    'Ф',
    'Х',
    'Ц',
    'Ч',
    'Ш',
    'Э',
    'Ю',
    'Я',
  ];

  static const alphabetsMap = {
    SkarnikWordExt.langIdRusBel: rusBelAlphabet,
    SkarnikWordExt.langIdBelRus: belRusAlphabet,
    SkarnikWordExt.langIdTsbm: belRusAlphabet,
  };

  final int langId;
  final List<Word> words;

  const SimpleListView({
    Key? key,
    required this.langId,
    required this.words,
  }) : super(key: key);

  @override
  State<SimpleListView> createState() => _SimpleListViewState();
}

class _SimpleListViewState extends State<SimpleListView> {
  final _wordScrollController = ItemScrollController();
  final _indexBarDragNotifier = IndexBarDragNotifier();
  late final VoidCallback _indexBarListener;
  bool _hasVibration = false;

  Future<void> _initVibration() async {
    _hasVibration = await Vibration.hasVibrator() ?? false;
  }

  @override
  void initState() {
    super.initState();
    _indexBarListener = () {
      final letter = _indexBarDragNotifier.dragDetails.value.tag;
      if (letter != null) {
        _onLetterPressed(letter);
      }
    };
    _indexBarDragNotifier.dragDetails.addListener(_indexBarListener);
    _initVibration();
  }

  @override
  void dispose() {
    _indexBarDragNotifier.dragDetails.removeListener(_indexBarListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alphabet = SimpleListView.alphabetsMap[widget.langId]!;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 10,
          child: ScrollablePositionedList.builder(
            itemScrollController: _wordScrollController,
            itemBuilder: (context, index) {
              final word = widget.words[index];
              return ListTile(
                title: Text(word.word),
                onTap: () => context.go(
                  '/translate/word',
                  extra: {
                    'word': word,
                    'save_to_history': true,
                  },
                ),
              );
            },
            itemCount: widget.words.length,
          ),
        ),
        SizedBox(
          width: 24,
          child: IndexBar(
            data: alphabet,
            indexBarDragListener: _indexBarDragNotifier,
          ),
        ),
      ],
    );
  }

  void _onLetterPressed(String letter) {
    letter = letter.toLowerCase();
    final index = widget.words.indexWhere((it) => it.letter == letter);
    if (index > 0) {
      _wordScrollController.jumpTo(index: index);
      if (_hasVibration) {
        Vibration.vibrate(duration: 25);
      }
    }
  }
}
