/**
 * @file 空数据状态组件
 * 居中图标 + 提示文字 + 可选重试按钮
 */

@ComponentV2
export struct EmptyState {
  @Param text: string = '暂无数据'
  @Param showRetry: boolean = false
  @Event onRetry: () => void = () => {}

  build() {
    Column() {
      // 空数据图标
      Text('')
        .fontSize(48)
        .margin({ bottom: 16 })

      // 提示文字
      Text(this.text)
        .fontSize(14)
        .fontColor('#999999')
        .margin({ bottom: 16 })

      // 重试按钮
      if (this.showRetry) {
        Button('重试')
          .fontSize(14)
          .fontColor('#20A0FF')
          .backgroundColor(Color.White)
          .border({ width: 1, color: '#20A0FF' })
          .borderRadius(4)
          .padding({ left: 24, right: 24, top: 8, bottom: 8 })
          .onClick(() => {
            this.onRetry()
          })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
