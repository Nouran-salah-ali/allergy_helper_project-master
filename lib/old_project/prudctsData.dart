


import 'package:cloud_firestore/cloud_firestore.dart';
// For file name extraction



// Define the product data (your JSON structure)
final Map<String, dynamic> products = {
  "6281007042871": {
    "name": "Burger Buns Sesame Seeds",
    "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/Screenshot%202024-10-16%20190617.jpg?alt=media&token=968d8afb-b567-4ffd-87ea-1e94bc4c7fe1",
    "allergens": ["Egg", "Milk", "Gluten", "Wheat", "Sesame Seeds"]
  },
  "6281036284204": {
    "name": "Sun Bites Cheese and Herbs",
    "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/photo_2024-10-06_14-10-25.jpg?alt=media&token=e3593082-d09a-4e72-8a76-217e48756c6f",
    "allergens": ["Milk", "Gluten", "Soya"]
  },


    "6281007048248": {
      "name": "Triple Chocolate Muffin - مفن الشوكولاته ثلاث انواع لوزين",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/photo_3_2024-10-16_18-38-29.jpg?alt=media&token=a5ad29cf-2eb2-4a79-8be8-0a9f2eb8f1ec",
      "allergens": ["Gluten", "Milk", "Egg", "Soya"]
    },
    "8801073115705": {
      "name": "Bulgogi Noodle Soup - شوربه معكرونه بولغولي ساميانج",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/kvCOi7Z8dUNz1CYl7XiMQDQsWsxDDuVgvfxM3Mzn.jpg?alt=media&token=59a2180c-e8d1-487e-b8aa-acf387eb67e4",
      "allergens": ["Wheat", "Gluten", "Soy", "Sesame Seeds", "Milk", "Egg", "Fish", "MSG", "Peanut", "Celery"]
    },
    "6291011003812": {
      "name": "Karmoush Fried Corn Puff - كرموش منتفخات الدره",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/photo_2_2024-10-16_18-38-29.jpg?alt=media&token=36b09697-d806-4a2e-9d32-bdb788142408",
      "allergens": ["Gluten", "Milk", "Soya"]
    },
    "089686120134": {
      "name": "Indomie Chicken Curry Flavour - اندومي بنكه الكاري والدجاج",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/photo_4_2024-10-16_18-38-29.jpg?alt=media&token=a3127d93-cc56-4e75-9b2d-96fc1a2aa801",
      "allergens": ["Wheat", "MSG", "Gluten"]
    },
    "089686120196": {
      "name": "Indomie Special Chicken Flavour - اندومي بنكه الدجاج",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/photo_1_2024-10-16_18-38-29.jpg?alt=media&token=b24a6002-c111-4c16-a2b1-16b33a42ab8c",
      "allergens": ["Celery", "Wheat", "MSG", "Gluten"]
    },
    "6281004655036": {
      "name": "Gandour Tamria premium date rolls -غندور تمرية بسكويت بالتمر الفاخر ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/Tamria.jpg?alt=media&token=978b4f83-22ad-4323-a363-af79f5f56729",
      "allergens": ["Egg", "Soya", "Milk", "Gluten", "Peanut"] //white flower(Gluten), Milk,Soya, Egg, Peanut,(Nuts)
    },

    "6281004761034": {
      "name": "Gandour SAFARI Caramel Crunch chocolate- غندور ويفر شوكولاه سفاري",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/photo_6_2024-10-16_18-38-29.jpg?alt=media&token=9702d265-ccb8-4e43-8fdc-6713486279c3",
      "allergens": ["Milk", "Soya", "Egg", "Sesame Seeds", "Peanut", "Gluten"]
    },
    "6281100084044": {
      "name": "Lusine cheese croissant- لوزين كرواسان بالجبنه ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/%D9%83%D8%B1%D8%B3%D9%88%D9%86%20%D8%A8%D8%A7%D9%84%D8%AC%D8%A8%D9%86%D9%87%20%D9%84%D9%88%D8%B2%D9%8A%D9%86.png?alt=media&token=def280f3-b170-45fb-b7a2-7a4ee1c02cc5",
      "allergens": ["Milk", "Soya" "Gluten"]
    },
    "6281007033077": {
      "name": "Cheese slices burger- شرائح الجبنه برجر ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/%D8%B4%D8%B1%D8%A7%D8%A6%D8%AD%20%D8%A7%D9%84%D8%AC%D8%A8%D9%86%D9%87%20%D8%A8%D8%B1%D9%82%D8%B1.png?alt=media&token=f7d22b37-2703-46b1-a8a4-66b0a6ebd262",
      "allergens": ["Milk"]
    },
    "6281012033178": {
      "name": "Sun top  orange drink- سن توب برتقال شراب ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/%D8%B3%D9%86%20%D8%AA%D9%88%D8%A8%20%D8%A8%D8%B1%D8%AA%D9%82%D8%A7%D9%84.png?alt=media&token=50c04af7-41d2-4d61-a6e3-f365d00de507",
      "allergens": ["Milk", "Soya" "Gluten"]
    },
    "6281105500709": {
      "name": "Sandwich round vanilla icecream milk Al Ammal- ايسكريم فانيلا دائري الامل ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/%D8%A7%D9%8A%D9%83%D8%B1%D8%B3%D9%85%20%D8%A7%D9%84%D8%A7%D9%85%D9%84%20%D9%81%D8%A7%D9%86%D9%8A%D9%84%D8%A7.png?alt=media&token=250496eb-6a53-485d-b3bf-6421d32eca8e",
      "allergens": ["Milk", "Soya", "Gluten"]
    },
    "6084012810011": {
      "name": "Tarazan Al Halwachi food-  حلواجي الأغذية  ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/%D8%B7%D8%B1%D8%B2%D8%A7%D9%86.png?alt=media&token=dcd37067-1748-4fba-a5c9-8be69cabf2fc",
      "allergens": ["Gluten", "MSG"]
    },

    "6281016794815": {
      "name": "ALBATAL Chili Flavor- البطل بنكهة الفلفل الحار  ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/ALBATAL%20Chili%20Flavor.jpg?alt=media&token=82d6cc1a-9014-4df4-aeb1-a7405935bb91",
      "allergens": ["Milk"]
    },
    "6281100720317": {
      "name": "MERO- ميرو ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/MERO.jpg?alt=media&token=0fd63efd-b60a-4100-a039-2f3157ee53a9",
      "allergens": ["Milk","Soya","Egg"]
    },
    "6084001000010": {
      "name": " CHIPS CHICKEN LEG SHAPE- شيبس بشكل فخذ دجاج ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/CHIPS%20CHICKEN%20LEG%20SHAPE.png?alt=media&token=53c023fc-22d0-449c-bb9c-1b9b1af4a3e9",
      "allergens": []
    },
    "9501100019776": {
      "name": "Chips Oman- بطاطس عمان ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/chips%20Oman.jpg?alt=media&token=449c5a0c-00bc-4876-9297-e1dcd2ca00fc",
      "allergens": ["Milk","Soya"]
    },
    "6281016003177": {
      "name": "ALBATAL ketchup Flavor- البطل بنكهة الكاتشب   ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/ALBATAL%20ketchup%20Flavor.png?alt=media&token=703949cd-f5d9-43bc-aefb-3fb2e1fa77af",
      "allergens": ["Milk"]
    },
    "717273509115": {
      "name": "American Garden CREAMY RANCH-  صلصة رانش    ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/American%20Garden%20CREAMY%20RANCH.jpg?alt=media&token=4ce3f192-5235-48f7-8c0e-296072df1e76",
      "allergens": ["Milk","Egg"]
    },
    "6281100037088": {
      "name": "RANA Tomato Ketchup -  كتشب الطماطم رنا    ",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/RANA%20Tomato%20Ketchup.png?alt=media&token=9fb49058-1de2-4e55-9208-51912addbc72",
      "allergens": []
    },
      "6291028110022": {
      "name": "Mr krisps Rings lightly salted - مستر كريسبس شيبس بالملح الخفيف",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/mr%20krisps%20rings%20lightly%20salted.jpg?alt=media&token=1c2c3e3a-7bfe-41d0-9abf-cb04015e735b",
      "allergens": []
    },
       "5333876054675": {
      "name": "Cheese and jalapeno flavour corn puffs fantazee - تشيز كيرلز حراق",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/cheese%20and%20jalapeno%20flavour%20corn%20puffs%20fantazee.webp?alt=media&token=af8319ad-c1f4-49c3-b13a-bd9fd6414b26",
      "allergens": ["MSG"]
    },
      "6281004204531": {
      "name": "Gandour yamama dounut vanila cake - غندور اليمامة دونات بنكهة الفانيلا",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/gandour%20yamama%20dounut%20vanila%20cake.webp?alt=media&token=cb8377b9-ed7d-4410-8f98-4bb79bd560e6",
      "allergens": ["Gluten","Soya","Egg","Milk"]
    },
     "6291003086939": {
      "name": "ادور شوكلاته بالحليب - Adore milk chocolate",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/Adore%20milk%20chocolate.jpg?alt=media&token=d721eb4a-0c10-4768-b23c-f20cd7aca823",
      "allergens": ["Gluten","Soya","Peanut","Cashew","Milk"]
    },
         "6285602000564": {
      "name": "فرفشه اعواد رانش - Farfasha Ranch sauce sticks",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/%D9%81%D8%B1%D9%81%D8%B4%D9%87%20%D8%A7%D8%B9%D9%88%D8%A7%D8%AF%20%D8%B1%D8%A7%D9%86%D8%B4%20-%20Farfasha%20Ranch%20sauce%C2%A0%C2%A0sticks.jpg?alt=media&token=f0f212e4-06df-4e33-b7c1-1b7f66dc0429",
      "allergens": []
    },
         "776992022831": {
      "name": "فرفشه اعواد ملخ و خل - Farfasha Salt & Vinegar sticks",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/%D9%81%D8%B1%D9%81%D8%B4%D9%87%20%D8%A7%D8%B9%D9%88%D8%A7%D8%AF%20%D9%85%D9%84%D8%AE%20%D9%88%20%D8%AE%D9%84%20-%20Farfasha%20Salt%20%26%20Vinegar%C2%A0sticks.jpg?alt=media&token=fe206416-45b1-43b3-af90-e70f84e9e5a4",
      "allergens": []
    },
         "6281016960258": {
      "name": "رينجو ويفر مقرمش محشو بكريمة الشكولاتة - Ringo Crispy Chocolate cream filled wafer",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/%D8%B1%D9%8A%D9%86%D8%AC%D9%88%20%D9%88%D9%8A%D9%81%D8%B1%20%D9%85%D9%82%D8%B1%D9%85%D8%B4%20%D9%85%D8%AD%D8%B4%D9%88%20%D8%A8%D9%83%D8%B1%D9%8A%D9%85%D8%A9%20%D8%A7%D9%84%D8%B4%D9%83%D9%88%D9%84%D8%A7%D8%AA%D8%A9%20-%20Ringo%20Crispy%20Chocolate%20cream%C2%A0filled%C2%A0wafer.jpg?alt=media&token=ba31946b-1a77-4601-9c56-b25641595792",
      "allergens": ["Gluten","Soya","Egg","Milk"]
    },
       "6291003013003": {
      "name": "شنكوز رقائق الشوكولا كوكيز -  Chunko's choco chip cookies",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/%D8%B4%D9%86%D9%83%D9%88%D8%B2%20%D8%B1%D9%82%D8%A7%D8%A6%D9%82%20%D8%A7%D9%84%D8%B4%D9%88%D9%83%D9%88%D9%84%D8%A7%20%D9%83%D9%88%D9%83%D9%8A%D8%B2%20-%20%20Chunko's%20choco%20chip%20cookies.jpg?alt=media&token=f73e2f50-e2fa-412e-a8f7-8d3f74dcf32a",
      "allergens": ["Gluten","Soya","Peanut"]
    },
        "6291003081538": {
      "name": "يونكرز شوكلاتة الحليب مع الفول السوداني والكراميل والنوغا - Yonkers creamy milk chocolate with peanuts,caramel & nougat",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/%D9%8A%D9%88%D9%86%D9%83%D8%B1%D8%B2%20%D8%B4%D9%88%D9%83%D9%84%D8%A7%D8%AA%D8%A9%20%D8%A7%D9%84%D8%AD%D9%84%D9%8A%D8%A8%20%D9%85%D8%B9%20%D8%A7%D9%84%D9%81%D9%88%D9%84%20%D8%A7%D9%84%D8%B3%D9%88%D8%AF%D8%A7%D9%86%D9%8A%20%D9%88%D8%A7%D9%84%D9%83%D8%B1%D8%A7%D9%85%D9%8A%D9%84%20%D9%88%D8%A7%D9%84%D9%86%D9%88%D8%BA%D8%A7%20-%20Yonkers%20creamy%20milk%20chocolate%20with%20peanuts%2Ccaramel%C2%A0%26%C2%A0nougat.jpg?alt=media&token=128d05d5-bd14-4e34-bd5f-85a641399826",
      "allergens": ["Gluten","Soya","Egg","Milk","Peanut"]
    },
       "9501025177315": {
      "name": "ريليش كوكيز بالكاجو , اللوز و الشوفان - Relish Cookies cashew , almond & oats",
      "image": "https://firebasestorage.googleapis.com/v0/b/allergyhelperprojectd.appspot.com/o/%D8%B1%D9%8A%D9%84%D9%8A%D8%B4%20%D9%83%D9%88%D9%83%D9%8A%D8%B2%20%D8%A8%D8%A7%D9%84%D9%83%D8%A7%D8%AC%D9%88%20%2C%20%D8%A7%D9%84%D9%84%D9%88%D8%B2%20%D9%88%20%D8%A7%D9%84%D8%B4%D9%88%D9%81%D8%A7%D9%86%20-%20Relish%20Cookies%20cashew%20%2C%C2%A0almond%C2%A0%26%C2%A0oats.jpg?alt=media&token=b3d5bb84-a83e-4ed6-bd96-c3e737a27159",
      "allergens": ["Gluten","Soya","Milk","Peanut","Cashew"]
    },

    

/*'Egg': false,
    'Fish': false,
    'MSG': false,
    'Milk': false,
    'Gluten': false,
    'Soya': false,
    'Peanut': false,
    'Shrimp': false,
    'Cashew': false,
    'Celery': false,
    'Sesame Seeds': false,
    'Nothing': false,*/

};


Future<void> addProductsToFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Loop through each product and add to Firestore
  products.forEach((productId, productData) async {
    await firestore.collection('products').doc(productId).set(productData);
  });

  print("Products added to Firestore");
}
/*
void main() {
  // You can call this function somewhere in your app, for example:
  addProductsToFirestore();
}

*/