/*
 * Copyright 2023. Huawei Technologies Co., Ltd. All rights reserved.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 */

@Component
export struct CustomButton {
  private mText: string | Resource = '';
  private mHeight: number = 35;
  private mWidth:Length = '33%'
  private mOnClick: (event?: ClickEvent) => void = (): void => {
  };

  build() {
    Column() {
      Button(this.mText)
        .backgroundColor($r('app.color.custom_button_background'))
        .fontSize(15)
        .fontColor($r('app.color.custom_button_font_color'))
        .fontWeight(FontWeight.Normal)
        .align(Alignment.Center)
        .type(ButtonType.Capsule)
        .width(this.mWidth)
        .height(this.mHeight)
        .margin({ top: 10, bottom: 5 })
        .onClick(this.mOnClick);
    }
  }
}