import 'package:flutter/material.dart';
import '../services/allergen_service.dart';
import '../services/storage_service.dart';
import '../utils/type_fix.dart';

class AllergenModal extends StatefulWidget {
  const AllergenModal({super.key});

  @override
  State<AllergenModal> createState() => _AllergenModalState();
}

class _AllergenModalState extends State<AllergenModal> {
  List allergens = [];
  List<int> selected = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final token = await StorageService.getToken();
    if (token == null) return;

    final data = await AllergenService.getAllergens(token);
    final user = await AllergenService.getUserAllergens(token);

    setState(() {
      allergens = data;
      selected = user;
      loading = false;
    });
  }

  void toggle(int id) {
    setState(() {
      if (selected.contains(id)) {
        selected.remove(id);
      } else {
        selected.add(id);
      }
    });
  }

  Future<void> save() async {
    final token = await StorageService.getToken();
    if (token == null) return;

    await AllergenService.saveUserAllergens(token, selected);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 450,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("Expediente"),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: allergens.length,
                      itemBuilder: (c, i) {
                        final a = allergens[i];

                        final id = toInt(a["id"]); // 🔥 FIX
                        final name = a["name"];

                        return CheckboxListTile(
                          value: selected.contains(id),
                          title: Text(name ?? ""),
                          onChanged: (_) => toggle(id),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: save,
              child: const Text("Guardar"),
            )
          ],
        ),
      ),
    );
  }
}
