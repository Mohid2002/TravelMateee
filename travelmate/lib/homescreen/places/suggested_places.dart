import 'dart:async';
import 'package:flutter/material.dart';
import 'package:travelmate/homescreen/place_detailed_home_Screen.dart';
import 'package:travelmate/homescreen/safe_place_manager.dart';

class SuggestedPlaces extends StatefulWidget {
  const SuggestedPlaces({super.key});

  @override
  State<SuggestedPlaces> createState() => _SuggestedPlacesState();
}

class _SuggestedPlacesState extends State<SuggestedPlaces> {
  final manager = SavedPlacesManager();

  String? selectedInterest;
  int? selectedWeather;
  final TextEditingController budgetCTRL = TextEditingController();

  bool isLoading = false;
  bool showResults = false;

  final Map<int, String> weathers = {
  0: "clear sky",
  1: "mainly clear",
  2: "partly cloudy",
  3: "overcast",
  4: "snowfall",
};

  /// ---------------- DATA ----------------
  final List<Map<String, dynamic>> allPlaces = [
    {
      "title": "Badshahi Mosque",
      "location": "Lahore, Pakistan",
      "lat": 31.5880,
      "lon": 74.3109,
      "image": "assets/badshai.png",
      "tags": ["historical", "religious", "architecture"],
      "history":
          "Built in 1673 by Emperor Aurangzeb, Badshahi Mosque stands as a crown jewel of Mughal architecture. "
          "It once served as the largest mosque in the world. "
          "Its red sandstone structure and marble domes reflect Islamic artistry. "
          "The mosque endured invasions but remains beautifully preserved. "
          "It’s now one of Lahore’s most iconic landmarks.",
      "history_urdu":
          "1673 میں شہنشاہ اورنگزیب نے بادشاہی مسجد تعمیر کروائی، جو مغلیہ فن تعمیر کا شاہکار ہے۔ "
          "یہ دنیا کی سب سے بڑی مسجد بھی رہی ہے۔ "
          "اس کا سرخ پتھر اور سنگ مرمر کے گنبد اسلامی فن کی عکاسی کرتے ہیں۔ "
          "مسجد نے حملوں کا سامنا کیا لیکن خوبصورتی سے محفوظ ہے۔ "
          "یہ آج لاہور کے سب سے مشہور مقامات میں سے ایک ہے۔",
    },
    {
      "title": "Lahore Fort",
      "location": "Lahore, Pakistan",
      "lat": 31.5889,
      "lon": 74.3106,
      "image": "assets/Lahore_Fort.png",
      "tags": ["historical", "fort", "architecture"],
      "history":
          "Lahore Fort, also known as Shahi Qila, was rebuilt by Emperor Akbar in the 16th century. "
          "It served as a royal residence for Mughal emperors. "
          "Within its walls lie gems like Sheesh Mahal and Naulakha Pavilion. "
          "The fort tells stories of Mughal glory and colonial struggles. "
          "It is now a UNESCO World Heritage Site.",
      "history_urdu":
          "لاہور قلعہ، جسے شاہی قلعہ بھی کہا جاتا ہے، کو 16ویں صدی میں شہنشاہ اکبر نے دوبارہ تعمیر کروایا۔ "
          "یہ مغلیہ بادشاہوں کی شاہی رہائش گاہ تھا۔ "
          "اس کی دیواروں میں شییش محل اور نولکھا پویلین جیسے شاہکار موجود ہیں۔ "
          "قلعہ مغلیہ عظمت اور نوآبادیاتی جدوجہد کی کہانیاں بیان کرتا ہے۔ "
          "یہ اب یونسکو عالمی ثقافتی ورثہ ہے۔",
    },
    {
      "title": "Shalimar Gardens",
      "location": "Lahore, Pakistan",
      "lat": 31.5844,
      "lon": 74.3805,
      "image": "assets/shalimar.png",
      "tags": ["historical", "gardens", "nature"],
      "history":
          "Commissioned by Shah Jahan in 1641, Shalimar Gardens exemplify Mughal landscape design. "
          "Three terraces symbolize heaven, earth, and humanity. "
          "Its 410 fountains and marble pavilions create serene harmony. "
          "The gardens were a royal retreat for emperors. "
          "Today, they are a peaceful escape for locals and tourists alike.",
      "history_urdu":
          "1641 میں شاہجہان نے شالیمار باغات کا قیام کروایا، جو مغلیہ باغبانی کی بہترین مثال ہیں۔ "
          "تین تراسیں جنت، زمین اور انسانیت کی نمائندگی کرتی ہیں۔ "
          "410 فوارے اور سنگ مرمر کے پویلین سکون بخش ہم آہنگی پیدا کرتے ہیں۔ "
          "یہ باغات بادشاہوں کے لئے شاہی تفریح گاہ تھے۔ "
          "آج یہ مقامی اور سیاحوں کے لئے پُرسکون مقام ہیں۔",
    },
    {
      "title": "Wazir Khan Mosque",
      "location": "Lahore, Pakistan",
      "lat": 31.5821,
      "lon": 74.3166,
      "image": "assets/wazir_khan.png",
      "tags": ["historical", "religious", "architecture"],
      "history":
          "Built in 1634 during Shah Jahan’s reign, the Wazir Khan Mosque is famed for its intricate tile work. "
          "Every wall is covered with Persian-style frescoes and mosaics. "
          "It was named after the governor, Ilm-ud-Din Ansari (Wazir Khan). "
          "The mosque served as both a religious and cultural hub. "
          "It stands as Lahore’s most artistically detailed mosque.",
      "history_urdu":
          "1634 میں شاہجہان کے دور میں تعمیر شدہ وزیر خان مسجد اپنی نفیس ٹائل کاری کے لئے مشہور ہے۔ "
          "ہر دیوار فارسی انداز کے نقش و نگار اور موزیک سے سجی ہوئی ہے۔ "
          "یہ گورنر علم الدین انصاری (وزیر خان) کے نام پر رکھی گئی تھی۔ "
          "مسجد مذہبی اور ثقافتی مرکز کے طور پر کام کرتی تھی۔ "
          "یہ لاہور کی سب سے فنکارانہ مسجد ہے۔",
    },
    {
      "title": "Sheesh Mahal",
      "location": "Lahore, Pakistan",
      "lat": 31.5892,
      "lon": 74.3105,
      "image": "assets/sheeshmahal.png",
      "tags": ["historical", "palace", "architecture"],
      "history":
          "Sheesh Mahal, the 'Palace of Mirrors', was built by Shah Jahan in 1631. "
          "Its walls are inlaid with thousands of small mirrors. "
          "Light reflections create a breathtaking glittering effect. "
          "It was designed for royal gatherings and private ceremonies. "
          "The palace remains a symbol of Mughal luxury and creativity.",
      "history_urdu":
          "شییش محل، 'آئینوں کا محل'، 1631 میں شاہجہان نے تعمیر کروایا۔ "
          "اس کی دیواروں میں ہزاروں چھوٹے آئینے جڑے ہوئے ہیں۔ "
          "روشنی کی عکاسی حیرت انگیز چمک پیدا کرتی ہے۔ "
          "یہ شاہی اجتماعات اور نجی تقریبات کے لیے ڈیزائن کیا گیا تھا۔ "
          "یہ محل مغلیہ عیش و عشرت اور تخلیقی صلاحیت کی علامت ہے۔",
    },
    {
      "title": "Minar-e-Pakistan",
      "location": "Lahore, Pakistan",
      "lat": 31.5925,
      "lon": 74.3095,
      "image": "assets/Minar-e-Pakistan.png",
      "tags": ["historical", "monument", "national"],
      "history":
          "Minar-e-Pakistan marks the historic Lahore Resolution of 1940. "
          "The monument was constructed between 1960 and 1968. "
          "It symbolizes unity, freedom, and the creation of Pakistan. "
          "Architect Nasreddin Murat-Khan blended Mughal and modern design. "
          "It’s a proud national symbol visited by millions annually.",
      "history_urdu":
          "مینارِ پاکستان 1940 کے تاریخی لاہور قرارداد کی علامت ہے۔ "
          "یہ یادگار 1960 سے 1968 کے درمیان تعمیر ہوئی۔ "
          "یہ اتحاد، آزادی اور پاکستان کے قیام کی نمائندگی کرتی ہے۔ "
          "معمار نصرالدین مراد خان نے مغلیہ اور جدید ڈیزائن کو ملا کر بنایا۔ "
          "یہ ایک قومی فخر کی علامت ہے، جسے ہر سال لاکھوں لوگ دیکھتے ہیں۔",
    },
    {
      "title": "Data Darbar",
      "location": "Lahore, Pakistan",
      "lat": 31.5837,
      "lon": 74.3230,
      "image": "assets/datadarbar.png",
      "tags": ["religious", "historical", "spiritual"],
      "history":
          "Data Darbar houses the shrine of the Sufi saint Hazrat Ali Hujwiri, also known as Data Ganj Bakhsh. "
          "Built over a thousand years ago, it’s one of South Asia’s oldest Muslim shrines. "
          "Millions visit to pay homage each year. "
          "It reflects the spiritual heart of Lahore. "
          "The shrine’s white marble and domes radiate tranquility.",
      "history_urdu":
          "داتا دربار صوفی بزرگ حضرت علی ہجویری، المعروف داتا گنج بخش، کے مزار کا مقام ہے۔ "
          "یہ ایک ہزار سال سے زیادہ پرانا ہے اور جنوبی ایشیا کے سب سے قدیم مسلم مقامات میں سے ایک ہے۔ "
          "ہر سال لاکھوں زائرین حاضری دیتے ہیں۔ "
          "یہ لاہور کے روحانی مرکز کی عکاسی کرتا ہے۔ "
          "مزار کا سفید سنگ مرمر اور گنبد سکون بخشتے ہیں۔",
    },
    {
      "title": "Faisal Mosque",
      "location": "Islamabad, Pakistan",
      "lat": 33.7294,
      "lon": 73.0379,
      "image": "assets/faisal_mosque.png",
      "tags": ["religious", "modern", "monument"],
      "history":
          "Faisal Mosque, completed in 1986, is Pakistan’s largest mosque. "
          "Designed by Turkish architect Vedat Dalokay, it features a desert-tent-inspired design. "
          "Funded by King Faisal of Saudi Arabia, it symbolizes Pak-Saudi friendship. "
          "It overlooks the Margalla Hills in stunning symmetry. "
          "Its minimalist yet monumental structure attracts global admiration.",
      "history_urdu":
          "فیصل مسجد، 1986 میں مکمل ہوئی، پاکستان کی سب سے بڑی مسجد ہے۔ "
          "ترک معمار ویدات دالوکائی نے اسے صحرا کے خیمے سے متاثر ڈیزائن کیا۔ "
          "سعودی عرب کے بادشاہ فیصل نے فنڈ کیا، یہ پاک-سعودی دوستی کی علامت ہے۔ "
          "یہ مارگلہ ہلز کی خوبصورتی سے منظر پیش کرتی ہے۔ "
          "سادہ مگر شاندار ڈیزائن عالمی سطح پر تعریف حاصل کرتا ہے۔",
    },
    {
      "title": "Lok Virsa Museum",
      "location": "Islamabad, Pakistan",
      "lat": 33.6844,
      "lon": 73.0496,
      "image": "assets/LokVirsaMuseum.png",
      "tags": ["museum", "culture", "heritage"],
      "history":
          "Lok Virsa Museum showcases Pakistan’s diverse cultural heritage. "
          "It displays crafts, traditions, and folk art from all provinces. "
          "Established in 1982, it celebrates unity in diversity. "
          "Visitors experience the lifestyle of various ethnic communities. "
          "It’s a living tribute to Pakistan’s rich folk history.",
      "history_urdu":
          "لوک ورثہ میوزیم پاکستان کی متنوع ثقافتی وراثت کو پیش کرتا ہے۔ "
          "یہ تمام صوبوں کی دستکاری، روایات اور عوامی فن دکھاتا ہے۔ "
          "1982 میں قائم، یہ تنوع میں اتحاد کا جشن مناتا ہے۔ "
          "زائرین مختلف کمیونٹیوں کی زندگی کا تجربہ کرتے ہیں۔ "
          "یہ پاکستان کی امیر عوامی تاریخ کو زندہ رکھنے کا عکاس ہے۔",
    },
    {
      "title": "Saidpur Village",
      "location": "Islamabad, Pakistan",
      "lat": 33.7476,
      "lon": 73.0821,
      "image": "assets/SaidpurVillage.png",
      "tags": ["historical", "village", "tourist"],
      "history":
          "Saidpur Village dates back over 500 years, originally a Hindu village. "
          "It was later renovated into a heritage site. "
          "The area retains ancient temples and Mughal-era architecture. "
          "Now, it blends old charm with modern cafes and art. "
          "It’s a must-visit for those seeking culture and history in one spot.",
      "history_urdu":
          "سیدپور گاؤں 500 سال سے بھی زیادہ پرانا ہے، ابتدا میں ایک ہندو گاؤں تھا۔ "
          "بعد میں اسے ہیریٹیج سائٹ میں تبدیل کیا گیا۔ "
          "یہاں قدیم مندر اور مغلیہ دور کی عمارتیں موجود ہیں۔ "
          "اب یہ قدیم حسن کو جدید کیفے اور آرٹ کے ساتھ ملا دیتا ہے۔ "
          "یہ ثقافت اور تاریخ کے خواہش مندوں کے لئے لازمی دیکھنے کی جگہ ہے۔",
    },
    {
      "title": "Margalla Hills",
      "location": "Islamabad, Pakistan",
      "lat": 33.7480,
      "lon": 73.0700,
      "image": "assets/Margalla Hills.png",
      "tags": ["nature", "hills", "trekking"],
      "history":
          "The Margalla Hills are part of the Himalayan foothills. "
          "They cradle Islamabad in lush greenery and scenic trails. "
          "The range hosts diverse wildlife and historical caves. "
          "Locals and tourists hike here for breathtaking views. "
          "It’s a sanctuary of peace and natural beauty.",
      "history_urdu":
          "مارگلہ ہلز ہمالیہ کی پہاڑیوں کا حصہ ہیں۔ "
          "یہ اسلام آباد کو سرسبز مناظر اور خوبصورت راستوں سے گھیرتے ہیں۔ "
          "یہاں متنوع جنگلی حیات اور تاریخی غار موجود ہیں۔ "
          "مقامی لوگ اور سیاح یہاں خوبصورت مناظر کے لیے پیدل چلتے ہیں۔ "
          "یہ سکون اور قدرتی خوبصورتی کی پناہ گاہ ہے۔",
    },
    {
      "title": "Rawal Lake",
      "location": "Islamabad, Pakistan",
      "lat": 33.6844,
      "lon": 73.1245,
      "image": "assets/Rawal Lake.png",
      "tags": ["nature", "lake", "recreation"],
      "history":
          "Rawal Lake is an artificial reservoir supplying water to Islamabad and Rawalpindi. "
          "Surrounded by the Margalla Hills, it offers serene picnic spots. "
          "Built in 1962, it has become a favorite recreational site. "
          "Boating and fishing are popular activities here. "
          "The sunset view from the lake is simply magical.",
      "history_urdu":
          "راول جھیل اسلام آباد اور راولپنڈی کو پانی فراہم کرنے والا مصنوعی ذخیرہ ہے۔ "
          "مارگلہ ہلز کے گرد گھرا ہوا، یہ پُرسکون پکنک کے مقامات پیش کرتا ہے۔ "
          "1962 میں بنایا گیا، یہ تفریح کے لیے پسندیدہ جگہ بن چکا ہے۔ "
          "یہاں کشتی رانی اور ماہی گیری مقبول سرگرمیاں ہیں۔ "
          "جھیل سے غروب آفتاب کا منظر لاجواب ہے۔",
    },
    {
      "title": "Daman-e-Koh",
      "location": "Islamabad, Pakistan",
      "lat": 33.7489,
      "lon": 73.0467,
      "image": "assets/Daman-e-Koh.png",
      "tags": ["nature", "viewpoint", "tourist"],
      "history":
          "Daman-e-Koh is a viewpoint located in the Margalla Hills. "
          "It offers panoramic views of Islamabad city. "
          "It’s a popular spot for tourists and locals alike. "
          "Wild monkeys and peacocks often add charm to visits. "
          "The area’s calm weather makes it ideal for relaxation.",
      "history_urdu":
          "دامنِ کوہ مارگلہ ہلز میں واقع ایک نقطہ نظر ہے۔ "
          "یہ اسلام آباد شہر کے دلکش مناظر پیش کرتا ہے۔ "
          "یہ سیاحوں اور مقامی لوگوں کے لیے مشہور مقام ہے۔ "
          "وحشی بندر اور مور اکثر دورے کو مزید دلچسپ بناتے ہیں۔ "
          "اس علاقے کا پرسکون موسم آرام کے لیے بہترین ہے۔",
    },
    {
      "title": "Hunza Valley",
      "location": "Gilgit-Baltistan, Pakistan",
      "lat": 36.3167,
      "lon": 74.6500,
      "image": "assets/hunza.png",
      "tags": ["nature", "valley", "tourist"],
      "history":
          "Hunza Valley is a breathtaking region surrounded by snow-capped peaks. "
          "It was once a princely state on the Silk Route. "
          "The valley is famous for its longevity and peaceful residents. "
          "Karimabad and Baltit Fort reflect its rich past. "
          "Hunza is known as a paradise for nature and photography lovers.",
      "history_urdu":
          "ہنزہ وادی ایک شاندار مقام ہے جو برف سے ڈھکے پہاڑوں سے گھرا ہوا ہے۔ "
          "یہ کبھی سلک روٹ پر ایک ریاست تھی۔ "
          "وادی اپنی لمبی عمر اور پُرسکون رہائشیوں کے لیے مشہور ہے۔ "
          "کریم آباد اور بالتت قلعہ اس کے بھرپور ماضی کی عکاسی کرتے ہیں۔ "
          "ہنزہ فطرت اور فوٹوگرافی کے شوقین افراد کے لیے جنت کے طور پر مشہور ہے۔",
    },
    {
      "title": "Fairy Meadows",
      "location": "Gilgit-Baltistan, Pakistan",
      "lat": 35.4213,
      "lon": 74.5969,
      "image": "assets/feary.png",
      "tags": ["nature", "meadow", "trekking"],
      "history":
          "Fairy Meadows is a grassy plateau near Nanga Parbat, the 9th highest mountain. "
          "It’s known for its fairytale-like scenery. "
          "Local legend says fairies dance here under the moonlight. "
          "The area offers mesmerizing views of snow-capped peaks. "
          "It’s one of Pakistan’s top trekking and camping destinations.",
      "history_urdu":
          "فیری میڈوز نانگا پربت کے قریب ایک گھاس کا میدان ہے، جو نویں بلند ترین پہاڑ ہے۔ "
          "یہ اپنی پریوں جیسی مناظر کے لیے مشہور ہے۔ "
          "مقامی کہانی کے مطابق یہاں پریاں چاندنی رات میں رقص کرتی ہیں۔ "
          "یہ علاقہ برف سے ڈھکے پہاڑوں کے دلکش مناظر پیش کرتا ہے۔ "
          "یہ پاکستان کی اعلیٰ ترین ٹریکنگ اور کیمپنگ مقامات میں سے ایک ہے۔",
    },
    {
      "title": "Skardu",
      "location": "Gilgit-Baltistan, Pakistan",
      "lat": 35.2971,
      "lon": 75.6333,
      "image": "assets/Skardu.png",
      "tags": ["nature", "city", "mountains"],
      "history":
          "Skardu lies at the heart of Baltistan, surrounded by towering mountains. "
          "It serves as the gateway to K2 and other Himalayan peaks. "
          "The region is rich in Tibetan-inspired culture. "
          "Shangrila Lake and Shigar Fort are its main attractions. "
          "Its stunning landscapes attract trekkers and explorers worldwide.",
      "history_urdu":
          "اسکردو بلتستان کے مرکز میں واقع ہے، جو بلند پہاڑوں سے گھرا ہوا ہے۔ "
          "یہ کے ٹو اور دیگر ہمالیہ کے پہاڑوں کا گیٹ وے ہے۔ "
          "یہ علاقہ تبتی ثقافت سے متاثر ہے۔ "
          "شنگریلا جھیل اور شگر قلعہ اس کی اہم کششیں ہیں۔ "
          "اس کے دلکش مناظر دنیا بھر کے ٹریکرز اور مہم جو افراد کو متوجہ کرتے ہیں۔",
    },
    {
      "title": "Deosai Plains",
      "location": "Skardu, Pakistan",
      "lat": 35.0300,
      "lon": 75.4400,
      "image": "assets/Deosai Plains.png",
      "tags": ["nature", "plateau", "wildlife"],
      "history":
          "Known as the 'Land of Giants', Deosai Plains sit at 13,000 feet above sea level. "
          "It’s one of the highest plateaus on Earth. "
          "Home to the Himalayan brown bear, it bursts with wildflowers in summer. "
          "The region transforms into a snow desert in winter. "
          "It’s a hidden gem for adventurers and nature lovers.",
      "history_urdu":
          "دیوسائی میدان، 'دیویوں کی زمین' کے نام سے مشہور، 13,000 فٹ بلندی پر واقع ہے۔ "
          "یہ زمین کی سب سے بلند سطحوں میں سے ایک ہے۔ "
          "یہاں ہمالیائی براؤن ریچھ رہتے ہیں اور گرمیوں میں جنگلی پھولوں سے بھرجاتا ہے۔ "
          "سردیوں میں یہ علاقہ برفانی صحرہ میں تبدیل ہو جاتا ہے۔ "
          "یہ مہم جو اور فطرت کے شوقین افراد کے لیے ایک چھپا ہوا جواہر ہے۔",
    },
    {
      "title": "K2 Base Camp",
      "location": "Skardu, Pakistan",
      "lat": 35.8825,
      "lon": 76.5133,
      "image": "assets/K2 Base Camp.png",
      "tags": ["mountain", "trekking", "adventure"],
      "history":
          "K2 Base Camp is the starting point for summiting the world's second-highest peak. "
          "It lies deep in the Karakoram Range. "
          "Trekkers journey through glaciers and rugged terrains. "
          "The trail offers surreal views of icy giants. "
          "It’s a challenge and dream for every mountaineer.",
      "history_urdu":
          "کے ٹو بیس کیمپ دنیا کی دوسری بلند ترین چوٹی پر چڑھنے کا آغاز نقطہ ہے۔ "
          "یہ قراقرم رینج کے گہرائیوں میں واقع ہے۔ "
          "ٹریکرز گلیشیئرز اور دشوار راستوں سے گزرتے ہیں۔ "
          "راستہ برف سے ڈھکے دیو نما پہاڑوں کے خوابناک مناظر پیش کرتا ہے۔ "
          "یہ ہر کوہ پیما کے لیے چیلنج اور خواب ہے۔",
    },
    {
      "title": "Naltar Valley",
      "location": "Gilgit, Pakistan",
      "lat": 36.1396,
      "lon": 74.1928,
      "image": "assets/Naltar Valley.png",
      "tags": ["nature", "valley", "tourist"],
      "history":
          "Naltar Valley is known for its crystal lakes and pine forests. "
          "It’s one of the most colorful valleys in the north. "
          "The valley’s serene lakes reflect pure natural beauty. "
          "It’s also home to Pakistan’s first ski resort. "
          "A true paradise for photographers and peace seekers.",
      "history_urdu":
          "نلتر وادی اپنے کرسٹل جھیلوں اور صنوبر کے جنگلات کے لیے مشہور ہے۔ "
          "یہ شمال کے سب سے رنگین وادیوں میں سے ایک ہے۔ "
          "وادی کی پرسکون جھیلیں خالص قدرتی خوبصورتی کی عکاسی کرتی ہیں۔ "
          "یہ پاکستان کے پہلے اسکی ریزورٹ کا بھی مقام ہے۔ "
          "یہ فوٹوگرافروں اور سکون تلاش کرنے والوں کے لیے جنت ہے۔",
    },
    {
      "title": "Khunjerab Pass",
      "location": "Hunza, Pakistan",
      "lat": 36.8500,
      "lon": 75.4300,
      "image": "assets/Khunjerab Pass.png",
      "tags": ["mountain", "border", "adventure"],
      "history":
          "Khunjerab Pass connects Pakistan and China at 15,397 feet altitude. "
          "It’s part of the legendary Karakoram Highway. "
          "The area offers snow, silence, and surreal mountain views. "
          "It represents friendship through the Pak-China border. "
          "Visitors enjoy breathtaking scenery and cool winds year-round.",
      "history_urdu":
          "خنجراب پاس پاکستان اور چین کو 15,397 فٹ کی بلندی پر ملاتا ہے۔ "
          "یہ مشہور قراقرم ہائی وے کا حصہ ہے۔ "
          "یہ علاقہ برف، خاموشی، اور خوابناک پہاڑی مناظر پیش کرتا ہے۔ "
          "یہ پاک-چین سرحد کے ذریعے دوستی کی نمائندگی کرتا ہے۔ "
          "سال بھر زائرین یہاں دلکش مناظر اور ٹھنڈی ہوائیں لطف اندوز ہوتے ہیں۔",
    },
    {
      "title": "Rakaposhi Base Camp",
      "location": "Nagar, Pakistan",
      "lat": 36.1136,
      "lon": 74.4908,
      "image": "assets/Rakaposhi Base Camp.png",
      "tags": ["mountain", "trekking", "adventure"],
      "history":
          "Rakaposhi Base Camp offers mesmerizing views of the Rakaposhi Peak. "
          "The trek begins near the village of Minapin. "
          "It’s one of the most accessible base camps in the Karakoram. "
          "Lush meadows and glaciers surround the area. "
          "The site symbolizes serenity amidst the mighty mountains.",
      "history_urdu":
          "راکاپوشی بیس کیمپ راکاپوشی چوٹی کے دلکش مناظر پیش کرتا ہے۔ "
          "ٹریک گاؤں مینپین کے قریب شروع ہوتی ہے۔ "
          "یہ قراقرم میں سب سے قابل رسائی بیس کیمپس میں سے ایک ہے۔ "
          "ہریالی سے بھرے میدان اور گلیشیئر علاقے کو گھیرے ہوئے ہیں۔ "
          "یہ مقام عظیم پہاڑوں کے درمیان سکون کی علامت ہے۔",
    },
    {
      "title": "Swat Valley",
      "location": "KPK, Pakistan",
      "lat": 35.2227,
      "lon": 72.4258,
      "image": "assets/swat.png",
      "tags": ["nature", "valley", "tourist"],
      "history":
          "Swat Valley, often called the 'Switzerland of the East', is rich in natural beauty. "
          "It was once a center of Buddhist civilization. "
          "Lush green hills and turquoise rivers fill the valley. "
          "The region has rebounded as a peaceful tourist haven. "
          "It continues to attract visitors from around the world.",
      "history_urdu":
          "سوات وادی، جسے اکثر 'مشرق کا سوئٹزرلینڈ' کہا جاتا ہے، قدرتی خوبصورتی سے بھرپور ہے۔ "
          "یہ کبھی بدھ مت کی تہذیب کا مرکز تھی۔ "
          "سبز ہریالی والے پہاڑ اور فیروزی رنگ کی ندیاں وادی کو بھرتی ہیں۔ "
          "یہ علاقہ اب پرامن سیاحتی مقام کے طور پر ابھرا ہے۔ "
          "یہ دنیا بھر سے زائرین کو اپنی طرف متوجہ کرتا ہے۔",
    },
    {
      "title": "Quaid-e-Azam Mausoleum",
      "location": "Karachi, Pakistan",
      "lat": 24.8747,
      "lon": 67.0330,
      "image": "assets/Quaid.png",
      "tags": ["historical", "monument", "national"],
      "history":
          "The Quaid-e-Azam Mausoleum is the final resting place of Muhammad Ali Jinnah. "
          "Completed in 1970, it is a symbol of respect and unity. "
          "Its white marble structure shines with simplicity and grace. "
          "Thousands visit daily to honor the founder of Pakistan. "
          "It remains Karachi’s most iconic monument.",
      "history_urdu":
          "مزار قائد محمد علی جناح کی آخری آرام گاہ ہے۔ "
          "1970 میں مکمل ہوا، یہ احترام اور اتحاد کی علامت ہے۔ "
          "اس کی سفید سنگ مرمر کی تعمیر سادگی اور وقار سے چمکتی ہے۔ "
          "روزانہ ہزاروں لوگ پاکستان کے بانی کو خراج تحسین پیش کرتے ہیں۔ "
          "یہ کراچی کا سب سے مشہور یادگار ہے۔",
    },
  ];

