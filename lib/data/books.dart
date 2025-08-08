var oldTestamentBooks = [
  {"book_no": 1, "no_of_books": 50, "nameE": "Genesis", "nameT": "ஆதியாகமம்"},
  {"book_no": 2, "no_of_books": 40, "nameE": "Exodus", "nameT": "யாத்திராகமம்"},
  {
    "book_no": 3,
    "no_of_books": 27,
    "nameE": "Leviticus",
    "nameT": "லேவியராகமம்"
  },
  {"book_no": 4, "no_of_books": 36, "nameE": "Numbers", "nameT": "எண்ணாகமம்"},
  {"book_no": 5, "no_of_books": 34, "nameE": "Deuteronomy", "nameT": "உபாகமம்"},
  {"book_no": 6, "no_of_books": 24, "nameE": "Joshua", "nameT": "யோசுவா"},
  {
    "book_no": 7,
    "no_of_books": 21,
    "nameE": "Judges",
    "nameT": "நியாயாதிபதிகள்"
  },
  {"book_no": 8, "no_of_books": 4, "nameE": "Ruth", "nameT": "ரூத்"},
  {"book_no": 9, "no_of_books": 31, "nameE": "1 Samuel", "nameT": "1 சாமுவேல்"},
  {
    "book_no": 10,
    "no_of_books": 24,
    "nameE": "2 Samuel",
    "nameT": "2 சாமுவேல்"
  },
  {
    "book_no": 11,
    "no_of_books": 22,
    "nameE": "1 Kings",
    "nameT": "1 இராஜாக்கள்"
  },
  {
    "book_no": 12,
    "no_of_books": 25,
    "nameE": "2 Kings",
    "nameT": "2 இராஜாக்கள்"
  },
  {
    "book_no": 13,
    "no_of_books": 29,
    "nameE": "1 Chronicles",
    "nameT": "1 நாளாகமம்"
  },
  {
    "book_no": 14,
    "no_of_books": 36,
    "nameE": "2 Chronicles",
    "nameT": "2 நாளாகமம்"
  },
  {"book_no": 15, "no_of_books": 10, "nameE": "Ezra", "nameT": "எஸ்றா"},
  {"book_no": 16, "no_of_books": 13, "nameE": "Nehemiah", "nameT": "நெகேமியா"},
  {"book_no": 17, "no_of_books": 10, "nameE": "Esther", "nameT": "எஸ்தர்"},
  {"book_no": 18, "no_of_books": 42, "nameE": "Job", "nameT": "யோபு"},
  {"book_no": 19, "no_of_books": 150, "nameE": "Psalms", "nameT": "சங்கீதம்"},
  {
    "book_no": 20,
    "no_of_books": 31,
    "nameE": "Proverbs",
    "nameT": "நீதிமொழிகள்"
  },
  {
    "book_no": 21,
    "no_of_books": 12,
    "nameE": "Ecclesiastes",
    "nameT": "பிரசங்கி"
  },
  {
    "book_no": 22,
    "no_of_books": 8,
    "nameE": "Song of Solomon",
    "nameT": "உன்னதப்பாட்டு"
  },
  {"book_no": 23, "no_of_books": 66, "nameE": "Isaiah", "nameT": "ஏசாயா"},
  {"book_no": 24, "no_of_books": 52, "nameE": "Jeremiah", "nameT": "எரேமியா"},
  {
    "book_no": 25,
    "no_of_books": 5,
    "nameE": "Lamentations",
    "nameT": "புலம்பல்"
  },
  {
    "book_no": 26,
    "no_of_books": 48,
    "nameE": "Ezekiel",
    "nameT": "எசேக்கியேல்"
  },
  {"book_no": 27, "no_of_books": 12, "nameE": "Daniel", "nameT": "தானியேல்"},
  {"book_no": 28, "no_of_books": 14, "nameE": "Hosea", "nameT": "ஓசியா"},
  {"book_no": 29, "no_of_books": 3, "nameE": "Joel", "nameT": "யோவேல்"},
  {"book_no": 30, "no_of_books": 9, "nameE": "Amos", "nameT": "ஆமோஸ்"},
  {"book_no": 31, "no_of_books": 1, "nameE": "Obadiah", "nameT": "ஒபதியா"},
  {"book_no": 32, "no_of_books": 4, "nameE": "Jonah", "nameT": "யோனா"},
  {"book_no": 33, "no_of_books": 7, "nameE": "Micah", "nameT": "மீகா"},
  {"book_no": 34, "no_of_books": 3, "nameE": "Nahum", "nameT": "நாகூம்"},
  {"book_no": 35, "no_of_books": 3, "nameE": "Habakkuk", "nameT": "ஆபகூக்"},
  {"book_no": 36, "no_of_books": 3, "nameE": "Zephaniah", "nameT": "செப்பனியா"},
  {"book_no": 37, "no_of_books": 2, "nameE": "Haggai", "nameT": "ஆகாய்"},
  {"book_no": 38, "no_of_books": 14, "nameE": "Zechariah", "nameT": "சகரியா"},
  {"book_no": 39, "no_of_books": 4, "nameE": "Malachi", "nameT": "மல்கியா"},
];

