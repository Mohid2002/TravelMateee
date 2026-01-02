import 'package:flutter/material.dart';
import 'package:travelmate/homescreen/SearchPage.dart';
import 'package:travelmate/homescreen/calander_schedule.dart';
import 'package:travelmate/homescreen/place_detailed_home_Screen.dart';
import 'package:travelmate/homescreen/viwe_all_page.dart';
import 'package:travelmate/loginpage/loginpage.dart';
import 'package:travelmate/model/weather_model.dart';
import 'package:travelmate/service/weather_service.dart'
    show WeatherService; // <-- IMPORTANT

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

IconData _getWeatherIcon(String condition) {
  final c = condition.toLowerCase();

  if (c.contains("rain")) return Icons.umbrella;
  if (c.contains("cloud")) return Icons.cloud;
  if (c.contains("mist") || c.contains("fog")) return Icons.blur_on;
  if (c.contains("snow")) return Icons.ac_unit;
  if (c.contains("clear")) return Icons.wb_sunny;

  return Icons.wb_cloudy;
}

Color _getWeatherColor(String condition) {
  final c = condition.toLowerCase();

  if (c.contains("rain")) return Colors.blue.shade100;
  if (c.contains("cloud")) return Colors.grey.shade200;
  if (c.contains("mist") || c.contains("fog")) return Colors.blueGrey.shade100;
  if (c.contains("clear")) return Colors.orange.shade50;

  return Colors.grey.shade100;
}

