import 'package:carrot_test/page/detail.dart';
import 'package:carrot_test/repository/contents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentLocation = "KIT";
  ContentsRepository contentsRepository = ContentsRepository();
  final Map<String, String> locationTypeToString = {
    "KIT": "키치너",
    "WTL": "워터루",
    "CAM": "캠브리지",
  };

  @override
  void initState() {
    super.initState();
  }

  final oCcy = new NumberFormat("#,###", "en_CAD");
  String calcStringToCAD(String priceString) {
    if (priceString == "Free") return priceString;
    return "${oCcy.format(int.parse(priceString))} CAD";
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      elevation: 1.0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.tune),
        ),
        IconButton(
          onPressed: () {},
          // icon: const Icon(Icons.tune),
          icon: SvgPicture.asset(
            "assets/svg/bell.svg",
            width: 20,
          ),
        )
      ],
      title: GestureDetector(
        onTap: () {
          print('clicked');
        },
        child: PopupMenuButton<String>(
          offset: Offset(0, 25),
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),
          onSelected: (String location) {
            print(location);
            setState(() {
              currentLocation = location;
            });
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text("키치너"),
                value: "KIT",
              ),
              PopupMenuItem(
                child: Text("워터루"),
                value: "WTL",
              ),
              PopupMenuItem(
                child: Text("캠브리지"),
                value: "CAM",
              ),
            ];
          },
          child: Row(
            children: [
              Text(locationTypeToString[currentLocation] ?? ''),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  _loadContents() {
    return contentsRepository.loadContentsFromLocation(currentLocation);
  }

  _makeDataList(List<Map<String, String>> data) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemBuilder: (BuildContext _context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return DetailContentView(
                data: data[index],
              );
            }));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Hero(
                    tag: data[index]["cid"].toString(),
                    child: Image.asset(
                      data[index]["image"].toString(),
                      width: 100.0,
                      height: 100.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Container(
                  // padding: const EdgeInsets.only(left: 20.0),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index]["title"].toString(),
                          style: TextStyle(fontSize: 15.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          data[index]["location"].toString(),
                          style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.black.withOpacity(0.7)),
                        ),
                        SizedBox(height: 5.0),
                        Text(calcStringToCAD(data[index]["price"].toString()),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/heart_on.svg",
                              width: 13.0,
                              height: 13.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(data[index]["likes"].toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext _context, int index) {
        return Container(height: 1.0, color: Colors.black.withOpacity(0.4));
      },
      itemCount: 2,
    );
  }

  Widget _bodyWidget() {
    return FutureBuilder(
        future: _loadContents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("데이터오류"),
            );
          }
          if (snapshot.hasData) {
            return _makeDataList(snapshot.data as List<Map<String, String>>);
          }

          return Center(
            child: Text("No data in this place"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
