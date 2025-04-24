import { TPAdInfo, TPReward, TPRewardLoadListener, TPRewardShowListener } from '@tradplus/tradplusads'
import { DemoConstants } from '../entryability/DemoConstants'
import { TestPlacement } from '../Utils/TestPlacement'
import { ActionBar } from '../widgets/action-bar'
import { CustomButton } from '../widgets/custom-button'

@Entry
@Component
struct RewardVideoPage {
  private tpReward : TPReward | undefined

  build() {
    Column() {
      ActionBar({ title: $r('app.string.RewardVideo') }).height('10%')
      Column() {
        Row() {
          CustomButton({
            mText: $r('app.string.video_load'), mOnClick: () => {
              console.log("请求广告")
              this.loadRewardVideo()
            }, mWidth: '33%'
          });

          CustomButton({
            mText: $r('app.string.IsReady'), mOnClick: async () => {
              let isReady = await this.tpReward?.isReady()
              console.log("isReady :" +isReady)
            }, mWidth: '33%'
          });

          CustomButton({
            mText: $r('app.string.video_show'), mOnClick: () => {
              console.log("展示广告")
              this.showRewardVideo()
            }, mWidth: '33%'
          });
        }
      }
    }
    .width('100%')
    .height('100%')
}

  showRewardVideo() {
    if (this.tpReward == undefined) return

    let showListener:TPRewardShowListener = {
      onAdImpression: (adInfo: TPAdInfo): void => {
        // 展示成功
        console.log("onAdImpression:" + JSON.stringify(adInfo));
      },
      onAdShowFailed: (adInfo: TPAdInfo): void => {
        // 展示失败
        console.log("onAdShowFailed:" + JSON.stringify(adInfo));
      },
      onAdClosed: (adInfo: TPAdInfo): void => {
        // 广告关闭
        console.log("onAdClosed:" + JSON.stringify(adInfo));
      },
      onAdVideoStart: (adInfo: TPAdInfo): void => {

      },
      onAdVideoEnd: (adInfo: TPAdInfo): void => {

      },
      onAdClicked: (adInfo: TPAdInfo): void => {
        // 用户触发点击
        console.log("onAdClicked:" + JSON.stringify(adInfo));
      },
      onAdRewarded: (adInfo: TPAdInfo, rewardInfo?: Map<string, string>):void =>{
        // 奖励回调
        console.log("onAdRewarded:"+ JSON.stringify(adInfo));
      }
    }
    this.tpReward.showListener = showListener
    this.tpReward.show(DemoConstants.windowStage)
  }

  loadRewardVideo() {
    if (this.tpReward == undefined) {
      this.tpReward = new TPReward()
      this.tpReward.setAdUnitID(TestPlacement.rewardvideo)
    }
    let loadListener:TPRewardLoadListener = {
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
    this.tpReward.loadListener = loadListener
    this.tpReward.load()
  }
}