import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/menu_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/confirmation_dialog.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/favourite/favourite_screen.dart';
import 'package:sixam_mart/view/screens/order/order_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MenuButtonSec extends StatelessWidget {
  final MenuModel menu;
  final bool isProfile;
  final bool isLogout;
  MenuButtonSec({@required this.menu, @required this.isProfile, @required this.isLogout});

  @override
  Widget build(BuildContext context) {
    int _count = ResponsiveHelper.isDesktop(context) ? 8 : ResponsiveHelper.isTab(context) ? 6 : 4;
    double _size = ((context.width > Dimensions.WEB_MAX_WIDTH ? Dimensions.WEB_MAX_WIDTH : context.width)/_count)-Dimensions.PADDING_SIZE_DEFAULT;

    return InkWell(
      onTap: () async {
        if(isLogout) {
          Get.back();
          if(Get.find<AuthController>().isLoggedIn()) {
            Get.dialog(ConfirmationDialog(icon: Images.support, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: () {
              Get.find<AuthController>().clearSharedData();
              Get.find<CartController>().clearCartList();
              Get.find<WishListController>().removeWishes();
              Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
            }), useSafeArea: false);
          }else {
            Get.find<WishListController>().removeWishes();
            Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
          }
        }else if(menu.route.startsWith('http')) {
          if(await canLaunchUrlString(menu.route)) {
            launchUrlString(menu.route);
          }
        }else {
          try {
            if(menu.route=="/order"){
              Get.to(OrderScreen());
            }
            else if(menu.route=="/favourite"){
              Get.to(FavouriteScreen());
            }
            else
            Get.toNamed(menu.route);
          }catch(r){
            print(r.toString());
          }
        }
      },
      child: Row(children: [

        Container(
          height: _size-(_size*0.3),
          padding: EdgeInsets.only(left: 20,top: 2,bottom: 0,right: 10),
          //margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          //   color: isLogout ? Get.find<AuthController>().isLoggedIn() ? Colors.red : Colors.green : Theme.of(context).primaryColor,
          //   boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
          // ),
          alignment: Alignment.center,
          child: isProfile ? ProfileImageWidget(size: _size) : Image.asset(menu.icon, width: _size*0.35, height: _size*0.35, color: Colors.white),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        Text(menu.title, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.white), textAlign: TextAlign.center),

      ]),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  final double size;
  ProfileImageWidget({@required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: Colors.white)),
        child: ClipOval(
          child: CustomImage(
            image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                '/${(userController.userInfoModel != null && Get.find<AuthController>().isLoggedIn()) ? userController.userInfoModel.image ?? '' : ''}',
            width:size*0.40, height: size*0.40, fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}

