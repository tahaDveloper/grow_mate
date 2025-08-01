import 'package:get/get.dart';

class BottomSheetController extends GetxController {
  var checkList = <bool>[false, false, false, false,false,false].obs;

  RxInt selectIndex = (-1).obs;

  void toggleCheck(int index) {
    if(selectIndex.value == index){
      selectIndex.value = -1;
    }
    else{
      selectIndex.value = index;
    }
  }
}
