// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:new_ucon/blocs/category/category_bloc.dart';
// import 'package:new_ucon/blocs/home/home_bloc.dart';
// import 'package:new_ucon/data/constants.dart';
// import 'package:new_ucon/models/producer_model.dart';
// import 'package:new_ucon/utils/actionHandler.dart';
// class ProducerCard extends StatelessWidget {
//   ProducerCard({Key? key,required this.sectionName}) : super(key: key);
//   String sectionName;
//   List<FocusNode> producerFocusList=[];
//   List<Producer> producerList=[];
//   int selectedProducer=0;
//   bool isFirst=true;
//   @override
//   Widget build(BuildContext context) {
//     if(isFirst){
//       ProducerClass producerClass = ProducerClass(sectionName);
//       producerList = sectionName != "Мультфильмы"
//           ? producerClass.movieProducers()
//           : producerClass.cartoonProducers();
//       producerFocusList =
//           List.generate(producerList.length, (index) => FocusNode());
//       if (sectionName == "Премьеры") {
//         BlocProvider.of<CategoryBloc>(context)
//             .add(UpdateCategoryMovieEvent(sectionName, 1));
//       } else {
//         BlocProvider.of<CategoryBloc>(context).add(UpdateCategoryMovieEvent(
//             producerList.first.link, 1));
//       }
//     }
//    return  Container(
//       height: 80,
//       child: ListView.builder(
//         shrinkWrap: true,
//         primary: false,
//         scrollDirection: Axis.horizontal,
//         itemCount: producerList.length,
//         itemBuilder: (context, index) {
//     return ClickRemoteActionWidget(
//       right: () {
//         if (index != (producerFocusList!.length - 1)) {
//           _changeFocus(context, producerFocusList[index + 1]);
//         }
//       },
//       up: () {
//         _changeFocus(context, backButtonFocus);
//       },
//       enter: () {
//           page = 1;
//           BlocProvider.of<HomeBloc>(context)
//               .add(UpdateCategoryMovieEvent(producerList[index].link, page));
//           selectedProducer = producerList[index];
//       },
//       left: () {
//         if (index != 0) {
//           _changeFocus(context, producerFocusList[index - 1]);
//         }
//       },
//       down: () {
//         _changeFocus(context, focusList.first);
//       },
//       child: Focus(
//         focusNode: producerFocusList![index],
//         child: Card(
//           elevation: 5.0,
//           clipBehavior: Clip.antiAlias,
//           color: Colors.transparent,
//           child: Container(
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//                 color: producerList[index].imageName == "newbie"
//                     ? Colors.orange
//                     :Colors.transparent,
//                 border: producerFocusList[index].hasFocus
//                     ? Border.all(color: Colors.yellow, width: 3)
//                     : Border.all(color: Colors.indigo, width: 3)),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 30,
//                     width: 120,
//                     child: SvgPicture.asset(
//                       "assets/images/" + producerList[index].imageName + ".svg",
//                       fit: BoxFit.scaleDown,
//                       height: 30,
//                       width: 120,
//                       color:  producerList[index].imageName == "newbie"
//                           ? Colors.black:Colors.white
//                       ,
//                       // height: 30,
//                       // width: 30,
//                     ),
//                   ),
//                 ),
//                 if (producerList[index].imageName == "newbie") ...[
//                   Text(
//                     "Новинки",
//                     style: TextStyle(color: Colors.black),
//                   )
//                 ] else if (producerList[index].imageName == "others") ...[
//                   Text(
//                     "Другие",
//                     style: TextStyle(color: Colors.white),
//                   )
//                 ]
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//         },
//       ),
//     );
//   }
// }
