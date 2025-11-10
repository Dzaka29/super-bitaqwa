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

  final posterlist = const <String>[
    'assets/images/ramadan_karem.jpg',
    'assets/images/idul_fitri.jpg',
    'assets/images/idul_adha.jpg',
    'assets/images/afternon.jpg',
    'assets/images/morning.jpg',
    'assets/images/night.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
    return InkWell(
      onTap: () {},
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
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildMenuItem(
          'assets/images/ic_menu_doa.png',
          'Doa Harian',
          '/doa',
          ),
          _buildMenuItem(
          'assets/images/ic_menu_jadwal_sholat.png',
          'Jadwal Sholat',
          '/doa',
          ),
          _buildMenuItem(
            'assets/images/ic_menu_video_kajian.png',
            'Vidio Kajian',
            '/doa',
          ),
          _buildMenuItem(
            'assets/images/ic_menu_zakat.png',
            'Zakat',
            '/doa'
          ),
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
