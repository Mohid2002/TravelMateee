import 'package:flutter/material.dart';
import 'package:travelmate/homescreen/place_detailed_home_Screen.dart';
import 'package:travelmate/homescreen/safe_place_manager.dart';

class ViewAllPage extends StatefulWidget {
  final List<Map<String, dynamic>> destinations;

  const ViewAllPage({super.key, required this.destinations});

  @override
  State<ViewAllPage> createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {
  final manager = SavedPlacesManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Destinations"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.destinations.length,
        itemBuilder: (context, index) {
          final destination = widget.destinations[index];

          // Use "title" consistently for saving & checking
          final title = destination["name"];
          final location = destination["location"];
          final image = destination["imageUrl"];
          final rating = destination["rating"];
          final isSaved = manager.isSaved(title);

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(location),
              trailing: IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? Colors.blueAccent : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    manager.togglePlace({
                      "title": title,
                      "location": location,
                      "image": image,
                      "rating": rating,
                    });
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isSaved
                            ? "$title removed from Saved Places"
                            : "$title added to Saved Places",
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlaceDetailScreen(
                      place: {
                        "name": destination["name"],
                        "imageUrl": destination["imageUrl"],
                        "location": destination["location"],
                        "history": _getPlaceHistory(destination["name"]),
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
String _getPlaceHistory(String name) {
  switch (name) {
    case "Badshahi Mosque":
      return "Built in 1673 by Emperor Aurangzeb, Badshahi Mosque stands as a crown jewel of Mughal architecture. It once served as the largest mosque in the world. Its red sandstone structure and marble domes reflect Islamic artistry. The mosque endured invasions but remains beautifully preserved. It’s now one of Lahore’s most iconic landmarks.";
    case "Lahore Fort":
      return "Lahore Fort, also known as Shahi Qila, was rebuilt by Emperor Akbar in the 16th century. It served as a royal residence for Mughal emperors. Within its walls lie gems like Sheesh Mahal and Naulakha Pavilion. The fort tells stories of Mughal glory and colonial struggles. It is now a UNESCO World Heritage Site.";
    case "Shalimar Gardens":
      return "Commissioned by Shah Jahan in 1641, Shalimar Gardens exemplify Mughal landscape design. Three terraces symbolize heaven, earth, and humanity. Its 410 fountains and marble pavilions create serene harmony. The gardens were a royal retreat for emperors. Today, they are a peaceful escape for locals and tourists alike.";
    case "Wazir Khan Mosque":
      return "Built in 1634 during Shah Jahan’s reign, the Wazir Khan Mosque is famed for its intricate tile work. Every wall is covered with Persian-style frescoes and mosaics. It was named after the governor, Ilm-ud-Din Ansari (Wazir Khan). The mosque served as both a religious and cultural hub. It stands as Lahore’s most artistically detailed mosque.";
    case "Sheesh Mahal":
      return "Sheesh Mahal, the 'Palace of Mirrors', was built by Shah Jahan in 1631. Its walls are inlaid with thousands of small mirrors. Light reflections create a breathtaking glittering effect. It was designed for royal gatherings and private ceremonies. The palace remains a symbol of Mughal luxury and creativity.";
    case "Minar-e-Pakistan":
      return "Minar-e-Pakistan marks the historic Lahore Resolution of 1940. The monument was constructed between 1960 and 1968. It symbolizes unity, freedom, and the creation of Pakistan. Architect Nasreddin Murat-Khan blended Mughal and modern design. It’s a proud national symbol visited by millions annually.";
    case "Data Darbar":
      return "Data Darbar houses the shrine of the Sufi saint Hazrat Ali Hujwiri, also known as Data Ganj Bakhsh. Built over a thousand years ago, it’s one of South Asia’s oldest Muslim shrines. Millions visit to pay homage each year. It reflects the spiritual heart of Lahore. The shrine’s white marble and domes radiate tranquility.";
    case "Faisal Mosque":
      return "Faisal Mosque, completed in 1986, is Pakistan’s largest mosque. Designed by Turkish architect Vedat Dalokay, it features a desert-tent-inspired design. Funded by King Faisal of Saudi Arabia, it symbolizes Pak-Saudi friendship. It overlooks the Margalla Hills in stunning symmetry. Its minimalist yet monumental structure attracts global admiration.";
    case "Lok Virsa Museum":
      return "Lok Virsa Museum showcases Pakistan’s diverse cultural heritage. It displays crafts, traditions, and folk art from all provinces. Established in 1982, it celebrates unity in diversity. Visitors experience the lifestyle of various ethnic communities. It’s a living tribute to Pakistan’s rich folk history.";
    case "Saidpur Village":
      return "Saidpur Village dates back over 500 years, originally a Hindu village. It was later renovated into a heritage site. The area retains ancient temples and Mughal-era architecture. Now, it blends old charm with modern cafes and art. It’s a must-visit for those seeking culture and history in one spot.";
    case "Margalla Hills":
      return "The Margalla Hills are part of the Himalayan foothills. They cradle Islamabad in lush greenery and scenic trails. The range hosts diverse wildlife and historical caves. Locals and tourists hike here for breathtaking views. It’s a sanctuary of peace and natural beauty.";
    case "Rawal Lake":
      return "Rawal Lake is an artificial reservoir supplying water to Islamabad and Rawalpindi. Surrounded by the Margalla Hills, it offers serene picnic spots. Built in 1962, it has become a favorite recreational site. Boating and fishing are popular activities here. The sunset view from the lake is simply magical.";
    case "Daman-e-Koh":
      return "Daman-e-Koh is a viewpoint located in the Margalla Hills. It offers panoramic views of Islamabad city. It’s a popular spot for tourists and locals alike. Wild monkeys and peacocks often add charm to visits. The area’s calm weather makes it ideal for relaxation.";
    case "Hunza Valley":
      return "Hunza Valley is a breathtaking region surrounded by snow-capped peaks. It was once a princely state on the Silk Route. The valley is famous for its longevity and peaceful residents. Karimabad and Baltit Fort reflect its rich past. Hunza is known as a paradise for nature and photography lovers.";
    case "Fairy Meadows":
      return "Fairy Meadows is a grassy plateau near Nanga Parbat, the 9th highest mountain. It’s known for its fairytale-like scenery. Local legend says fairies dance here under the moonlight. The area offers mesmerizing views of snow-capped peaks. It’s one of Pakistan’s top trekking and camping destinations.";
    case "Skardu":
      return "Skardu lies at the heart of Baltistan, surrounded by towering mountains. It serves as the gateway to K2 and other Himalayan peaks. The region is rich in Tibetan-inspired culture. Shangrila Lake and Shigar Fort are its main attractions. Its stunning landscapes attract trekkers and explorers worldwide.";
    case "Deosai Plains":
      return "Known as the 'Land of Giants', Deosai Plains sit at 13,000 feet above sea level. It’s one of the highest plateaus on Earth. Home to the Himalayan brown bear, it bursts with wildflowers in summer. The region transforms into a snow desert in winter. It’s a hidden gem for adventurers and nature lovers.";
    case "K2 Base Camp":
      return "K2 Base Camp is the starting point for summiting the world's second-highest peak. It lies deep in the Karakoram Range. Trekkers journey through glaciers and rugged terrains. The trail offers surreal views of icy giants. It’s a challenge and dream for every mountaineer.";
    case "Naltar Valley":
      return "Naltar Valley is known for its crystal lakes and pine forests. It’s one of the most colorful valleys in the north. The valley’s serene lakes reflect pure natural beauty. It’s also home to Pakistan’s first ski resort. A true paradise for photographers and peace seekers.";
    case "Khunjerab Pass":
      return "Khunjerab Pass connects Pakistan and China at 15,397 feet altitude. It’s part of the legendary Karakoram Highway. The area offers snow, silence, and surreal mountain views. It represents friendship through the Pak-China border. Visitors enjoy breathtaking scenery and cool winds year-round.";
    case "Rakaposhi Base Camp":
      return "Rakaposhi Base Camp offers mesmerizing views of the Rakaposhi Peak. The trek begins near the village of Minapin. It’s one of the most accessible base camps in the Karakoram. Lush meadows and glaciers surround the area. The site symbolizes serenity amidst the mighty mountains.";
    case "Swat Valley":
      return "Swat Valley, often called the 'Switzerland of the East', is rich in natural beauty. It was once a center of Buddhist civilization. Lush green hills and turquoise rivers fill the valley. The region has rebounded as a peaceful tourist haven. It continues to attract visitors from around the world.";
    case "Quaid-e-Azam Mausoleum":
      return "The Quaid-e-Azam Mausoleum is the final resting place of Muhammad Ali Jinnah. Completed in 1970, it is a symbol of respect and unity. Its white marble structure shines with simplicity and grace. Thousands visit daily to honor the founder of Pakistan. It remains Karachi’s most iconic monument.";
    default:
      return "This location holds cultural and historical significance, representing the beauty and heritage of Pakistan.";
  }
}