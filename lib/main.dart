import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: HaliHesapla(), debugShowCheckedModeBanner: false));

class HaliHesapla extends StatefulWidget {
  const HaliHesapla({super.key});
  @override
  State<HaliHesapla> createState() => _HaliHesaplaState();
}

class _HaliHesaplaState extends State<HaliHesapla> {
  final en = TextEditingController();
  final boy = TextEditingController();
  final adet = TextEditingController(text: '1');
  final fiyat = TextEditingController();
  final List<Map<String, dynamic>> liste = [];

  void ekle() {
    final e = double.tryParse(en.text.replaceAll(',', '.')) ?? 0;
    final b = double.tryParse(boy.text.replaceAll(',', '.')) ?? 0;
    final a = int.tryParse(adet.text) ?? 1;
    final f = double.tryParse(fiyat.text.replaceAll(',', '.')) ?? 0;
    if (e <= 0 || b <= 0 || f <= 0) return;

    final m2 = (e * b) / 10000;
    setState(() {
      liste.insert(0, {'en': e, 'boy': b, 'adet': a, 'fiyat': f, 'm2': m2 * a, 'tutar': m2 * a * f});
    });
    en.clear(); boy.clear(); adet.text = '1';
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    double topM2 = liste.fold(0, (sum, i) => sum + i['m2']);
    double topTutar = liste.fold(0, (sum, i) => sum + i['tutar']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halı Metrekare & Fiyat'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          if (liste.isNotEmpty)
            IconButton(icon: const Icon(Icons.delete_sweep), onPressed: () => setState(() => liste.clear())),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: TextField(controller: en, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'En (cm)', border: OutlineInputBorder()))),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(controller: boy, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Boy (cm)', border: OutlineInputBorder()))),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: TextField(controller: adet, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Adet', border: OutlineInputBorder()))),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(controller: fiyat, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'm² Fiyatı (₺)', border: OutlineInputBorder()))),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                    onPressed: ekle,
                    child: const Text('Listeye Ekle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: liste.length,
              itemBuilder: (ctx, i) {
                final item = liste[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    title: Text('${item['en'].toInt()} × ${item['boy'].toInt()} cm (${item['adet']} Adet)', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Alan: ${item['m2'].toStringAsFixed(2)} m² | Birim: ${item['fiyat']} ₺'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${item['tutar'].toStringAsFixed(2)} ₺', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => liste.removeAt(i))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Toplam: ${topM2.toStringAsFixed(2)} m²', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${topTutar.toStringAsFixed(2)} ₺', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal.shade900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
