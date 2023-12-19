// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get GREENBRIDGELOGIN;
  String get Voiceofusers;

  String get Voiceofusers2;

  String get Add;

  String get Content;

  String get Writethetitlemax80letters;

  String get Pleasewriteheremax1500letters;

  String get Addimages;

  String get Save;
  String get Save2;

  String get Areyousureyouwanttodelete;

  String get EditMyinfo;

  String get Edit;

  String get Pleaseinputpassword;

  String get Passwordconfirm;
  String get Save3;

  String get Pleaseconfirmpassword;

  String get Changepassword;

  String get Requestfortrialversion;

  String get Findpassword;

  String get Doyouwanttologout;
  String get Cancel;
  String get OK;
  String get oK;

  String get Inquire;
  String get SorrynoDataisavailable;

  //homepage
  String get NEW_PRODUCT;
  String get Total2;
  String get SALAD_PEA;
  String get POST;
  String get Search;
  String get SpecialvegetablecultivationSystems;
  String get Bitter;
  String get European;
  String get recipies;
  String get Introducingtherecipe;
  String get AvacadoEggBreakfastToast;
  String get Sweet;
  String get American;
  String get Special;
  String get BestProducts;

  //SHOPPAGE
  String get KoppertCressSHOP;
  String get RecommendedProducts;
  //DISCOVERY
  String get Discovery;
  String get mins;
  String get FruitSalad;
  String get cookingupsomebalsamicSteakgorgonzolasaladwithgrilledcorn;
  //Like
  String get Product;
  String get Recipes;
  String get Posts;
  //SPLASHSCREEN
  String get GREENBRIDGE;
