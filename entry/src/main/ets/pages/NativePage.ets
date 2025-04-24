import { TPAdInfo, TPNative, TPNativeAdView, TPNativeLoadListener, TPNativeShowListener } from '@tradplus/tradplusads';
import { TestPlacement } from '../Utils/TestPlacement';
import { ActionBar } from '../widgets/action-bar';
import { CustomButton } from '../widgets/custom-button';
import { TPNodeController } from './TPNodeController';

@Entry
@Component
struct NativePage {
  private tpNative: TPNative = new TPNative();
  @State private isShow:boolean  = false // 动态删除组件
  @State private isExpressType: boolean = true;//是否是模版广告
  private tpNativeAdView: TPNativeAdView | undefined // 获取三方平台展示素材
  private tpNodeController: TPNodeController = new TPNodeController()

  build() {
    Column() {
      ActionBar({ title: $r('app.string.native') }).height('10%')
      CustomButton({
        mText: $r('app.string.native_load'), mOnClick: () => {
          console.log("请求广告")
          this.loadNative()
        }, mWidth: '33%'
      });

      CustomButton({
        mText: $r('app.string.IsReady'), mOnClick: async () => {
          let isReady = await this.tpNative?.isReady()
          console.log("isReady :" +isReady)
        }, mWidth: '33%'
      });

      CustomButton({
        mText: $r('app.string.native_show'), mOnClick: () => {
          console.log("展示广告")
          this.showNative()
        }, mWidth: '33%'
      });

      // 模版广告 展示
      if (this.isExpressType && this.isShow) {
        NodeContainer(this.tpNative)
      }

      // 自渲染类型 展示
      if (!this.isExpressType && this.tpNativeAdView && this.isShow) {
        NodeContainer(this.tpNodeController)
      }
    }
    .width('100%')
    .height('100%')
  }

  async showNative() {
    let showListener:TPNativeShowListener = {
      onAdImpression: (adInfo: TPAdInfo): void => {
        // 展示成功
        console.log("onAdImpression:" + JSON.stringify(adInfo));
      },
      onAdShowFailed: (adInfo: TPAdInfo): void => {
        // 展示失败
        console.log("onAdShowFailed:");
      },
      onAdClosed: (adInfo: TPAdInfo): void => {
        // 广告关闭
        console.log("onAdClosed:" + JSON.stringify(adInfo));
      },
      onAdClicked: (adInfo: TPAdInfo): void => {
        // 用户触发点击
        console.log("onAdClicked:" + JSON.stringify(adInfo));
      }
    }
    this.tpNative.showListener = showListener

    this.isShow = false
    const tpNativeAdView = await this.tpNative?.getTPNativeAd(this.getUIContext())
    if (tpNativeAdView != undefined) {
      // 自渲染类型
      this.isExpressType = false
      this.tpNativeAdView = tpNativeAdView
      this.isShow = true
      this.tpNodeController.showAd(this.getUIContext(),this.tpNative,tpNativeAdView)
    }else {
      // 模版类型
      this.isExpressType = true
      this.isShow = true
    }

  }

  loadNative() {
    this.tpNative.setAdUnitID(TestPlacement.native)
    let loadListener:TPNativeLoadListener = {
      onAdLoaded: (adInfo: TPAdInfo): void => {
        // 请求一次广告，有广告加载成功，一轮请求只会返回一次
        console.log("onAdLoaded:" + JSON.stringify(adInfo));
      },
      onAdLoadFail: (adInfo: TPAdInfo, error: Error): void => {
        // 请求一次广告，所有广告加载失败，一轮请求只会返回一次
        console.log("onAdLoadFail error:" + error.message);
      },
      onAdStartLoad: (adInfo: TPAdInfo): void => {
        // 广告开始加载
        console.log("onAdStartLoad:");
      },
      onAdOneLayerStartLoad: (adInfo: TPAdInfo): void => {
        // 每层广告开始加载
        console.log("onAdOneLayerStartLoad:" + JSON.stringify(adInfo));
      },
      onAdBidStart: (adInfo: TPAdInfo): void => {
        // Bidding开始
        console.log("onAdBidStart:");
      },
      onAdBidEnd: (adInfo: TPAdInfo, error?: Error | undefined): void => {
        // Bidding结束，error == undefined表示Bidding成功，有error表示Bidding失败
        console.log("onAdBidEnd error:" + error?.message);
      },
      onAdOneLayerLoaded: (adInfo: TPAdInfo): void => {
        // 单层广告加载成功
        console.log("onAdOneLayerLoaded:" + JSON.stringify(adInfo));
      },
      onAdOneLayerLoadFail: (adInfo: TPAdInfo, error: Error): void => {
        // 单层广告加载加载失败
        console.log("onAdOneLayerLoadFail error:" + error.message);
      },
      onAdAllLoaded: (adInfo: TPAdInfo, success: boolean): void => {
        // 请求一次广告，一轮结束会收到一次回调，success true表示有广告加载成功，false表示所有广告加载失败
        console.log("onAdAllLoaded success:" + success);
      },
      onAdIsLoading: (adInfo: TPAdInfo): void => {
        // 一轮请求还没有结束，又发起了一轮请求
        console.log("onAdIsLoading:");
      },
    }
    this.tpNative.loadListener = loadListener
    this.tpNative.load(this.getUIContext())
  }
}