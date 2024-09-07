



import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';
import 'package:virtuozy/components/text_fields.dart';
import 'package:virtuozy/domain/entities/edit_profile_entity.dart';
import 'package:virtuozy/domain/entities/subway_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/presentations/student/profile_screen/bloc/profile_bloc.dart';
import 'package:virtuozy/presentations/student/profile_screen/bloc/profile_event.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/date_time_parser.dart';
import 'package:virtuozy/utils/theme_provider.dart';

import '../../../components/buttons.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../utils/preferences_util.dart';
import '../../../utils/text_style.dart';
import 'bloc/profile_state.dart';

 class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

   @override
   _UserProfilePageState createState() => _UserProfilePageState();
 }

 class _UserProfilePageState extends State<UserProfilePage> {

   String name = "";
   String gender = "";
   bool hasChildren = false;
   bool _edit = false;
   File? _imageFile;
   bool _editPhotoMode = false;
   EditProfileEntity profileEntity = EditProfileEntity.unknown();



   Future<void> _pickImage(bool galery) async {
     final pickedFile = await ImagePicker().pickImage(source:
      galery?ImageSource.gallery:ImageSource.camera);
     if (pickedFile != null) {
       setState(() {
        _imageFile = File(pickedFile.path);
        profileEntity = profileEntity.copyWith(fileImageUrl: _imageFile);
        _edit = true;
        _editPhotoMode = false;
       });
     }
   }


   @override
  void initState() {
  super.initState();
  context.read<ProfileBloc>().add(const GetDataUserProfileEvent());
  }

  @override
   Widget build(BuildContext context) {

    final h = MediaQuery.of(context).size.height;

     return Scaffold(
       body: BlocConsumer<ProfileBloc,ProfileState>(
         listener: (c,s){
           if(s.profileStatus == ProfileStatus.error){
             Dialoger.showMessage(s.error);
           }
           if(s.profileStatus == ProfileStatus.saved){
             _edit = false;
             Dialoger.showActionMaterialSnackBar(context: context, title: 'Изменения сохранены'.tr());
           }

           if(s.profileStatus == ProfileStatus.loaded ||
               s.profileStatus == ProfileStatus.saved){
             profileEntity = EditProfileEntity(
               whoFindTeem: s.userEntity.who_find,
                 fileImageUrl: _imageFile,
                 sex: s.userEntity.sex,
                 dateBirth: s.userEntity.date_birth,
                 hasKind: s.userEntity.has_kids,
                 urlAva: s.userEntity.avaUrl,
                 subways: s.userEntity.subways,
                 aboutMe: s.userEntity.about_me);

           }
         },
         builder: (context,state) {

           if(state.profileStatus == ProfileStatus.loading){
             return Center(child: CircularProgressIndicator(color: colorOrange));
           }

          if(state.profileStatus == ProfileStatus.loaded){
            return IgnorePointer(
              ignoring: state.profileStatus == ProfileStatus.saving,
              child: SingleChildScrollView(
                padding:  EdgeInsets.only(top: h/12,right: 20,left: 20),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(onPressed: (){
                        Navigator.pop(context);
                      },
                        icon: Icon(Platform.isAndroid?Icons.arrow_back_rounded:
                        Icons.arrow_back_ios_new_rounded),),
                    ),
                    BodyInfoUser(
                      key: ValueKey(_edit),
                        user: state.userEntity,
                        edit: _edit,
                        profileEdit: profileEntity,
                        state: state),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          if(_editPhotoMode){
                            _editPhotoMode = false;
                          }else{
                            _editPhotoMode = true;
                          }

                        });
                      },
                      child: SizedBox(
                        width: 240,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Visibility(
                              visible: _editPhotoMode,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: colorOrange,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(onPressed: (){
                                      _pickImage(true);
                                    },
                                        icon: Icon(Icons.image_rounded,color: colorWhite)),
                                    IconButton(onPressed: (){
                                      _pickImage(false);
                                    },
                                        icon: Icon(Icons.camera_alt_outlined,color: colorWhite))
                                  ],
                                ),
                              ).animate().fadeIn(duration: const Duration(milliseconds: 700)),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorOrange,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: _getAvatar(_imageFile,state.userEntity.avaUrl),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 65,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorOrange,
                                    border: Border.all(color: colorWhite,width: 1.5)
                                ),
                                child: Icon(_editPhotoMode?Icons.close:
                                Icons.edit,color: colorWhite,size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );

          }

           return Container();
         }
       ),
     );
   }



   Widget _getAvatar(File? imageFile,String urlAva){
     ImageProvider image = NetworkImage(urlAva);
     if(imageFile==null){
       if(urlAva.isEmpty){
         return SizedBox(
           width: 100,
             height: 100,
             child: Icon(Icons.image_search_rounded,color: colorWhite,size: 40,));
       }else{

         return Container(
           width: 100,
           height: 100,
           decoration: const BoxDecoration(
             shape: BoxShape.circle,
           ),
           child: ClipOval(
             child: CachedNetworkImage(
               fit: BoxFit.cover,
               imageUrl: urlAva,
               progressIndicatorBuilder: (context, url, downloadProgress) =>
                   CircularProgressIndicator(value: downloadProgress.progress,color: colorWhite),
               errorWidget: (context, url, error) => const Icon(Icons.error),
             ),
           ),
         );
         image = NetworkImage(urlAva);
         return CircleAvatar(
           radius: 50,
           foregroundImage: image,
           child: Icon(Icons.hourglass_empty,color: colorWhite.withOpacity(0.5)),
         );
       }
     }else{
       image = FileImage(imageFile);
       return CircleAvatar(
         radius: 50,
         foregroundImage: image,
         child: Icon(Icons.hourglass_empty,color: colorWhite.withOpacity(0.5)),
       );
     }


   }
 }


   class BodyInfoUser extends StatefulWidget{
   BodyInfoUser({super.key, required this.user,  required this.edit, required this.profileEdit, required this.state});

  final UserEntity user;
  final ProfileState state;
   bool edit;
   EditProfileEntity profileEdit;


  @override
  State<BodyInfoUser> createState() => _BodyInfoUserState();
}

