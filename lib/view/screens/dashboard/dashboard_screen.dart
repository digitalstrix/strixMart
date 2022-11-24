import 'dart:async';

import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/cart_widget.dart';
import 'package:sixam_mart/view/screens/cart/cart_screen.dart';
import 'package:sixam_mart/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:sixam_mart/view/screens/favourite/favourite_screen.dart';
import 'package:sixam_mart/view/screens/home/home_screen.dart';
import 'package:sixam_mart/view/screens/menu/menu_screen.dart';
import 'package:sixam_mart/view/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({@required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;
  final zoomDrawerController = ZoomDrawerController();

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      HomeScreen(),
      //FavouriteScreen(),
      CartScreen(fromNav: true),
    //  OrderScreen(),
      Container(),
    ];

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if(!ResponsiveHelper.isDesktop(context) && Get.find<SplashController>().module != null) {
            Get.find<SplashController>().setModule(null);
            return false;
          }else {
            if(_canExit) {
              return true;
            }else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('back_press_again_to_exit'.tr, style: TextStyle(color: Colors.white)),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              ));
              _canExit = true;
              Timer(Duration(seconds: 2), () {
                _canExit = false;
              });
              return false;
            }
          }
        }
      },
      child:ZoomDrawer(

        controller: zoomDrawerController,
      //  style: DrawerStyle.style4,
menuBackgroundColor: Color.fromARGB(255, 255, 174, 103),

        menuScreen:MenuScreen() ,

        borderRadius: 24.0,
        showShadow: false,
        angle: 0.0,
       // drawerShadowsBackgroundColor: Colors.red[300],
        slideWidth: MediaQuery.of(context).size.width * 0.60,

        mainScreen:



      //
      Scaffold(
        key: _scaffoldKey,

        floatingActionButton: ResponsiveHelper.isDesktop(context) ? null : FloatingActionButton(
          elevation: 5,
          backgroundColor: _pageIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
          onPressed: () => _setPage(1),
          child: CartWidget(color: _pageIndex == 2 ? Theme.of(context).cardColor : Theme.of(context).disabledColor, size: 30),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: ResponsiveHelper.isDesktop(context) ? SizedBox() : BottomAppBar(
          elevation: 5,
          notchMargin: 5,
          clipBehavior: Clip.antiAlias,
          shape: CircularNotchedRectangle(),

          child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Row(children: [
              BottomNavItem(iconData: Icons.home, isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
             // BottomNavItem(iconData: Icons.favorite, isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
              Expanded(child: SizedBox()),
            //  BottomNavItem(iconData: Icons.shopping_bag, isSelected: _pageIndex == 3, onTap: () => _setPage(3)),
              BottomNavItem(iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () {
if(zoomDrawerController.isOpen()){
 zoomDrawerController.close();
}
else
  zoomDrawerController.open();
              //  Get.bottomSheet(MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
              }),
            ]),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    ));
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
