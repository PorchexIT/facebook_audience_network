import 'package:flutter/material.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'dart:io' show Platform;


void main() => runApp(AdExampleApp());

class AdExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FB Audience Network Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          buttonColor: Colors.blue,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "FB Audience Network Example",
          ),
        ),
        body: AdsPage(),
      ),
    );
  }
}

class AdsPage extends StatefulWidget {
    final String idfa;

  const AdsPage({Key? key, this.idfa = ''}) : super(key: key);

  @override
  AdsPageState createState() => AdsPageState();
}

class AdsPageState extends State<AdsPage>{
  bool _isInterstitialAdLoaded = false;

  Widget _currentAd = SizedBox(
    width: 100,
    height: 200,
  );

  @override
  void initState(){
    super.initState();
    FacebookAudienceNetwork.init(
      testingId: "1b64b1f7-757e-4279-887a-d325b3a19938",
      iOSAdvertiserTrackingEnabled: true,
    );
    _loadInterstitialAd();
  }
  
  

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: Align(
            alignment: Alignment(0,-1.0),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: _getAllButtons(),
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 3,
          child: Align(
            alignment: Alignment(0,1.0),
            child: _currentAd,
          ),
        ),
      ],
    );
  }

  Widget _getAllButtons() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 3,
      children: <Widget>[
        _getRaisedButton(title: "Banner Ad", onPressed: _showBannerAd),
        _getRaisedButton(title: "Native Ad", onPressed: _showNativeAd),
        _getRaisedButton(title: "Native Banner Ad", onPressed: _showNativeBannerAd),
        _getRaisedButton(title: "Intestitial Ad", onPressed: _showInterstitialAd),
        ],
    );
  }
  
  Widget _getRaisedButton({required String title, void Function()? onPressed}) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "IMG_16_9_APP_INSTALL#930189931622746_933500084625064", 
      listener: (result, value){
        print("Interstitial Ad: $result --> $value");
        if(result == InterstitialAdResult.LOADED) _isInterstitialAdLoaded = true;
      }
    );
  }

  _showInterstitialAd() {
    if(_isInterstitialAdLoaded == true){
      FacebookInterstitialAd.showInterstitialAd();
    }else{
      print("Interstitial Ad not yet loaded!");
    }
  }

    _showBannerAd() {
    setState(() {
      _currentAd = FacebookBannerAd(
        placementId: "IMG_16_9_APP_INSTALL#930189931622746_933499591291780", 
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          print("Banner Ad: $result -->  $value");
        },
      );
    });
  }

    _showNativeBannerAd() {
    setState(() {
      _currentAd = _nativeBannerAd();
    });
  }

   Widget _nativeBannerAd() {
    return FacebookNativeAd(
      placementId: "IMG_16_9_APP_INSTALL#930189931622746_933499944625078",
      adType: NativeAdType.NATIVE_BANNER_AD,
      bannerAdSize: NativeBannerAdSize.HEIGHT_100,
      width: double.infinity,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        print("Native Banner Ad: $result --> $value");
      },
    );
  }

   _showNativeAd() {
    setState(() {
      _currentAd = _nativeAd();
    });
  }

   Widget _nativeAd() {
    return FacebookNativeAd(
      placementId: "IMG_16_9_APP_INSTALL#930189931622746_933499831291756",
      adType: NativeAdType.NATIVE_AD_VERTICAL,
      width: double.infinity,
      height: 300,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
      keepExpandedWhileLoading: true,
      expandAnimationDuraion: 10000,
    );
  }


}