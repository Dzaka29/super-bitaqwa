import 'dart:async'; //timer coundown
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; //carousel slider
import 'package:http/http.dart' as http; //ambil data API
import 'dart:convert'; //decode JSON
import 'package:geolocator/geolocator.dart'; //GPS
import 'package:geocoding/geocoding.dart'; //konversi GPS
import 'package:intl/intl.dart'; //Format Nummber
import 'package:permission_handler/permission_handler.dart'; //Izin Handler
import 'package:shared_preferences/shared_preferences.dart'; // cache lokal
import 'package:string_similarity/string_similarity.dart'; // fuzzy match string

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;
  bool _isLoading = true;
  Duration? _timeRemaining;
  Timer? _counddownTimer;
  String _location = 'Mengambil Lokasi....';
  String _prayTime = 'Loading....';
  String _backgroundImage = 'assets/images/morning.jpg';
  List<dynamic>? _jadwalSholat;

  //Fingsi text remaining waktu sholat
  String _formatDuration(Duration d) {
    final hours  = d.inHours;
    final minute = d.inMinutes.remainder(60);
    return "$hours jam $minute menit lagi";
  }
  

  final posterlist = const <String>[
    'assets/images/ramadan_karem.jpg',
    'assets/images/idul_fitri.jpg',
    'assets/images/idul_adha.jpg',
    'assets/images/afternon.jpg',
    'assets/images/morning.jpg',
    'assets/images/night.jpg',
  ];

  //state untuk dijalankan diawal
  @override
  void initState() {
    super.initState();
  }
  

  Future<String> _getBackgroundImage(DateTime now) async {
    if (now.hour < 12) {
      return 'assets/images/morning.jpg';
    } else if (now.hour < 18) {
      return 'assets/images/afternon.jpg';
    }
    return 'assets/images/night.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //=========================================
              //[MENU WAKTU SHOLAT BY LOKASI]
              //=========================================
              _buildHeroSection(),
              const SizedBox(
                height: 65,

                ),
              // ========================================
              //[menu GRID SECTION]
              // ========================================
              _buildGridMenuSection(),
              //=========================================
              //[CAROSEUL SECTION]
              //=========================================
              _buildCaroucelSection(),
            ],
          ),
        ),
      ),
    );
  }
  //=========================================
  //[MENU HERO WIDGET]
  //=========================================
  Widget _buildHeroSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 290,
          decoration: BoxDecoration(
            color: Color(0xFFB3E5FC),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30)
            ),
            image: DecorationImage(image: AssetImage('${_getBackgroundImage(DateTime.now())}'),
            fit: BoxFit.cover)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Assalamu\'alaikum',
                  style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    color: Colors.white70,
                    fontSize: 16
                  ),
                ),
                Text(
                  'Ngargoyoso',
                  style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                Text(
                DateFormat('HH:mm').format(DateTime.now()),
                style: TextStyle(
                  fontFamily: 'PoppinsBold',
                  fontSize: 50,
                  height: 1.2,
                  color: Colors.white
                  ),
                )
              ],
            ),
          ),
        ),
        //======[WAKTU SHOLAT]=======
        Positioned(
          bottom: -55,
          left: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(
                blurRadius: 2,
                offset: Offset(0, 4),
                color: Colors.amber.withOpacity(0.4)
                )
              ]
            ),
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 14
            ),
            child: Column(
              children: [
                Text(
                  'Waktu Sholat Selanjutnya',
                  style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Ashar',
                  style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    color: Colors.amber,
                    fontSize: 20
                  ),
                ),
                Text(
                  '14:22',
                  style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 28,
                    color: Colors.black38
                  ),
                ),
                Text(
                  '5 Jam 10 Menit',
                  style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    fontSize: 13,
                    color: Colors.grey
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
  //=========================================
  //[MENU ITEM WIDGET]
  //=========================================
  Widget _buildMenuItem(
    String iconPath,
    String tittle,
    String routeName,
  )
  {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.amber.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow:[
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
              ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, width: 35,),
              const SizedBox(height: 6,),
              Text(
                tittle,
                style: TextStyle(
                  fontFamily: 'PoppinsRegular',
                  fontSize: 13,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  // ========================================
  //[menu GRID SECTION]
  // ========================================
  Widget _buildGridMenuSection(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildMenuItem(
          'assets/images/ic_menu_doa.png',
          'Doa',
          '/doa',
          ),
          _buildMenuItem(
          'assets/images/ic_menu_jadwal_sholat.png',
          'Sholat',
          '/doa',
          ),
          _buildMenuItem(
            'assets/images/ic_menu_video_kajian.png',
            'Kajian',
            '/doa',
          ),
          _buildMenuItem(
            'assets/images/ic_menu_zakat.png',
            'Zakat',
            '/doa'
          ),
          _buildMenuItem(
            'assets/images/ic_menu_doa.png',
            'Khuttbah',
            '/doa',)
        ],
      ),
    );
  }

  //====================
  //[CAROUSEL SECTION]
  //====================

  Widget _buildCaroucelSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        CarouselSlider.builder(
          itemCount: posterlist.length,
          itemBuilder: (context, index, realindex) {
            final poster = posterlist[index];
            return Container(
              margin: EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.asset(
                  poster,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            height: 300,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: posterlist.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _currentIndex.animateToPage(entry.key),
              child: Container(
                width: 10,
                height: 10,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _currentIndex == entry.key
                      ? Colors.amberAccent
                      : CupertinoColors.tertiarySystemBackground,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

extension on int {
  void animateToPage(int key) {}
}
