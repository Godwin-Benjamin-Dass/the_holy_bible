String holyBibeName = "பரிசுத்த வேதாகமம்";
String oldTestamentName = "பழைய\nஏற்பாடு";
String continueReadingName = "தொடர்ந்து படிக்கவும்";
String newTestamentName = "புதிய\nஏற்பாடு";
String searchName = "தேடு";
String referece = "குறிப்பு வசனம்";
String bookmarkName = "புத்தககுறிப்புகள்";
String settingsName = "அமைப்புகள்";
String theHolyBibleName = "பரிசுத்த வேதாகமம்";
String theOldTestamentName = "பழைய ஏற்பாடு";
String theNewTestamentName = "புதிய ஏற்பாடு";
String chapterName = "அதிகாரம்";
String noBookMarksYet = "இதுவரை புத்தககுறி வசனம் இல்லை";
String howCanIhelpYou = "உங்களுக்கு எவ்வாறு உதவலாம்";
String copy = "நகல் எடுக்க";
String gotoVerse = "வசனத்திற்கு செல்லுங்கள்";
String remove = "அகற்று";
String addToBookMark = "புத்தகக் குறியில் சேர்க்கவும்";
String close = "மூடு";
String fontsSize = "எழுத்து அளவு";
String darkTheme = "இருட்டாக்கு";
String totalVerse = "மொத்த வசனங்கள்";
String searchVerse = "தேடல் வசனம்";
String ended = "முடிந்தது";
String addToBookmark = "புத்தகக் குறியில் புத்தகக் குறியில்";
String recentVerse = "சமீபத்திய வசனம்";

String getBookName(int bookNumber) {
  switch (bookNumber) {
    case 1:
      return "ஆதியாகமம்";
    case 2:
      return "யாத்திராகமம்";
    case 3:
      return "லேவியராகமம்";
    case 4:
      return "எண்ணாகமம்";
    case 5:
      return "உபாகமம்";
    case 6:
      return "யோசுவா";
    case 7:
      return "நியாயாதிபதிகள் ";
    case 8:
      return "ரூத்";
    case 9:
      return "1 சாமுவேல்";
    case 10:
      return "2 சாமுவேல்";
    case 11:
      return "1 இராஜாக்கள்";
    case 12:
      return "2 இராஜாக்கள்";
    case 13:
      return "1 நாளாகமம்";
    case 14:
      return "2 நாளாகமம்";
    case 15:
      return "எஸ்றா";
    case 16:
      return "நெகேமியா";
    case 17:
      return "எஸ்தர்";
    case 18:
      return "யோபு";
    case 19:
      return "சங்கீதம்";
    case 20:
      return "நீதிமொழிகள்";
    case 21:
      return "பிரசங்கி";
    case 22:
      return "உன்னதப்பாட்டு";
    case 23:
      return "ஏசாயா";
    case 24:
      return "எரேமியா";
    case 25:
      return "புலம்பல்";
    case 26:
      return "எசேக்கியேல்";
    case 27:
      return "தானியேல்";
    case 28:
      return "ஓசியா";
    case 29:
      return "யோவேல்";
    case 30:
      return "ஆமோஸ்";
    case 31:
      return "ஒபதியா";
    case 32:
      return "யோனா";
    case 33:
      return "மீகா";
    case 34:
      return "நாகூம்";
    case 35:
      return "ஆபகூக்";
    case 36:
      return "செப்பனியா";
    case 37:
      return "ஆகாய்";
    case 38:
      return "சகரியா";
    case 39:
      return "மல்கியா";
    case 40:
      return "மத்தேயு";
    case 41:
      return "மாற்கு";
    case 42:
      return "லுக்கா";
    case 43:
      return "யோவான்";
    case 44:
      return "அப்போஸ்தலர்";
    case 45:
      return "ரோமர்";
    case 46:
      return "1 கொரிந்தியர்";
    case 47:
      return "2 கொரிந்தியர்";
    case 48:
      return "கலாத்தியர்";
    case 49:
      return "எபேசியர்";
    case 50:
      return "பிலிப்பியர்";
    case 51:
      return "கொலோசெயர்";
    case 52:
      return "1 தெசலோனிக்கேயர்";
    case 53:
      return "2 தெசலோனிக்கேயர்";
    case 54:
      return "1 தீமோத்தேயு";
    case 55:
      return "2 தீமோத்தேயு";
    case 56:
      return "தீத்து";
    case 57:
      return "பிலேமோன்";
    case 58:
      return "எபிரெயர்";
    case 59:
      return "யாக்கோபு";
    case 60:
      return "1 பேதுரு";
    case 61:
      return "2 பேதுரு";
    case 62:
      return "1 யோவான்";
    case 63:
      return "2 யோவான்";
    case 64:
      return "3 யோவான்";
    case 65:
      return "யூதா";
    case 66:
      return "வெளிப்படுத்தின விசேஷம்";
    default:
      return "அறியப்படவில்லை";
  }
}

Map<String, int> bibleBooks = {
  "ஆதியாகமம்": 50,
  "யாத்திராகமம்": 40,
  "லேவியராகமம்": 27,
  "எண்ணாகமம்": 36,
  "உபாகமம்": 34,
  "யோசுவா": 24,
  "நியாயாதிபதிகள்": 21,
  "ரூத்	": 4,
  "1 சாமுவேல்": 31,
  "2 சாமுவேல்": 24,
  "1 இராஜாக்கள்": 22,
  "2 இராஜாக்கள்": 25,
  "1 நாளாகமம்": 29,
  "2 நாளாகமம்": 36,
  "எஸ்றா": 10,
  "நெகேமியா": 13,
  "எஸ்தர்": 10,
  "யோபு": 42,
  "சங்கீதம்": 150,
  "நீதிமொழிகள்": 31,
  "பிரசங்கி": 12,
  "உன்னதப்பாட்டு": 8,
  "ஏசாயா": 66,
  "எரேமியா": 52,
  "புலம்பல்": 5,
  "எசேக்கியேல்": 48,
  "தானியேல்": 12,
  "ஓசியா	": 14,
  "யோவேல்": 3,
  "ஆமோஸ்": 9,
  "ஒபதியா": 1,
  "யோனா": 4,
  "மீகா": 7,
  "நாகூம்": 3,
  "ஆபகூக்": 3,
  "செப்பனியா": 3,
  "ஆகாய்": 2,
  "சகரியா": 14,
  "மல்கியா": 4,
  "மத்தேயு": 28,
  "மாற்கு": 16,
  "லுக்கா": 24,
  "யோவான்": 21,
  "அப்போஸ்தலர்": 28,
  "ரோமர்": 16,
  "1 கொரிந்தியர்": 16,
  "2 கொரிந்தியர்": 13,
  "கலாத்தியர்": 6,
  "எபேசியர்": 6,
  "பிலிப்பியர்": 4,
  "கொலோசெயர்": 4,
  "1 தெசலோனிக்கேயர்": 5,
  "2 தெசலோனிக்கேயர்": 3,
  "1 தீமோத்தேயு": 6,
  "2 தீமோத்தேயு": 4,
  "தீத்து": 3,
  "பிலேமோன்": 1,
  "எபிரெயர்": 13,
  "யாக்கோபு": 5,
  "1 பேதுரு": 5,
  "2 பேதுரு": 3,
  "1 யோவான்	": 5,
  "2 யோவான்	": 1,
  "3 யோவான்": 1,
  "யூதா": 1,
  "வெளிப்படுத்தின விசேஷம்": 22
};
