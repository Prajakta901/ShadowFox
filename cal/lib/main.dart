import 'package:flutter/material.dart';

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  String fun(String num) {
    return num.isEmpty ? '0' : num;
  }

  bool _isOperator(String value) {
    return value == '+' || value == '-' || value == '*' || value == '/';
  }

  String _formatResult(double value) {
    if (value.isNaN || value.isInfinite) {
      return 'Error';
    }

    final String text = value.toString();
    if (text.endsWith('.0')) {
      return text.substring(0, text.length - 2);
    }

    return text;
  }

  void _showErrorSnackBar() {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(content: Text('Invalid calculation')),
    );
  }

  String _cal(String expression) {
    final String cln = expression.replaceAll(' ', '');
    if (cln.isEmpty) {
      return '0';
    }

    final List<String> tokens = [];
           final StringBuffer num = StringBuffer();
    int balance = 0;

    for (int idx = 0; idx < cln.length; idx++) {
      final String char = cln[idx];

      if (char == '(') {
        balance++;
        continue;
      }

      if (char == ')') {
        balance--;
        if (balance < 0) {
          return 'Error';
        }
        continue;
           }

      if (_isOperator(char)) {
        if (num.isNotEmpty) {
          tokens.add(num.toString());
          num.clear();
        }

        if (tokens.isEmpty && char == '-') {
          num.write(char);
        } else {
          tokens.add(char);
        }
      } else {
        num.write(char);
      }
    }

    if (balance != 0) {
      return 'Error';
    }

           if (num.isNotEmpty) {
      tokens.add(num.toString());
    }

    if (tokens.length == 1) {
      return double.tryParse(tokens[0]) == null ? 'Error' : expression;
    }

    if (tokens.length.isEven || _isOperator(tokens.last)) {
      return 'Error';
    }

    for (int idx = 0; idx < tokens.length; idx++) {
      final String token = tokens[idx];
      final bool shouldBeOperator = idx.isOdd;

           if (shouldBeOperator) {
        if (!_isOperator(token)) {
          return 'Error';
        }
      } else {
        if (_isOperator(token) || double.tryParse(token) == null) {
          return 'Error';
        }


      }


    }

    double res = double.tryParse(tokens[0]) ?? 0;

    for (int idx = 1; idx < tokens.length - 1; idx += 2) {
      final String operator = tokens[idx];
      final double right = double.tryParse(tokens[idx + 1]) ?? 0;

      switch (operator) {
        case '+':
          res += right;
          break;


        case '-':
          res -= right;
          break;
        case '*':
          res *= right;
          break;
        case '/':
          if (right == 0) {
            return 'Error';
          }
          res /= right;
          break;
      }
    }

    return _formatResult(res);
  }

  String press = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 241, 239, 239),
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 193, 198, 184),
          title: const Text(
            'Calculator',
            style: TextStyle(
              fontSize: 50,
              color: Color.fromARGB(255, 63, 37, 14),
            ),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
             return Column(
                children: [
             SingleChildScrollView(
                scrollDirection: Axis.vertical,
                    controller: ScrollController(
                      initialScrollOffset: BorderSide.strokeAlignOutside,
                    ),
                    child: Container(
                   alignment: Alignment.centerRight,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
               height: constraints.maxHeight * 0.25,
                      width: double.infinity,
                 color: const Color.fromARGB(255, 241, 239, 239),
                           child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                                   child: Text(
                          fun(press),
                                 maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.only(top: 29, left: 10, right: 10),
                         crossAxisCount: 4,
                      crossAxisSpacing: 5,
                               mainAxisSpacing: 5,
                      children: ele.map((e) => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                backgroundColor:
                                    const Color.fromARGB(255, 51, 32, 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                if (e == 'C') {
                                  setState(() {
                                    press = '';
                                  });
                                  return;
                                } else if (e == 'D') {
                                  setState(() {
                                    if (press.isNotEmpty) {
                                      press = press.substring(
                                        0,press.length - 1,
                                      );
                                    }
                                  });
                                  return;
                                }
                                if (e == '=') {
                                  final String answer = _cal(press);
                                  if (answer == 'Error') {
                                    _showErrorSnackBar();
                                  }

                                  setState(() {
                                    press = answer;
                                  });
                                  return;
                                }

                                setState(() {
                                  if (press == 'Error') {
                                    press = '';
                                  }

                                  if (press.isEmpty &&
                                      _isOperator(e) &&
                                      e != '-') {
                                    return;
                                  }

                                  if (press.isNotEmpty &&
                                      _isOperator(press[press.length - 1]) &&
                                      _isOperator(e)) {
                                    press =
                                        press.substring(0, press.length - 1) +
                                        e;
                                  } else {
                                    press += e;
                                  }
                                });

                                if (e == '(' || e == ')') {
                                  setState(() {
                                    press += '';
                                  });
                                }
                              },
                              child: Center(
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Color.fromARGB(255, 205, 211, 187),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

List<String> ele = [
  '(', ')', 'C',
  'D', '1', '2', '3',
  '+',
  '4', '5', '6',
  '-', '7', '8', '9',
  '/', '0', '.',
  '=', '*',
];