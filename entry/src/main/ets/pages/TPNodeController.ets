import { UIContext, NodeController, BuilderNode, FrameNode } from '@kit.ArkUI';
import { TPNative, TPNativeAdView } from '@tradplus/tradplusads';
import { TPNativeArrayList } from "@tradplus/tradplusads";
import { util } from "@kit.ArkTS";
import { common } from "@kit.AbilityKit";

export class TPNodeController extends NodeController {
  protected _childNodeController: NodeController | undefined;

  makeNode(uiContext?: UIContext): FrameNode | null {
    if (!uiContext || !this._childNodeController) {
      return null;
    }
    const childNode = this._childNodeController.makeNode(uiContext);
    return childNode;
  }

  public showAd(context: UIContext, tpNative: TPNative, tpNativeView: TPNativeAdView) {

    let view = new TPNodeShow();
    view.showAd(context, tpNative, tpNativeView);

    this._childNodeController = view;
    this.rebuild();
  }
}

class TPNativeParams {
  tpNativeAdView?: TPNativeAdView | undefined
  tpNative?: TPNative | undefined
}


export class TPNodeShow extends NodeController {
  private rootNode: FrameNode | null = null;
  private adNode: BuilderNode<[TPNativeParams]> | null = null;

  makeNode(uiContext: UIContext): FrameNode | null {
    if (this.rootNode != null) {
      return this.rootNode;
    }
    return null;
  }

  showAd(uiContext: UIContext, tpNative: TPNative, tpNativeAdView: TPNativeAdView) {

    let tpNativeParams = new TPNativeParams()
    tpNativeParams.tpNativeAdView = tpNativeAdView;
    tpNativeParams.tpNative = tpNative;
    this.rootNode = new FrameNode(uiContext);
    this.adNode = new BuilderNode(uiContext);
    this.adNode.build(wrapBuilder(adBuilder), tpNativeParams);
    this.rootNode.getRenderNode()?.appendChild(this.adNode.getFrameNode()?.getRenderNode());

  }
}

@Builder
export function adBuilder(params: TPNativeParams) {
  AdComponent({ mTpNativeView: params.tpNativeAdView, mTPNative: params.tpNative });
}

@Component
struct AdComponent {
  private mTpNativeView?: TPNativeAdView | undefined;
  private mTPNative?: TPNative | undefined;
  @State private clickViewIds: TPNativeArrayList<string> = new TPNativeArrayList();
  private rootComponentId: string = util.generateRandomUUID()

  build() {

    Column() {
      Row() {
        Row() {
          // icon
          Image(this.mTpNativeView!.iconImageUrl)
            .height(32)
            .width(32)
            .borderRadius(5)
            .margin({ right: 5 })
            .id(this.clickViewIds?.addAdId(util.generateRandomUUID()))
            .onClick((e: ClickEvent) => {
              // 点击转化
              this.mTPNative?.getClickHandler(getContext(this) as common.UIAbilityContext, e)
            })
          //描述内容
          Text(this.mTpNativeView!.subTitle)
            .fontSize(12)
            .textAlign(TextAlign.Start)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .id(this.clickViewIds?.addAdId(util.generateRandomUUID()))//设置组件Id，需要全局保证唯一性，涉及计费
            .onClick((e: ClickEvent) => {
              // 点击转化
              this.mTPNative?.getClickHandler(getContext(this) as common.UIAbilityContext, e)
            })
        }
        .height(35)
        .width("85%")
        .justifyContent(FlexAlign.Start);
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .height(35)
      .width("100%")
      .padding({ left: 10, right: 10, bottom: 4 })

      Stack({ alignContent: Alignment.BottomStart }) {
        if (this.mTpNativeView?.mainImageUrl) {
          // 大图是图片
          this.buildImageLayout()
        } else {
          // 大图是视频
          NodeContainer(this.mTpNativeView?.videoNodeController)
        }
      }.height(200)

      Row() {
        //标题
        Text(this.mTpNativeView?.title)
          .fontSize(12)
          .textAlign(TextAlign.Center)
          .id(this.clickViewIds?.addAdId(util.generateRandomUUID()))//设置组件Id，需要全局保证唯一性，涉及计费
          .onClick((e: ClickEvent) => {
            // 点击转化
            this.mTPNative?.getClickHandler(getContext(this) as common.UIAbilityContext, e)
          })

        //CTA
        Button(this.mTpNativeView?.callToAction, { type: ButtonType.Normal })
          .fontSize(12)
          .borderRadius(5)
          .id(this.clickViewIds?.addAdId(util.generateRandomUUID()))//设置组件Id，需要全局保证唯一性，涉及计费
          .onClick((e: ClickEvent) => {
            // 点击转化
            this.mTPNative?.getClickHandler(getContext(this) as common.UIAbilityContext, e)
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .height(35)
      .width("100%")
      .padding({
        top: 5,
        bottom: 5,
        left: 10,
        right: 10
      })
    }
    .backgroundColor("#08000000")
    .id(this.rootComponentId) //设置广告容器组件rootId
    .onAppear(() => {
      //注册计费事件
      this.mTPNative?.registerClickView(this.rootComponentId, getContext(this) as common.UIAbilityContext,
        this.clickViewIds)
    })
    // 添加可见区域监听，SDK内部处理曝光逻辑
    .onVisibleAreaChange(this.mTPNative?.getVisibleAreaRatios(), this.mTPNative?.getVisibleAreaChangeListener())
  }

  @Builder
  // 图片类型的广告布局
  buildImageLayout() {
    Image(this.mTpNativeView?.mainImageUrl)
      .objectFit(ImageFit.Cover)
      .id(this.clickViewIds?.addAdId(util.generateRandomUUID()))//设置组件Id，需要全局保证唯一性，涉及计费
      .onClick((e: ClickEvent) => {
        // 点击转化
        this.mTPNative?.getClickHandler(getContext(this) as common.UIAbilityContext, e)
      })
  }

}
