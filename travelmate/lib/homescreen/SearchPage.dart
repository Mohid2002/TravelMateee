import 'package:flutter/material.dart';
import 'package:travelmate/homescreen/place_detailed_home_Screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Map<String, dynamic>> places = [
  {
    "title": "Badshahi Mosque",
    "location": "Lahore, Pakistan",
    "lat": 31.5880,
    "lon": 74.3109,
    "image": "assets/badshai.png",
    "history":
        "Built in 1673 by Emperor Aurangzeb, Badshahi Mosque stands as a crown jewel of Mughal architecture. "
        "It once served as the largest mosque in the world. "
        "Its red sandstone structure and marble domes reflect Islamic artistry. "
        "The mosque endured invasions but remains beautifully preserved. "
        "It’s now one of Lahore’s most iconic landmarks."
  },
  {
    "title": "Lahore Fort",
    "location": "Lahore, Pakistan",
    "lat": 31.5889,
    "lon": 74.3106,
    "image": "assets/Lahore_Fort.png",
    "history":
        "Lahore Fort, also known as Shahi Qila, was rebuilt by Emperor Akbar in the 16th century. "
        "It served as a royal residence for Mughal emperors. "
        "Within its walls lie gems like Sheesh Mahal and Naulakha Pavilion. "
        "The fort tells stories of Mughal glory and colonial struggles. "
        "It is now a UNESCO World Heritage Site."
  },
  {
    "title": "Shalimar Gardens",
    "location": "Lahore, Pakistan",
    "lat": 31.5844,
    "lon": 74.3805,
    "image": "assets/shalimar.png",
    "history":
        "Commissioned by Shah Jahan in 1641, Shalimar Gardens exemplify Mughal landscape design. "
        "Three terraces symbolize heaven, earth, and humanity. "
        "Its 410 fountains and marble pavilions create serene harmony. "
        "The gardens were a royal retreat for emperors. "
        "Today, they are a peaceful escape for locals and tourists alike."
  },
  {
    "title": "Wazir Khan Mosque",
    "location": "Lahore, Pakistan",
    "lat": 31.5821,
    "lon": 74.3166,
    "image": "assets/wazir_khan.png",
    "history":
        "Built in 1634 during Shah Jahan’s reign, the Wazir Khan Mosque is famed for its intricate tile work. "
        "Every wall is covered with Persian-style frescoes and mosaics. "
        "It was named after the governor, Ilm-ud-Din Ansari (Wazir Khan). "
        "The mosque served as both a religious and cultural hub. "
        "It stands as Lahore’s most artistically detailed mosque."
  },
  {
    "title": "Sheesh Mahal",
    "location": "Lahore, Pakistan",
    "lat": 31.5892,
    "lon": 74.3105,
    "image": "assets/sheeshmahal.png",
    "history":
        "Sheesh Mahal, the 'Palace of Mirrors', was built by Shah Jahan in 1631. "
        "Its walls are inlaid with thousands of small mirrors. "
        "Light reflections create a breathtaking glittering effect. "
        "It was designed for royal gatherings and private ceremonies. "
        "The palace remains a symbol of Mughal luxury and creativity."
  },
  {
    "title": "Minar-e-Pakistan",
    "location": "Lahore, Pakistan",
    "lat": 31.5925,
    "lon": 74.3095,
    "image": "assets/Minar-e-Pakistan.png",
    "history":
        "Minar-e-Pakistan marks the historic Lahore Resolution of 1940. "
        "The monument was constructed between 1960 and 1968. "
        "It symbolizes unity, freedom, and the creation of Pakistan. "
        "Architect Nasreddin Murat-Khan blended Mughal and modern design. "
        "It’s a proud national symbol visited by millions annually."
  },
  {
    "title": "Data Darbar",
    "location": "Lahore, Pakistan",
    "lat": 31.5837,
    "lon": 74.3230,
    "image": "assets/datadarbar.png",
    "history":
        "Data Darbar houses the shrine of the Sufi saint Hazrat Ali Hujwiri, also known as Data Ganj Bakhsh. "
        "Built over a thousand years ago, it’s one of South Asia’s oldest Muslim shrines. "
        "Millions visit to pay homage each year. "
        "It reflects the spiritual heart of Lahore. "
        "The shrine’s white marble and domes radiate tranquility."
  },
  {
    "title": "Faisal Mosque",
    "location": "Islamabad, Pakistan",
    "lat": 33.7294,
    "lon": 73.0379,
    "image": "assets/faisal_mosque.png",
    "history":
        "Faisal Mosque, completed in 1986, is Pakistan’s largest mosque. "
        "Designed by Turkish architect Vedat Dalokay, it features a desert-tent-inspired design. "
        "Funded by King Faisal of Saudi Arabia, it symbolizes Pak-Saudi friendship. "
        "It overlooks the Margalla Hills in stunning symmetry. "
        "Its minimalist yet monumental structure attracts global admiration."
  },
  {
    "title": "Lok Virsa Museum",
    "location": "Islamabad, Pakistan",
    "lat": 33.6844,
    "lon": 73.0496,
    "image": "assets/LokVirsaMuseum.png",
    "history":
        "Lok Virsa Museum showcases Pakistan’s diverse cultural heritage. "
        "It displays crafts, traditions, and folk art from all provinces. "
        "Established in 1982, it celebrates unity in diversity. "
        "Visitors experience the lifestyle of various ethnic communities. "
        "It’s a living tribute to Pakistan’s rich folk history."
  },
  {
    "title": "Saidpur Village",
    "location": "Islamabad, Pakistan",
    "lat": 33.7476,
    "lon": 73.0821,
    "image": "assets/SaidpurVillage.png",
    "history":
        "Saidpur Village dates back over 500 years, originally a Hindu village. "
        "It was later renovated into a heritage site. "
        "The area retains ancient temples and Mughal-era architecture. "
        "Now, it blends old charm with modern cafes and art. "
        "It’s a must-visit for those seeking culture and history in one spot."
  },
  {
    "title": "Margalla Hills",
    "location": "Islamabad, Pakistan",
    "lat": 33.7480,
    "lon": 73.0700,
    "image": "assets/Margalla Hills.png",
    "history":
        "The Margalla Hills are part of the Himalayan foothills. "
        "They cradle Islamabad in lush greenery and scenic trails. "
        "The range hosts diverse wildlife and historical caves. "
        "Locals and tourists hike here for breathtaking views. "
        "It’s a sanctuary of peace and natural beauty."
  },
  {
    "title": "Rawal Lake",
    "location": "Islamabad, Pakistan",
    "lat": 33.6844,
    "lon": 73.1245,
    "image": "assets/Rawal Lake.png",
    "history":
        "Rawal Lake is an artificial reservoir supplying water to Islamabad and Rawalpindi. "
        "Surrounded by the Margalla Hills, it offers serene picnic spots. "
        "Built in 1962, it has become a favorite recreational site. "
        "Boating and fishing are popular activities here. "
        "The sunset view from the lake is simply magical."
  },
  {
    "title": "Daman-e-Koh",
    "location": "Islamabad, Pakistan",
    "lat": 33.7489,
    "lon": 73.0467,
    "image": "assets/Daman-e-Koh.png",
    "history":
        "Daman-e-Koh is a viewpoint located in the Margalla Hills. "
        "It offers panoramic views of Islamabad city. "
        "It’s a popular spot for tourists and locals alike. "
        "Wild monkeys and peacocks often add charm to visits. "
        "The area’s calm weather makes it ideal for relaxation."
  },
  {
    "title": "Hunza Valley",
    "location": "Gilgit-Baltistan, Pakistan",
    "lat": 36.3167,
    "lon": 74.6500,
    "image": "assets/hunza.png",
    "history":
        "Hunza Valley is a breathtaking region surrounded by snow-capped peaks. "
        "It was once a princely state on the Silk Route. "
        "The valley is famous for its longevity and peaceful residents. "
        "Karimabad and Baltit Fort reflect its rich past. "
        "Hunza is known as a paradise for nature and photography lovers."
  },
  {
    "title": "Fairy Meadows",
    "location": "Gilgit-Baltistan, Pakistan",
    "lat": 35.4213,
    "lon": 74.5969,
    "image": "assets/feary.png",
    "history":
        "Fairy Meadows is a grassy plateau near Nanga Parbat, the 9th highest mountain. "
        "It’s known for its fairytale-like scenery. "
        "Local legend says fairies dance here under the moonlight. "
        "The area offers mesmerizing views of snow-capped peaks. "
        "It’s one of Pakistan’s top trekking and camping destinations."
  },
  {
    "title": "Skardu",
    "location": "Gilgit-Baltistan, Pakistan",
    "lat": 35.2971,
    "lon": 75.6333,
    "image": "assets/Skardu.png",
    "history":
        "Skardu lies at the heart of Baltistan, surrounded by towering mountains. "
        "It serves as the gateway to K2 and other Himalayan peaks. "
        "The region is rich in Tibetan-inspired culture. "
        "Shangrila Lake and Shigar Fort are its main attractions. "
        "Its stunning landscapes attract trekkers and explorers worldwide."
  },
  {
    "title": "Deosai Plains",
    "location": "Skardu, Pakistan",
    "lat": 35.0300,
    "lon": 75.4400,
    "image": "assets/Deosai Plains.png",
    "history":
        "Known as the 'Land of Giants', Deosai Plains sit at 13,000 feet above sea level. "
        "It’s one of the highest plateaus on Earth. "
        "Home to the Himalayan brown bear, it bursts with wildflowers in summer. "
        "The region transforms into a snow desert in winter. "
        "It’s a hidden gem for adventurers and nature lovers."
  },
  {
    "title": "K2 Base Camp",
    "location": "Skardu, Pakistan",
    "lat": 35.8825,
    "lon": 76.5133,
    "image": "assets/K2 Base Camp.png",
    "history":
        "K2 Base Camp is the starting point for summiting the world's second-highest peak. "
        "It lies deep in the Karakoram Range. "
        "Trekkers journey through glaciers and rugged terrains. "
        "The trail offers surreal views of icy giants. "
        "It’s a challenge and dream for every mountaineer."
  },
  {
    "title": "Naltar Valley",
    "location": "Gilgit, Pakistan",
    "lat": 36.1396,
    "lon": 74.1928,
    "image": "assets/Naltar Valley.png",
    "history":
        "Naltar Valley is known for its crystal lakes and pine forests. "
        "It’s one of the most colorful valleys in the north. "
        "The valley’s serene lakes reflect pure natural beauty. "
        "It’s also home to Pakistan’s first ski resort. "
        "A true paradise for photographers and peace seekers."
  },
  {
    "title": "Khunjerab Pass",
    "location": "Hunza, Pakistan",
    "lat": 36.8500,
    "lon": 75.4300,
    "image": "assets/Khunjerab Pass.png",
    "history":
        "Khunjerab Pass connects Pakistan and China at 15,397 feet altitude. "
        "It’s part of the legendary Karakoram Highway. "
        "The area offers snow, silence, and surreal mountain views. "
        "It represents friendship through the Pak-China border. "
        "Visitors enjoy breathtaking scenery and cool winds year-round."
  },
  {
    "title": "Rakaposhi Base Camp",
    "location": "Nagar, Pakistan",
    "lat": 36.1136,
    "lon": 74.4908,
    "image": "assets/Rakaposhi Base Camp.png",
    "history":
        "Rakaposhi Base Camp offers mesmerizing views of the Rakaposhi Peak. "
        "The trek begins near the village of Minapin. "
        "It’s one of the most accessible base camps in the Karakoram. "
        "Lush meadows and glaciers surround the area. "
        "The site symbolizes serenity amidst the mighty mountains."
  },
  {
    "title": "Swat Valley",
    "location": "KPK, Pakistan",
    "lat": 35.2227,
    "lon": 72.4258,
    "image": "assets/swat.png",
    "history":
        "Swat Valley, often called the 'Switzerland of the East', is rich in natural beauty. "
        "It was once a center of Buddhist civilization. "
        "Lush green hills and turquoise rivers fill the valley. "
        "The region has rebounded as a peaceful tourist haven. "
        "It continues to attract visitors from around the world."
  },
  {
    "title": "Quaid-e-Azam Mausoleum",
    "location": "Karachi, Pakistan",
    "lat": 24.8747,
    "lon": 67.0330,
    "image": "assets/Quaid.png",
    "history":
        "The Quaid-e-Azam Mausoleum is the final resting place of Muhammad Ali Jinnah. "
        "Completed in 1970, it is a symbol of respect and unity. "
        "Its white marble structure shines with simplicity and grace. "
        "Thousands visit daily to honor the founder of Pakistan. "
        "It remains Karachi’s most iconic monument."
  },
];

  List<Map<String, dynamic>> filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    filteredPlaces = places;
  }

  void _filterSearch(String query) {
    setState(() {
      filteredPlaces = places
          .where((place) =>
              place["title"].toLowerCase().contains(query.toLowerCase()) ||
              place["location"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Search Places", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: _filterSearch,
              decoration: const InputDecoration(
                hintText: "Search place or city...",
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPlaces.length,
                itemBuilder: (context, index) {
                  final place = filteredPlaces[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaceDetailScreen(
                              place: {
                                "name": place["title"],
                                "location": place["location"],
                                "imageUrl": place["image"],
                                "history": place["history"],
                                "lat": place["lat"],
                                "lon": place["lon"],
                              },
                            ),
                          ),
                        );
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          place["image"],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(place["title"],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(place["location"]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
