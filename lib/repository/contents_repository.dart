class ContentsRepository {
  Map<String, dynamic> data = {
    "KIT": [
      {
        "cid": "1",
        "image": "assets/images/ora-1.jpg",
        "title": "축구화 275",
        "location": "키치너",
        "price": "300",
        "likes": "3",
      },
      {
        "cid": "2",
        "image": "assets/images/ora-2.jpg",
        "title": "갈비",
        "location": "워터루",
        "price": "100000",
        "likes": "2",
      },
    ],
    "WTL": [
      {
        "cid": "1",
        "image": "assets/images/level-1.jpg",
        "title": "축구화 275",
        "location": "키치너",
        "price": "300",
        "likes": "3",
      },
      {
        "cid": "2",
        "image": "assets/images/level-2.jpg",
        "title": "갈비",
        "location": "워터루",
        "price": "100000",
        "likes": "2",
      },
    ],
    "CAM": [
      {
        "cid": "1",
        "image": "assets/images/ora-1.jpg",
        "title": "축구화 275",
        "location": "키치너",
        "price": "Free",
        "likes": "3",
      },
      {
        "cid": "2",
        "image": "assets/images/ora-2.jpg",
        "title": "갈비",
        "location": "워터루",
        "price": "100000",
        "likes": "2",
      },
    ],
  };
  Future<List<Map<String, String>>> loadContentsFromLocation(
      String location) async {
    // API 통신 location값을 보내주면서
    await Future.delayed(Duration(microseconds: 1000));
    return data[location];
  }
}
