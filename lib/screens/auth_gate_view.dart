import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/user_view_model.dart';

class AuthGateView extends ConsumerStatefulWidget {
  const AuthGateView({super.key});

  @override
  ConsumerState<AuthGateView> createState() => _AuthGateViewState();
}

class _AuthGateViewState extends ConsumerState<AuthGateView> {
  int step = 1;               // 1 = имя, 2 = пин
  bool isRegister = true;     // режим
  final nameController = TextEditingController();
  final List<int> pin = [];

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _nextStep() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      _showError("Name cannot be empty");
      return;
    }
    setState(() {
      step = 2;
    });
  }

  void _onKeyTap(int number) {
    if (pin.length < 6) {
      setState(() => pin.add(number));
      if (pin.length == 6) _submit();
    }
  }

  void _onDelete() {
    if (pin.isNotEmpty) {
      setState(() => pin.removeLast());
    }
  }

  Future<void> _submit() async {
    final pinString = pin.join();
    final name = nameController.text.trim();

    if (pinString.isEmpty) {
      _showError("PIN cannot be empty");
      return;
    }

    if (isRegister) {
      await ref.read(userProvider.notifier).register(name, pinString);
    } else {
      final ok = await ref.read(userProvider.notifier).login(name, pinString);
      if (!ok) {
        _showError("Wrong PIN");
        setState(() => pin.clear());
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: step == 2
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    step = 1;
                    pin.clear();
                  });
                },
              ),
              title: Text(isRegister ? "Create PIN" : "Enter PIN"),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: step == 1 ? _buildNameStep() : _buildPinStep(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String text, bool active, bool enabled, bool showArrow) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled
            ? (active ? Colors.blue : Colors.grey.shade300)
            : Colors.grey.shade100,
        foregroundColor: enabled
            ? (active ? Colors.white : Colors.black)
            : Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: () {
        final name = nameController.text.trim();
        if (name.isEmpty) {
          // 🔹 просто переключение режима, без Next
          setState(() {
            isRegister = (text == "Register");
            pin.clear();
          });
        } else {
          // 🔹 если имя введено
          if (active) {
            _nextStep(); // перейти к PIN
          } else {
            setState(() {
              isRegister = (text == "Register");
              pin.clear();
            });
          }
        }
      },
      icon: showArrow ? const Icon(Icons.arrow_forward) : const SizedBox.shrink(),
      label: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildNameStep() {
    final name = nameController.text.trim();
    final hasName = name.length > 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 🔹 кнопки выбора
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModeButton("Register", isRegister,
                isRegister && hasName || !hasName, isRegister && hasName),
            const SizedBox(width: 12),
            _buildModeButton("Log in", !isRegister,
                !isRegister && hasName || !hasName, !isRegister && hasName),
          ],
        ),

        const SizedBox(height: 32),
        SizedBox(
          width: 250,
          child: TextField(
            controller: nameController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinStep() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // 🔹 точки пина
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (i) {
            final filled = i < pin.length;
            return Container(
              margin: const EdgeInsets.all(8),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled ? Colors.blue : Colors.grey.shade300,
              ),
            );
          }),
        ),
        const Spacer(),

        // 🔹 прижата вниз клавиатура
        Align(
          alignment: Alignment.bottomCenter,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              if (index == 9) return const SizedBox.shrink();
              if (index == 10) return _buildKey(0);
              if (index == 11) return _buildDelete();
              return _buildKey(index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKey(int number) {
    return GestureDetector(
      onTap: () => _onKeyTap(number),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        child: Text(
          "$number",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDelete() {
    return GestureDetector(
      onTap: _onDelete,
      child: const Icon(Icons.backspace_outlined, size: 28),
    );
  }
}