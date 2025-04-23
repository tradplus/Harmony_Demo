import { TPBanner, TPInterstitial, TPNative, TPNativeAdView, TPReward, TradPlus } from '@tradplus/tradplusads';
import { TPNodeController } from './TPNodeController';
import { ActionBar } from '../widgets/action-bar';
import { CustomButton } from '../widgets/custom-button';
import { TestPlacement } from '../Utils/TestPlacement';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  private scroller: Scroller = new Scroller();

  build() {
    Column() {
      ActionBar({ title: $r('app.string.actionbar') }).height('10%')
      Column() {
        CustomButton({
          mText: $r('app.string.init_sdk'), mOnClick: () => {
            if (!TradPlus.isInitialized()) {
              TradPlus.initSDK(TestPlacement.appId, (error: Error) => {
                if (error === undefined) {
                  console.log("初始化成功")
                } else {
                  console.log("初始化失败：" + error.message)
                }
              })
            }
          }, mWidth: '50%'
        });
        CustomButton({
          mText: $r('app.string.RewardVideo'), mOnClick: () => {
            routePageWithoutAds('pages/RewardVideoPage');
          }, mWidth: '50%'
        });
        CustomButton({
          mText: $r('app.string.Interstitial'), mOnClick: () => {
            routePageWithoutAds('pages/InterstitialPage');
          }, mWidth: '50%'
        });
        CustomButton({
          mText: $r('app.string.splash'), mOnClick: () => {
            routePageWithoutAds('pages/SplashPage');
          }, mWidth: '50%'
        });
        CustomButton({
          mText: $r('app.string.banner'), mOnClick: () => {
            routePageWithoutAds('pages/BannerPage');
          }, mWidth: '50%'
        });
        CustomButton({
          mText: $r('app.string.native'), mOnClick: () => {
            routePageWithoutAds('pages/NativePage');
          }, mWidth: '50%'
        });
      }
      .height('100%')
      .width('100%')
    }
  }
}

async function routePageWithoutAds(pageUri: string) {
  let options: router.RouterOptions = {
    url: pageUri
  }
  try {
    router.pushUrl(options);
  } catch (error) {
  }
}
