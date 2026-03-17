import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {

  String display = "";
  double n1 = 0;
  String operator = "";

  final List<String> keys = [
    "C", "⌫", "/", "*",
    "7", "8", "9", "-",
    "4", "5", "6", "+",
    "1", "2", "3", "",
    "",  "0", ".", "="
  ];

  int precedence(String op) {
    if (op == "+" || op == "-") return 1;
    if (op == "*" || op == "/") return 2;
    return 0;
  }

  double apply(double a, double b, String op) {
    switch (op) {
      case "+": return a + b;
      case "-": return a - b;
      case "*": return a * b;
      case "/": return a / b;
    }
    return 0;
  }

  double evaluate(String exp) {

    exp = exp.replaceAll(" ", "");

    List<double> nums = [];
    List<String> ops = [];

    for (int i = 0; i < exp.length; i++) {

      String ch = exp[i];

      // Number (including decimals)
      if (RegExp(r'[0-9.]').hasMatch(ch)) {
        String numStr = "";

        while (i < exp.length &&
            RegExp(r'[0-9.]').hasMatch(exp[i])) {

          numStr += exp[i];
          i++;
        }

        i--;
        nums.add(double.parse(numStr));
      }

      // Operator
      else {
        while (ops.isNotEmpty &&
            precedence(ops.last) >= precedence(ch)) {

          double b = nums.removeLast();
          double a = nums.removeLast();
          nums.add(apply(a, b, ops.removeLast()));
        }

        ops.add(ch);
      }
    }

    while (ops.isNotEmpty) {
      double b = nums.removeLast();
      double a = nums.removeLast();
      nums.add(apply(a, b, ops.removeLast()));
    }

    return nums.last;
  }



  // void onButtonPressed(String cmd) {
  //
  //   setState(() {
  //
  //     // Numbers
  //     if (RegExp(r'[0-9.]').hasMatch(cmd)) {
  //       display += cmd;
  //     }
  //
  //     // Clear
  //     else if (cmd == "C") {
  //       display = "";
  //       n1 = 0;
  //       operator = "";
  //     }
  //
  //     // Equals
  //     else if (cmd == "=") {
  //       if (display.isEmpty) return;
  //
  //       double n2 = double.parse(display);
  //       double result = 0;
  //
  //       switch (operator) {
  //         case "+": result = n1 + n2; break;
  //         case "-": result = n1 - n2; break;
  //         case "*": result = n1 * n2; break;
  //         case "/": result = n1 / n2; break;
  //       }
  //
  //       display = result.toString();
  //     }
  //
  //     // Backspace
  //     else if (cmd == "⌫") {
  //       if (display.isNotEmpty) {
  //         display = display.substring(0, display.length - 1);
  //       }
  //
  //       if (display.isEmpty) {
  //         display = "";
  //       }
  //     }
  //
  //
  //     // Operators
  //     else {
  //       if (display.isEmpty) return;
  //
  //       n1 = double.parse(display);
  //       operator = cmd;
  //       display = "";
  //     }
  //   });
  // }


  void onButtonPressed(String cmd) {
    setState(() {

      if (cmd == "C") {
        display = "";
      }

      else if (cmd == "⌫") {
        if (display.isNotEmpty) {
          display = display.substring(0, display.length - 1);
        }
      }

      else if (cmd == "=") {
        try {
          display = evaluate(display).toString();
        } catch (e) {
          display = "Error";
        }
      }

      else {
        display += cmd;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

          // Display
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                display.isEmpty ? "0" : display,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Buttons
          Expanded(
            flex: 5,
            child: GridView.builder(
              itemCount: keys.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {

                if (keys[index] == "") {
                  return Container();
                }

                return GestureDetector(
                  onTap: () => onButtonPressed(keys[index]),
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        keys[index],
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
