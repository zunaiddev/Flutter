import 'package:flutter/material.dart';

class MaterialHomePage extends StatefulWidget {
  const MaterialHomePage({super.key});

  @override
  State<MaterialHomePage> createState() {
    return _MaterialHomePageState();
  }
}

class _MaterialHomePageState extends State<MaterialHomePage> {
  final TextEditingController controller = TextEditingController();
  double result = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void calculate() {
    setState(() {
      result = double.parse(controller.text) * 80;
    });
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(width: 1.8, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    );

    return Scaffold(
      backgroundColor: const Color.fromRGBO(13, 27, 42, 1),
      appBar: AppBar(
        title: const Text(
          "Currency Converter",
          style: TextStyle(
            color: Color(0xFFe0e1dd),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0d1b2a),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Converted: ${result.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: controller,
                onSubmitted: (_) => calculate(),
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Please Enter Amount in INR",
                  hintStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  prefixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: border,
                  focusedBorder: border,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextButton(
                onPressed: calculate,
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xFF415a77)),
                  minimumSize: WidgetStatePropertyAll(
                    Size(double.infinity, 50),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),

                child: const Text(
                  "Convert",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