//LoginScreen

  String get Welcometo;
  String get ID;
  String get Email;
  String get Password;
  String get Login;
  String get Find;
  String get Joinin;
  String get SignupformembershipeasilywithSNSaccount;

  //BottomBar
  String get Home;
  String get Shop;
  String get Like;
  String get MyOrders;
  String get Stories;

  //CarScreen
  String get ShoppingBag;
  String get AllProducts;
  String get PurchasedProducts;
  String get SweetBassil;
  String get OrganicbassilraisedbyPfarm;
  String get Total;
  String get SubscriptionProducts;
  String get SubscriptionTotal;
  String get Numberofitemsordered;
  String get OrderTotal;
  String get Checkout;
  //chef_trail_detail
  String get AdjiCress;
  String get SyrhaLeaves;
  String get Requesttouse;
  String get Taste;
  String get Sour;
  String get Salty;
  String get Umami;
  String get TasteFriends;
  String get TheflavourofSyrhaLeaves;
  String get Origin;
  String get SyrhaLeavesaretheseedling;
  String get Comment;
  String get RelatedRecipes;
  //ChefCommunity
  String get CHEFCOMMUNITY;
  String get Itisbeingcultivatedonatrailbasis;
  String get RockChivesischaracterisedbythelittleblackdotatthetop;
  String get WewillgrowtheCressyouneed;
  String get LetmeKnowwhatcropsyouneed;
  String get TrialcultivationAAA;
  String get Triallemonbalm;
  String get Okra;
  String get sweetbassil;
  String get spearmint;
  //chefProfile
  String get MyPageChef;
  String get TakeaLookatthecropsundertrialcultivation;
  String get MyShoppingInfo;
  String get myOrder;
  String get CancellationorExchangeorReturnHistory;
  String get Reviews;
  String get MyInformationManagement;
  String get ModifyMemberinfo;
  String get Deletemyaccount;
  String get Logout;
  String get CustomerService;
  String get InquiryHistory;
  String get InquirySentSuccessfully;
  String get Inquiryoneoone;
  String get myreview;
  String get Exchange;
  String get Refund;
  String get writeareview;
  String get FAQ;
  String get CustomersFeedback;
  String get Camera;
  String get Album;
  String get whereyouwantimagesfrom;

  //
  String get All;
  String get Deliverycheck;
  String get Validation;
  String get New;
  String get Best;
  String get Koppert;
  String get other;
  String get koppertcress;

  //PostDetailScreen
  String get SweetScentOFVanilla;
  String
      get SeasontheduckfilletsandfrymediumrarePeelthegrapefruitavifremovetheslicesandcutintosmallerpieces;
  String
      get MixallingredientsforthevinaigretteMixthesaladwiththeSakuraCressaddsomevinaigretteandtaste;

  String get Easytocookanddelicious;
  String get RelatedProducts;

  //productDetai;
  String get WhatisSyrhaLeaves;
  String get WhychooseSyrhaLeaves;
  String get Subscribe;
  String get Buy;
  String
      get TheflavourofSyrhaLeavesreallycomesthroughinfruitsaladsorincombinationswithredfruitwhitechocolateorevencoriander;
  String get ProductRequiredInformation;
  String get Countryoforigin;
  String get Refertotheproductdetails;
  String get ProductNumber;
  String get RelatedtoCS;
  String get Productcomposition;
  String get ofcontentbypackaging;
  String get Capacity;
  //PurchaseScreen
  String get QuantityofPurcahse;
  String get LetmeknowtheQuantitytopurchase;
  String get SelectPackingUnit;
  String get SelectPurchaseQuantity;
  String get AddtoBag;
  //QrMonitoring Screen
  String get Temp;
  String get Humd;
  String get Light;
  String get MonitoringCultivation;
  String get MintCress;
  String get daysleft;
  String get TODO;
  String get TodaykeyTasks;
  String get Transplant;
  String get Liquidinwater;
  String get Harvesting;
  String get Finishedharvestingofokrastem;

  //QRScreen
  String get Result;
  String get BarcodeType;
  String get Data;
  String get PleaseScanQRCode;
  String get QRCode;
  String get SeeDetails;
  String get noPermission;
  String get DeliveryTotal;

  //Recipe detail
  String get AvocadoToast;
  String get cookingupsomebalsamicsteakgorgonzolasaladwithgrilledcorn;
  String get min;
  String get Ingredients;
  String get Difficulty;
  String get Medium;
  String get BasicMaterials;
  String get Step1;
  String get Cutthecabbageintofinelongshredsandthendippedincoldwater;
  String get Step2;
  String
      get PlacebutterinaheatedpanandeggsbackandforthtomatchthesizeofthebreadGrilluntilgolden;
  String get Step;
  String get ProductsusedinthisRecipe;

  //RequestForm
  String get Requestfortrailversion;
  String get Doyouwanttouseapilotcress;
  String get Pleaseleaveyourinformation;
  String get Name;
  String get CHEFJUNG;
  String get Phonenumber;
  String get Iwilluseit;
  //searchScreen
  String get BlueSorrel;
  String get Sorrel;
  String get GreenSorrel;
  String get PISTACHIOCHOCOLATEMENDIANTS;
  String get GreenSouffle;
  String get Italianpasta;
  String get ResetCondition;
  String get PleaseletmeKnowthesubscriptionconditions;
  String get SubscriptionApplication;
  String get Selectsubscriptionperiod;
  String get Selectsubscriptionstartdate;
  String get SelectQuatitybysubscriptionday;
  String get SelectDeliverytime;
  //TODODetail
  String get TransplantorShipment;
  String get Shipment;
  String get shead;
  String get CultivationManagement;
  String get Weeklyirrigationmonitoring;
  String get Checkleafstatus;
  String get CheckRootcondition;
  String get CheckingtheHydroponicnutrientsEC;
  String get Checkthecleanlinessofthebottombed;
  //TODAY_WORK
  String get Plantingbasicseeds;
  String get TodaysKeyTasks;
  String get heads;
  //SINGUP
  String get Register;
  String get RequestSentSuccessfully;
  String get Chef;
  String get Farmer;
  String get General;
  String get CompanyInfo;
  String get Generalpopup;
  String get Phoneno;
  String get Thisisyouremail;

  String get Whoareyou;
  String get Businessnumberforissuingtaxinvoices;
  String get Pleasecheckpassword;
  String get Checkpassword;
  String get EssentialTermsandConditions;
  String get Typehere;

//

  String get RockChives;
  String get EC;
  String get PH;
  String get CO2;
  String get MyPageFarmer;
  String get FARMERSCOMMUNITY;
  String get Applyforparticipation;
  String get Canyouparticipateasagrowerofthiscress;
  String get YesIwillparticipate;
  String get Pleasegrowthiscrop;

  String get Whatareyouraising;
  String get Pleasetellmewhatvegetablesyouwanttosell;
  String get Monitoring;
  String get Cultivation;
  String get Joinasagrower;
  String get korean;
  String get SearchmyID;
  String get Searchmypw;

//home
  String get Inspiration;
  String get Boragecress;
  //shop
  String get Culinarygreens;
  String get Herbs;
  String get EdibleFlowers;
  String get SaladGreens;
  String get RootGreens;
  String get Specials;
  String get KoppertCress;
  String get PersonalPolicy;
  String get TermAndCondition;
  String get Entercultivationinformation;
  String get BenchID;
  String get ChooseCress;
  String get InputQuantity;
  String get Startdateofcultivation;

  //discovery
  String get Starters;
  String get Mains;
  String get Desserts;
  //like
  String get AmthonyBourdain;
  //qr_monitoring_screen
  String get Startdate;
  String get Enddate;
  String get Barcode;
  String get Itemname;
  String get Quantity;
  String get Cultivationnumber;
}
