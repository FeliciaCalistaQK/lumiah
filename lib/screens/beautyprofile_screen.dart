import 'package:flutter/material.dart';

class BeautyProfileScreen extends StatefulWidget {
  const BeautyProfileScreen({super.key});

  @override
  State<BeautyProfileScreen> createState() => _BeautyProfileScreenState();
}

class _BeautyProfileScreenState extends State<BeautyProfileScreen> {
  String? selectedSkinType;

  final List<Map<String, String>> skinTypes = [
    {
      'label': 'Dry Skin',
      'image': 'images/dryskin.jpg',
      'info': 'Kulit wajah kering umumnya terjadi akibat rendahnya tingkat kelembapan pada lapisan kulit terluar. Hal ini mengakibatkan kulit kering mudah pecah-pecah dan mengalami keretakan pada permukaan kulit. Pemilik kulit wajah kering biasanya memiliki pori-pori kulit yang hampir tak terlihat, permukaan luar kulit terlihat kasar dan kusam, serta kulit kurang elastis. Jenis kulit ini juga lebih mudah memerah, gatal, bersisik, dan meradang.'
    },
    {
      
      'label': 'Normal Skin',
      'image': 'images/normalskin.jpg',
      'info': 'Jenis kulit ini cenderung memiliki keseimbangan antara jumlah kandungan air dan minyak, sehingga tidak terlalu kering tapi juga tidak terlalu berminyak. Jenis kulit wajah seperti ini biasanya jarang memiliki masalah kulit, tidak terlalu sensitif, terlihat bercahaya, dan pori-pori pun hampir tak terlihat. Jenis kulit normal juga lebih mudah dirawat.'
    },
    {
      'label': 'Combination',
      'image': 'images/combination.jpg',
      'info': 'Jenis kulit wajah kombinasi adalah perpaduan antara kulit berminyak dan kulit kering. Seseorang dengan jenis kulit wajah ini memiliki kulit berminyak di zona T, yaitu area dagu, hidung, dan dahi, serta kulit kering di area pipi. Jenis kulit wajah ini dapat dipengaruhi oleh faktor genetik dan peningkatan hormon selama masa pubertas.',
    },
    {
      'label': 'Oily Skin',
      'image': 'images/oilyskin.jpg',
      'info': 'Jenis kulit sensitif umumnya sangat peka dan mudah sekali mengalami alergi atau iritasi dan ruam sebagai reaksi terhadap faktor tertentu, seperti lingkungan, makanan, atau penggunaan produk kosmetik. Kulit wajah sensitif mudah terkelupas, gatal, kering, kemerahan, dan terasa perih (breakout) ketika terjadi kontak dengan berbagai hal yang dapat memicu munculnya gejala kulit sensitif.',
    },
  ];

  void _showInfoDialog(String info) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Info'),
        content: Text(info),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _saveSelection() {
    if (selectedSkinType != null) {
      // Save the selection or pass it back
      Navigator.of(context).pop(selectedSkinType);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silakan pilih jenis kulit')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SkinMatch',
          style: TextStyle(
            color: Colors.pink,
            fontFamily: 'FleurDeLeah',
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lengkapi Profile Kecantikanmu\nuntuk mendapatkan rekomendasi produk',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: skinTypes.length,
                itemBuilder: (context, index) {
                  final skin = skinTypes[index];
                  final isSelected = selectedSkinType == skin['label'];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? Colors.pink : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          skin['image']!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        skin['label']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.help_outline, color: Colors.grey),
                            onPressed: () => _showInfoDialog(skin['info']!),
                          ),
                          Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedSkinType = skin['label'];
                                } else {
                                  selectedSkinType = null;
                                }
                              });
                            },
                            activeColor: Colors.pink,
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          selectedSkinType = skin['label'];
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSelection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Simpan',
                  style: TextStyle(
                    fontFamily: 'FleurDeLeah',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


   