var newTestamentBooks = [
  {"book_no": 40, "no_of_books": 28, "nameE": "Matthew", "nameT": "மத்தேயு"},
  {"book_no": 41, "no_of_books": 16, "nameE": "Mark", "nameT": "மாற்கு"},
  {"book_no": 42, "no_of_books": 24, "nameE": "Luke", "nameT": "லுக்கா"},
  {"book_no": 43, "no_of_books": 21, "nameE": "John", "nameT": "யோவான்"},
  {"book_no": 44, "no_of_books": 28, "nameE": "Acts", "nameT": "அப்போஸ்தலர்"},
  {"book_no": 45, "no_of_books": 16, "nameE": "Romans", "nameT": "ரோமர்"},
  {
    "book_no": 46,
    "no_of_books": 16,
    "nameE": "1 Corinthians",
    "nameT": "1 கொரிந்தியர்"
  },
  {
    "book_no": 47,
    "no_of_books": 13,
    "nameE": "2 Corinthians",
    "nameT": "2 கொரிந்தியர்"
  },
  {
    "book_no": 48,
    "no_of_books": 6,
    "nameE": "Galatians",
    "nameT": "கலாத்தியர்"
  },
  {"book_no": 49, "no_of_books": 6, "nameE": "Ephesians", "nameT": "எபேசியர்"},
  {
    "book_no": 50,
    "no_of_books": 4,
    "nameE": "Philippians",
    "nameT": "பிலிப்பியர்"
  },
  {
    "book_no": 51,
    "no_of_books": 4,
    "nameE": "Colossians",
    "nameT": "கொலோசெயர்"
  },
  {
    "book_no": 52,
    "no_of_books": 5,
    "nameE": "1 Thessalonians",
    "nameT": "1 தெசலோனிக்கேயர்"
  },
  {
    "book_no": 53,
    "no_of_books": 3,
    "nameE": "2 Thessalonians",
    "nameT": "2 தெசலோனிக்கேயர்"
  },
  {
    "book_no": 54,
    "no_of_books": 6,
    "nameE": "1 Timothy",
    "nameT": "1 தீமோத்தேயு"
  },
  {
    "book_no": 55,
    "no_of_books": 4,
    "nameE": "2 Timothy",
    "nameT": "2 தீமோத்தேயு"
  },
  {"book_no": 56, "no_of_books": 3, "nameE": "Titus", "nameT": "தீத்து"},
  {"book_no": 57, "no_of_books": 1, "nameE": "Philemon", "nameT": "பிலேமோன்"},
  {"book_no": 58, "no_of_books": 13, "nameE": "Hebrews", "nameT": "எபிரெயர்"},
  {"book_no": 59, "no_of_books": 5, "nameE": "James", "nameT": "யாக்கோபு"},
  {"book_no": 60, "no_of_books": 5, "nameE": "1 Peter", "nameT": "1 பேதுரு"},
  {"book_no": 61, "no_of_books": 3, "nameE": "2 Peter", "nameT": "2 பேதுரு"},
  {"book_no": 62, "no_of_books": 5, "nameE": "1 John", "nameT": "1 யோவான்"},
  {"book_no": 63, "no_of_books": 1, "nameE": "2 John", "nameT": "2 யோவான்"},
  {"book_no": 64, "no_of_books": 1, "nameE": "3 John", "nameT": "3 யோவான்"},
  {"book_no": 65, "no_of_books": 1, "nameE": "Jude", "nameT": "யூதா"},
  {
    "book_no": 66,
    "no_of_books": 22,
    "nameE": "Revelation",
    "nameT": "வெளிப்படுத்தின விசேஷம்"
  },
];
