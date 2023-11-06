import 'package:app/widgets/big_text.dart';
import 'package:app/widgets/icon_and_text_widget.dart';
import 'package:app/widgets/small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPagevalue = 0.0; //Variable to give a brief idea about when the page change happened
  double _scaleFactor = 0.8;
  double _height = 220;

   @override // (HERE WE CHECK HOW WE SWITCH TO DIFF PAGE)
   void initState(){//INITIALIZE NECESSARY ITEMS -----> initstate
     super.initState();
     pageController.addListener((){
       setState((){
        _currPagevalue = pageController.page!; //Checks if value doesn't get NULL
        // print("current value is "+ _currPagevalue.toString());

       });
     });
   }

   @override
   void dispose(){//Dispose every thing when y leave the page to avoid memory leaks
     pageController.dispose();
   }


  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.redAccent,
      height: 320,
      child: PageView.builder(
        controller: pageController,
          itemCount: 5, //Total 5 pages
          itemBuilder: (context, position){
        return _buildPageItem(position);
      }),
    );
  }

  Widget _buildPageItem(int index){//This holds the pages
     Matrix4 matrix = new Matrix4.identity();//scaling across the axis is done here

     //when index value match currpagevalue size along y axis is decreased on both +1 and -1 index values
     if(index == _currPagevalue.floor()){
       var currScale = 1 - (_currPagevalue - index) * (1 - _scaleFactor); //Main one will be at 1
       var currTrans = _height* ( 1 - currScale)/2;
       matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0); // X   Y   Z axis  (The change in view is only in Y axis)

     }
     else if(index == _currPagevalue.floor() + 1){ //For right side page that is visible
       var currScale = _scaleFactor + (_currPagevalue - index+1) * (1 - _scaleFactor); //Right side will be shown at 0.8
       var currTrans = _height* ( 1 - currScale)/2;
       matrix = Matrix4.diagonal3Values(1, currScale, 1);
       matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
     }
     else if(index == _currPagevalue.floor() - 1){ //For left side page that is visible
       var currScale = 1 - (_currPagevalue - index) * (1 - _scaleFactor); //Left side will be shown at 0.8
       var currTrans = _height* ( 1 - currScale)/2;
       matrix = Matrix4.diagonal3Values(1, currScale, 1);
       matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
     }
     else{
       var currScale = 0.8;
       matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _height*(1-_scaleFactor)/2, 0);
     }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container( //Property and img of the pages (PICHE WALA)
            height: 220,
            margin: EdgeInsets.only(left: 12, right: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: index.isEven? Color(0xFF69c5df) : Color(0xFF9294cc),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                        "assets/image/food1.jpg"
                    )
                )
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container( //The top overlapping box that holds details of the page
              height: 120,
              margin: EdgeInsets.only(left: 30, right: 30,bottom: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(0,5)
                    )
                  ]


              ),
              child: Container(
                padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(text: "Chinese Side"),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Wrap(
                          children: List.generate(5, (index) => Icon(Icons.star,color: AppColors.mainColor,size: 15,)),
                        ),
                        SizedBox(width: 10,),
                        SmallText(text: "4.2"),
                        SizedBox(width: 10,),
                        SmallText(text: "1270"),
                        SizedBox(width: 10,),
                        SmallText(text: "Reviews")
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        IconANdTextWidget(icon: Icons.circle_sharp,
                            text: "Normal",
                            iconColor: AppColors.iconColor1),

                        IconANdTextWidget(icon: Icons.location_on,
                            text: "Normal",
                            iconColor: AppColors.mainColor),

                        IconANdTextWidget(icon: Icons.access_time_rounded,
                            text: "32 Min",
                            iconColor: AppColors.iconColor1),

                      ],
                    )
                  ],
                ),
              ),

            ),
          )
        ],
      ),
    );
  }
}