class _BodyInfoUserState extends State<BodyInfoUser>{


  String _dateBirth = '';
  List<SubwayEntity> _subways = [];
  bool _edit = false;
  late TextEditingController _whoFindController;
  late TextEditingController _aboutMiController;
  EditProfileEntity _profileEdited = EditProfileEntity.unknown();


  @override
  void initState() {
    super.initState();
   _dateBirth = widget.profileEdit.dateBirth;
   _subways = widget.profileEdit.subways;

   _edit = widget.edit;
  _profileEdited = widget.profileEdit;
   _aboutMiController = TextEditingController(text: widget.user.about_me.isEmpty?'Нет данных':widget.user.about_me);
   _whoFindController = TextEditingController(text: widget.user.who_find.isEmpty?'Нет данных':widget.user.who_find);

  }


  @override
  void dispose() {
    super.dispose();
    _whoFindController.dispose();
    _aboutMiController.dispose();
  }

  bool _fullDataProfile(EditProfileEntity profileEntity){
    bool fullData = false;
    if(profileEntity.sex.isNotEmpty&&profileEntity.dateBirth.isNotEmpty&&profileEntity.urlAva.isNotEmpty){
      fullData = true;
    }
    return fullData;
  }

  Color _getColorSubway(String color){
    final code = '#$color';
    return  Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return              BlocConsumer<ProfileBloc,ProfileState>(
      listener: (c,s){


        if(s.findSubwaysStatus == FindSubwaysStatus.added){
          if(!_subways.contains(s.addedSubway)){
            _edit = true;
            _subways.add(s.addedSubway);
            _profileEdited = _profileEdited.copyWith(subways: _subways);
          }
        }




      },
      builder: (context,state) {
        final theme=PreferencesUtil.getTheme;

        return Column(

          children: [
            Container(
              margin:  const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.only(right: 20,left: 20,top: 70,bottom: 20),
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20.0)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile picture with edit button
                 Center(
                   child: Text('${widget.user.firstName} ${widget.user.lastName}',
                   textAlign: TextAlign.center,
                   style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),),
                 ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_enabled_rounded,color: textColorBlack(context),
                          size: 12.0),
                      const Gap(5.0),
                      Text(widget.user.phoneNumber,
                          style: TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                    ],
                  ),
                   Center(child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 100,vertical: 5),
                     child: Divider(color: colorGrey),
                   )),
                  const Gap(10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Часто посещаемые станции метро:'.tr(),style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                      const Gap(8.0),
                    Column(
                      key: ValueKey(_subways),
                      children: [
                        ...List.generate(_subways.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme == ThemeStatus.dark?null:colorWhite,
                                    border: Border.all(color:
                                    _getColorSubway( _subways[index].color),
                                        width: 1 )
                                  ),
                                  padding: const EdgeInsets.all(2),
                                 margin: const EdgeInsets.only(top: 3),
                                  child:  Icon(Icons.directions_subway,
                                      color: _getColorSubway( _subways[index].color),
                                      size: 14),
                                ),
                                                                    const Gap(10),
                                                                    SizedBox(
                                 width: MediaQuery.of(context).size.width-130,
                                 child: Text(
                                   _subways[index].name,
                                   style: TStyle.textStyleVelaSansBold(
                                       Theme.of(context)
                                           .textTheme
                                           .displayMedium!
                                           .color!,
                                       size: 18),
                                 ),
                                                                    ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _edit = true;
                                          if(_subways.length>1){
                                            print('Remove 1');
                                            _subways.removeAt(index);
                                          }else if(_subways.length==1){
                                            print('Remove 2');
                                            _subways.clear();
                                          }

                                          _profileEdited = _profileEdited.copyWith(subways: _subways);
                                        });
                                      },
                                      child: Icon(Icons.remove_circle_outline,size: 16,color: colorRed)),
                                )
                              ],
                            ),
                          );
                        })
                      ],
                    ),
                      const Gap(10),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: colorGrey,width: 1.5),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Добавить станцию'.tr(),style: TStyle.textStyleVelaSansMedium(colorGrey)),
                                const Gap(5),
                                Icon(
                                  Icons.add,
                                  color: colorGrey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Dialoger.showBottomMenu(
                                title: 'Добавить станцию'.tr(),
                                context: context,
                                content: FindSubways());
                          },
                        ),
                      )


                    ],
                  ),
                  const Gap(13.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text('Кого ищу себе в группу (в напарники, в бенд)?',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                      ),
                      const Gap(5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextEdit(controller: _whoFindController,
                          onChanged: (text){
                            setState(() {
                              _edit= true;
                              _profileEdited = _profileEdited.copyWith(whoFindTeem: text);

                            });
                          },)
                          // Text(widget.user.who_find.isEmpty?'Нет данных':widget.user.who_find,
                          //   style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),),
                          //Icon(Icons.edit,color: colorGrey,size: 16,)
                        ],
                      ),
                    ],
                  ),
                  const Gap(10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('О себе:',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                     const Gap(5.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextEdit(controller: _aboutMiController,
                          onChanged: (text){
                            setState(() {
                              _edit= true;
                              _profileEdited= _profileEdited.copyWith(aboutMe: text);
                            });
                          },),
                        ],
                      )
                      // const Gap(8.0),
                      // Text(widget.user.about_me,
                      //   style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Пол:',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                      const Gap(10),
                      if(widget.user.sex.isNotEmpty)...{
                        Text(widget.user.sex == 'man'?'Муж.':'Жен.',
                          style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),)
                      }else...{
                         Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: SelectSexMenu(
                            onChangeSex: (sex){
                              setState(() {
                                _profileEdited = _profileEdited.copyWith(
                                    sex: sex == 'Муж.'?'man':sex == 'Не выбран'?'':'woman');
                                _edit= true;
                              });
                            },
                          ),
                        )

                      }
                    ],
                  ),
                  const Gap(10.0),
                  GestureDetector(
                    onTap: () async {

                      DateTime? pickedDate = await showDatePicker(
                            context: context,
                            useRootNavigator: false,
                            initialDate: DateTime.now(), //get today's date
                            firstDate:DateTime(1945), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101)
                        );
                        if(pickedDate==null) return;
                        setState(() {
                          _edit= true;
                          _dateBirth = DateTimeParser.getDateToApi(dateNow: pickedDate);
                          _profileEdited = _profileEdited
                              .copyWith(dateBirth: _dateBirth);
                        });

                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Дата рождения:',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                              Visibility(
                                visible: true,
                                child:Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: Icon(Icons.calendar_month,color: colorGrey,size: 18),
                                )),

                            ],
                          ),
                        ),
                        //todo если не указан то выбор через меню
                        const Gap(8.0),
                        Text(
                          _dateBirth.isEmpty
                              ? 'Не указана'
                              : DateTimeParser.getDateFromApi(date: _dateBirth),
                          style: TStyle.textStyleVelaSansBold(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 18),
                        )
                      ],
                    ),
                  ),
                  const Gap(10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Дата регистрации:',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                      const Gap(8.0),
                      Text(DateTimeParser.getDateFromApi(date: widget.user.registration_date),
                        style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),),
                    ],
                  ),
                  const Gap(10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Наличие детей:',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                      const Gap(10.0),
                       SelectKidsMenu(
                         hasKind: widget.user.has_kids,
                         onKind: (hasKind){
                           setState(() {
                             _edit = true;
                             _profileEdited = _profileEdited.copyWith(hasKind: hasKind as bool);
                           });
                       },)
                    ],
                  ),




                  const Gap(30.0),
                  if( widget.state.profileStatus == ProfileStatus.saving)...{
                    Center(child: CircularProgressIndicator(color: colorOrange))
                  }else ...{
                    SizedBox(
                      height: 40.0,
                      child: Opacity(
                        opacity: !_edit?0.3:1.0,
                        child: SubmitButton(
                            borderRadius: 8,
                            textButton: 'Сохранить изменения'.tr(),
                            onTap: () {
                              if(_edit){
                                context.read<ProfileBloc>().add(SaveNewDataUserEvent(editProfileEntity: _profileEdited));
                              }
                            }
                        ),
                      ),
                    )

                  }
                ],
              ),
            ),
            Visibility(
              visible: !_fullDataProfile(_profileEdited),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 47.0),
                      child: Text('Внимание!',style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
                    ),
                    const Gap(5.0),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: colorOrange.withOpacity(0.2),
                              shape: BoxShape.circle
                          ),
                          child: Icon(Icons.electric_bolt,color: colorOrange),
                        ),
                        const Gap(15.0),
                        Expanded(child: Text('Заполни карточку целиком - получи БОНУСНЫЙ УРОК!',
                            style: TStyle.textStyleVelaSansRegular(colorGrey,size: 14.0))),
                      ],
                    ),

                  ],
                ),
              ),
            )
          ],
        );
      }
    );
  }

}


 class SelectKidsMenu extends StatefulWidget{
   const SelectKidsMenu({super.key, required this.hasKind, required this.onKind});

   final bool hasKind;
   final Function onKind;

   @override
   State<SelectKidsMenu> createState() => _SelectKidsMenuState();
 }

 class _SelectKidsMenuState extends State<SelectKidsMenu> {

   final List<String> itemsKids = [
     'Да',
     'Нет',
   ];
   String? selectedValueKids;
   bool _openMenu = false;


   @override
   void initState() {
     super.initState();
     selectedValueKids = widget.hasKind?itemsKids[0]:itemsKids[1];
   }

   @override
   Widget build(BuildContext context) {
     return DropdownButtonHideUnderline(
       child: DropdownButton2<String>(
         isExpanded: true,
         hint:  Text(selectedValueKids!,
             textAlign: TextAlign.center,
             style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                 .textTheme.displayMedium!.color!,size: 13.0)),
         items: itemsKids
             .map((String item) => DropdownMenuItem<String>(
           value: item,
           child: Text(
             item,
             style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                 .textTheme.displayMedium!.color!,size: 13.0),
             overflow: TextOverflow.ellipsis,
           ),
         ))
             .toList(),
         value: selectedValueKids,
         onChanged: (value) {
           setState(() {
             selectedValueKids = value;
             widget.onKind.call(selectedValueKids=='Да'?true:false);
           });
         },
         onMenuStateChange: (open){
           setState(() {
             _openMenu = open;
           });
         },
         buttonStyleData: ButtonStyleData(
           width: 75,
           padding:const EdgeInsets.symmetric(horizontal: 13.0),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(20.0),
             color:Theme.of(context).colorScheme.surfaceContainerHighest,
           ),
           //elevation: 2,
         ),
         iconStyleData:  IconStyleData(
           icon: RotatedBox(
             quarterTurns: _openMenu?4:2,
             child: const Icon(
               Icons.arrow_drop_down_rounded,
             ),
           ),
           iconSize: 18,
           iconEnabledColor: colorGrey,
           iconDisabledColor: Theme.of(context)
               .textTheme.displayMedium!.color!,
         ),
         dropdownStyleData: DropdownStyleData(
           maxHeight: 300,
           width: 75,
           elevation: 0,
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(20.0),
             color: colorGrey,
           ),
           offset: const Offset(0,-10),
           scrollbarTheme: ScrollbarThemeData(
             radius: const Radius.circular(40),
             thickness: MaterialStateProperty.all(6),
             thumbVisibility: MaterialStateProperty.all(true),
           ),
         ),
         menuItemStyleData: const MenuItemStyleData(
           height: 30,
           padding: EdgeInsets.only(left: 14, right: 14),
         ),
       ),
     );
   }
 }

 class SelectSexMenu extends StatefulWidget{
   const SelectSexMenu({super.key, required this.onChangeSex});

   final Function onChangeSex;

   @override
   State<SelectSexMenu> createState() => _SelectSexMenuState();
 }

 class _SelectSexMenuState extends State<SelectSexMenu> {

   final List<String> itemsSex = [
     'Не выбран',
     'Муж.',
     'Жен.',
   ];
   String? selectedValue;


   @override
   void initState() {
     super.initState();
     selectedValue = itemsSex[0];
   }

   @override
   Widget build(BuildContext context) {
     return DropdownButtonHideUnderline(
       child: DropdownButton2<String>(
         isExpanded: true,
         hint:  Text(selectedValue!,
             textAlign: TextAlign.center,
             style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                 .textTheme.displayMedium!.color!,size: 13.0)),
         items: itemsSex
             .map((String item) => DropdownMenuItem<String>(
           value: item,
           child: Text(
             item,
             style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                 .textTheme.displayMedium!.color!,size: 13.0),
             overflow: TextOverflow.ellipsis,
           ),
         ))
             .toList(),
         value: selectedValue,
         onChanged: (value) {
           setState(() {
             selectedValue = value;
             widget.onChangeSex.call(selectedValue);
           });
         },
         buttonStyleData: ButtonStyleData(
           width: 120,
           padding:const EdgeInsets.symmetric(horizontal: 13.0),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(20.0),
             color:Theme.of(context).colorScheme.surfaceContainerHighest,
           ),
           //elevation: 2,
         ),
         iconStyleData:  IconStyleData(
           icon: const Icon(
             Icons.arrow_drop_down_rounded,
           ),
           iconSize: 18,
           iconEnabledColor: colorGrey,
           iconDisabledColor: Theme.of(context)
               .textTheme.displayMedium!.color!,
         ),
         dropdownStyleData: DropdownStyleData(
           maxHeight: 400,
           width: 120,
           elevation: 0,
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(20.0),
             color: colorGrey,
           ),
           offset: const Offset(0,-10),
           scrollbarTheme: ScrollbarThemeData(
             radius: const Radius.circular(40),
             thickness: MaterialStateProperty.all(6),
             thumbVisibility: MaterialStateProperty.all(true),
           ),
         ),
         menuItemStyleData: const MenuItemStyleData(
           height: 30,
           padding: EdgeInsets.only(left: 14, right: 14),
         ),
       ),
     );
   }
 }

