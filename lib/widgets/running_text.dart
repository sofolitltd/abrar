import 'package:flutter/material.dart';

class RunningText extends StatefulWidget {
  const RunningText({super.key});

  @override
  State<RunningText> createState() => _RunningTextState();
}

class _RunningTextState extends State<RunningText> {
  final ScrollController _scrollController = ScrollController();
  final String _text =
      'Welcome to Abrar Shop. We are open every day except national holidays.';

  //
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  //
  _startScrolling() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double minScroll = _scrollController.position.minScrollExtent;

    //
    _scrollController
        .animateTo(
      maxScroll,
      duration: const Duration(seconds: 16),
      curve: Curves.linear,
    )
        .then((value) {
      _scrollController.jumpTo(minScroll);
      _startScrolling();
    });
  }

  //
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueGrey.withOpacity(.2)),
        color: Colors.blueGrey.withOpacity(.05),
      ),
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width - 24),
          Center(
            child: Text(
              _text,
              style:
                  Theme.of(context).textTheme.titleMedium!.copyWith(height: 1),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width - 24),
        ],
      ),
    );
  }
}