  List<Map<String, dynamic>> filteredPlaces = [];

  /// ---------------- CHECK IF ALL FILTERS SELECTED ----------------
  bool get isFilterComplete {
    return selectedInterest != null &&
        budgetCTRL.text.isNotEmpty &&
        selectedWeather != null;
  }

  /// ---------------- APPLY FILTERS ----------------
  void applyFilters() {
    if (!isFilterComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select interest, enter budget, and choose weather first!",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      showResults = false;
    });

    Future.delayed(const Duration(seconds: 10), () {
      filteredPlaces = allPlaces.where((place) {
        // ✅ ONLY INTEREST FILTER
        return place['tags']
            .map((e) => e.toString().toLowerCase())
            .contains(selectedInterest!.toLowerCase());
      }).toList();

      setState(() {
        isLoading = false;
        showResults = true;
      });

      if (filteredPlaces.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No places found for selected filters."),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: const Text("Suggested Places",style: TextStyle(color: Colors.white),)),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : showResults
            ? buildResults(width)
            : buildFilterForm(),
      ),
    );
  }

  /// ---------------- FILTER UI ----------------
  Widget buildFilterForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Your Interest",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ["historical", "nature", "cultural", "adventure"].map((
              e,
            ) {
              return ChoiceChip(
                label: Text(e),
                selected: selectedInterest == e,
                onSelected: (_) {
                  setState(() => selectedInterest = e);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          const Text(
            "Enter Maximum Budget (PKR)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: budgetCTRL,
            keyboardType: TextInputType.number,
            onChanged: (_) {
              setState(() {}); // Refresh button state
            },
            decoration: InputDecoration(
              labelText: "Budget",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Select Weather Preference",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: selectedWeather,
            hint: const Text("Any Weather"),
            isExpanded: true,
            items: weathers.entries
                .map(
                  (e) =>
                      DropdownMenuItem<int>(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: (value) {
              setState(() => selectedWeather = value);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),

          const SizedBox(height: 30),

          Center(
            child: ElevatedButton(
              onPressed: isFilterComplete ? applyFilters : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFilterComplete
                    ? Colors.blue.shade800
                    : Colors.grey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
              child: const Text(
                "Apply Filters",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- RESULTS (GRID) ----------------
  Widget buildResults(double width) {
    if (filteredPlaces.isEmpty) {
      return const Center(
        child: Text(
          "No places match your filters 😢",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return GridView.builder(
      itemCount: filteredPlaces.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final place = filteredPlaces[index];
        final isSaved = manager.isSaved(place["title"]);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlaceDetailScreen(
                  place: {
                    "name": place["title"],
                    "location": place["location"],
                    "history": place["history"],
                    "imageUrl": place["image"],
                    "lat": place["lat"],
                    "lon": place["lon"],
                  },
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    place["image"],
                    height: width * 0.32,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place["title"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        place["location"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: width * 0.032,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? Colors.orange : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        manager.togglePlace(place);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