bool _isNight() {
  final hour = DateTime.now().hour;
  return hour >= 18 || hour <= 5;
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> destinations = [
  {
    "name": "Badshahi Mosque",
    "location": "Lahore",
    "lat": 31.5880,
    "lon": 74.3109,
    "rating": 4.9,
    "imageUrl": "assets/badshai.png",
    "visitors": 85,
    "history":
        "Built in 1673 by Emperor Aurangzeb, the Badshahi Mosque is a Mughal masterpiece. It is famous for red sandstone and marble architecture. The mosque once served as a military garrison during Sikh and British rule. Facing Lahore Fort, it reflects the Mughal glory. Today, it remains a top tourist and religious site in Pakistan.",
    "history_ur":
        "بادشاہی مسجد 1673 میں مغل بادشاہ اورنگزیب عالمگیر نے تعمیر کروائی۔ یہ سرخ پتھر اور سنگ مرمر کے شاندار فنِ تعمیر کے لیے مشہور ہے۔ سکھ اور برطانوی دور میں اسے فوجی چھاؤنی کے طور پر استعمال کیا گیا۔ یہ لاہور قلعے کے سامنے واقع ہے اور مغل عظمت کی علامت ہے۔ آج یہ پاکستان کی اہم مذہبی اور سیاحتی جگہ ہے۔",
  },
  {
    "name": "Lahore Fort",
    "location": "Lahore",
    "lat": 31.5889,
    "lon": 74.3106,
    "rating": 4.8,
    "imageUrl": "assets/Lahore_Fort.png",
    "visitors": 90,
    "history":
        "Lahore Fort, or Shahi Qila, was rebuilt by Akbar in the 16th century. It features a mix of Islamic, Persian, and Indian art styles. The fort includes Sheesh Mahal and Naulakha Pavilion. Once home to Mughal emperors, it symbolizes Lahore’s royal past. Now, it's a UNESCO World Heritage Site.",
    "history_ur":
        "لاہور قلعہ یا شاہی قلعہ سولہویں صدی میں اکبر اعظم نے دوبارہ تعمیر کروایا۔ اس میں اسلامی، فارسی اور ہندوستانی طرزِ تعمیر کا حسین امتزاج پایا جاتا ہے۔ شیش محل اور نولکھا پویلین اس کے نمایاں حصے ہیں۔ یہ مغل بادشاہوں کی رہائش گاہ رہا اور آج یونیسکو کا عالمی ورثہ ہے۔",
  },
  {
    "name": "Shalimar Gardens",
    "location": "Lahore",
    "lat": 31.5844,
    "lon": 74.3805,
    "rating": 4.7,
    "imageUrl": "assets/shalimar.png",
    "visitors": 70,
    "history":
        "Built by Shah Jahan in 1641, Shalimar Gardens are a Mughal paradise. Inspired by Persian design, the gardens symbolize heaven on earth. They were used for royal leisure and ceremonies. Fountains and terraces add to their charm. Today, it remains a serene tourist attraction.",
    "history_ur":
        "شالیمار باغات 1641 میں شاہ جہاں نے تعمیر کروائے۔ یہ فارسی طرز کے باغات جنت کی علامت سمجھے جاتے ہیں۔ مغل دور میں یہ شاہی تقریبات اور تفریح کے لیے استعمال ہوتے تھے۔ فوارے اور بلند و پست سطحیں ان کی خوبصورتی میں اضافہ کرتی ہیں۔ آج یہ ایک پُرسکون سیاحتی مقام ہے۔",
  },
  {
    "name": "Wazir Khan Mosque",
    "location": "Lahore",
    "lat": 31.5821,
    "lon": 74.3166,
    "rating": 4.6,
    "imageUrl": "assets/wazir_khan.png",
    "visitors": 60,
    "history":
        "Constructed in 1634 under Shah Jahan, Wazir Khan Mosque is a tilework wonder. It was commissioned by Hakim Ilmuddin Ansari, known as Wazir Khan. The mosque’s walls display exquisite Persian calligraphy. It served as a cultural and religious hub in Lahore. Today, it’s a jewel of Mughal art.",
    "history_ur":
        "وزیر خان مسجد 1634 میں شاہ جہاں کے دور میں تعمیر کی گئی۔ اسے حکیم علم الدین انصاری المعروف وزیر خان نے بنوایا۔ مسجد کی دیواروں پر شاندار ٹائل ورک اور فارسی خطاطی موجود ہے۔ یہ لاہور کا ایک اہم مذہبی اور ثقافتی مرکز رہی ہے۔",
  },
  {
    "name": "Sheesh Mahal",
    "location": "Lahore",
    "lat": 31.5892,
    "lon": 74.3105,
    "rating": 4.8,
    "imageUrl": "assets/sheeshmahal.png",
    "visitors": 55,
    "history":
        "Sheesh Mahal, the Palace of Mirrors, was built by Shah Jahan inside Lahore Fort. Its intricate glass mosaics sparkle under light. It served as royal women’s quarters during the Mughal era. Thousands of mirrors create a magical reflection effect. Today, it's a highlight of Lahore Fort.",
    "history_ur":
        "شیش محل کو محلِ آئینہ بھی کہا جاتا ہے جو شاہ جہاں نے لاہور قلعے میں تعمیر کروایا۔ اس کے شیشے روشنی میں جگمگاتے ہیں۔ مغل دور میں یہ شاہی خواتین کی رہائش گاہ تھا۔ ہزاروں آئینے دلکش منظر پیش کرتے ہیں۔",
  },
  {
    "name": "Minar-e-Pakistan",
    "location": "Lahore",
    "lat": 31.5925,
    "lon": 74.3095,
    "rating": 4.5,
    "imageUrl": "assets/Minar-e-Pakistan.png",
    "visitors": 80,
    "history":
        "Minar-e-Pakistan was built between 1960 and 1968 to mark the 1940 Lahore Resolution. It symbolizes the struggle for Pakistan’s independence. The structure blends Mughal and modern styles. Each level represents stages of freedom. It stands proudly in Lahore’s Iqbal Park.",
    "history_ur":
        "مینارِ پاکستان 1960 سے 1968 کے درمیان تعمیر کیا گیا۔ یہ 1940 کی قراردادِ لاہور اور تحریکِ پاکستان کی علامت ہے۔ اس کا طرزِ تعمیر مغل اور جدید انداز کا امتزاج ہے۔ یہ اقبال پارک لاہور میں واقع ہے۔",
  },
  {
    "name": "Data Darbar",
    "location": "Lahore",
    "lat": 31.5837,
    "lon": 74.3230,
    "rating": 4.7,
    "imageUrl": "assets/datadarbar.png",
    "visitors": 100,
    "history":
        "Data Darbar is the shrine of Ali Hujwiri, an 11th-century Persian Sufi saint. It’s one of South Asia’s oldest and most visited shrines. Millions visit yearly for spiritual blessings. The shrine has been expanded many times in history. Today, it’s Lahore’s spiritual heart.",
    "history_ur":
        "داتا دربار حضرت علی ہجویریؒ کا مزار ہے جو گیارہویں صدی کے عظیم صوفی بزرگ تھے۔ یہ جنوبی ایشیا کے قدیم ترین اور سب سے زیادہ زائرین والے مزارات میں شامل ہے۔ لاکھوں افراد روحانی سکون کے لیے یہاں آتے ہیں۔",
  },
  {
    "name": "Faisal Mosque",
    "location": "Islamabad",
    "lat": 33.7294,
    "lon": 73.0379,
    "rating": 4.9,
    "imageUrl": "assets/faisal_mosque.png",
    "visitors": 95,
    "history":
        "Completed in 1986, Faisal Mosque was funded by Saudi Arabia. Designed by Turkish architect Vedat Dalokay, it resembles a Bedouin tent. The mosque accommodates over 100,000 worshippers. It symbolizes modern Islamic architecture. It’s Pakistan’s national mosque and a landmark.",
    "history_ur":
        "فیصل مسجد 1986 میں مکمل ہوئی اور اس کی مالی معاونت سعودی عرب نے کی۔ اسے ترک معمار ودعت دالوکائے نے ڈیزائن کیا۔ یہ پاکستان کی قومی مسجد ہے اور جدید اسلامی فنِ تعمیر کی علامت ہے۔",
  },
  {
    "name": "Hunza Valley",
    "location": "Gilgit-Baltistan",
    "lat": 36.3167,
    "lon": 74.6500,
    "rating": 4.9,
    "imageUrl": "assets/hunza.png",
    "visitors": 100,
    "history":
        "Hunza Valley is famed for breathtaking mountains and rich culture. Once a princely state, it joined Pakistan in 1974. The valley’s people are known for hospitality and longevity. Surrounded by Rakaposhi and Ultar peaks, it’s a natural paradise. It’s a dream spot for travelers.",
    "history_ur":
        "ہنزہ وادی اپنی شاندار قدرتی خوبصورتی اور ثقافت کے لیے مشہور ہے۔ یہ 1974 میں پاکستان کا حصہ بنی۔ یہاں کے لوگ مہمان نوازی اور لمبی عمر کے لیے جانے جاتے ہیں۔ راکاپوشی اور الٹر پہاڑوں سے گھری یہ وادی قدرتی جنت ہے۔",
  },
  {
    "name": "Quaid-e-Azam Mausoleum",
    "location": "Karachi",
    "lat": 24.8747,
    "lon": 67.0330,
    "rating": 4.9,
    "imageUrl": "assets/Quaid.png",
    "visitors": 95,
    "history":
        "This white marble mausoleum honors Muhammad Ali Jinnah. Completed in 1971, it’s Karachi’s most iconic landmark. The structure reflects simplicity and strength. Surrounded by gardens and fountains symbolizing purity. It’s a national site of respect and remembrance.",
    "history_ur":
        "یہ سفید سنگِ مرمر کا مزار قائدِ اعظم محمد علی جناحؒ کی آخری آرام گاہ ہے۔ 1971 میں مکمل ہونے والا یہ کراچی کی پہچان ہے۔ اس کا سادہ مگر مضبوط ڈیزائن قائد کی شخصیت کی عکاسی کرتا ہے۔",
  },
];


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),

                // 🌤️ Top Row (Profile + Name + Search + Calendar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // 🔥 PROFILE PIC WITH LOGOUT DROPDOWN
                        PopupMenuButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) {
                            if (value == "logout") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "logout",
                              child: Row(
                                children: [
                                  Icon(Icons.logout, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text("Logout"),
                                ],
                              ),
                            ),
                          ],
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage("assets/resot.png"),
                          ),
                        ),

                        const SizedBox(width: 10),
                      ],
                    ),

                    // Search + Calendar
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CalendarSchedule(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: width * 0.07),

                // 🌍 Explore Text
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 40, color: Colors.black),
                    children: [
                      TextSpan(text: "Explore the\n"),
                      TextSpan(
                        text: "Beautiful ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "world!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 7),

                // 🌤 Weather Box
                FutureBuilder<WeatherModel>(
  future: WeatherService.getWeatherByLocation(31.5204, 74.3587), // Lahore
  builder: (context, snapshot) {
    final isLoading =
        snapshot.connectionState == ConnectionState.waiting;
    final hasError = snapshot.hasError;
    final weather = snapshot.data;

    final isNight = _isNight();
    final condition = weather?.description ?? "";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: isNight
            ? Colors.indigo.shade200
            : _getWeatherColor(condition),
        borderRadius: BorderRadius.circular(18),
      ),
      child: isLoading
          ? Row(
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 15),
                Text("Loading weather..."),
              ],
            )
          : hasError
              ? const Text(
                  "Unable to load weather",
                  style: TextStyle(color: Colors.red),
                )
              : Row(
                  children: [
                    Icon(
                      isNight
                          ? Icons.nightlight_round
                          : _getWeatherIcon(condition),
                      size: 50,
                      color: isNight ? Colors.white : Colors.orange,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather!.city,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isNight
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${weather.temp.toStringAsFixed(1)}°C • ${weather.description}",
                          style: TextStyle(
                            fontSize: 14,
                            color: isNight
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Feels like ${weather.feelsLike.toStringAsFixed(1)}°C",
                          style: TextStyle(
                            fontSize: 13,
                            color: isNight
                                ? Colors.white60
                                : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  },
),

                const SizedBox(height: 20),

                // 🏖 Best Destination
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Best Destination",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ViewAllPage(destinations: destinations),
                          ),
                        );
                      },
                      child: const Text("View all"),
                    ),
                  ],
                ),

                SizedBox(height: width * 0.07),

                // Destination List
                SizedBox(
                  height: width * 0.9,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final destination = destinations[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlaceDetailScreen(place: destination),
                            ),
                          );
                        },
                        child: Container(
                          width: width * 0.6,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                                child: Image.asset(
                                  destination["imageUrl"],
                                  height: width * 0.65,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      destination["name"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            destination["location"],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 14,
                                              color: Colors.amber,
                                            ),
                                            Text(
                                              " ${destination["rating"]}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                              radius: 8,
                                              backgroundImage: AssetImage(
                                                'assets/resot.png',
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "+${destination["visitors"]}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
