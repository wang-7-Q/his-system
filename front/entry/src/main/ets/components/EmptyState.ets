@ComponentV2
export struct EmptyState {
  @Param text: string = '暂无数据'
  @Param showRetry: boolean = false
  @Event onRetry?: () => void

  build() {
    Column() {
      Image($r('sys.symbol.tray'))
        .width(80)
        .height(80)
        .fillColor('#C0C4CC')
        .margin({ bottom: 16 })
      Text(this.text)
        .fontSize(14)
        .fontColor('#909399')
        .margin({ bottom: this.showRetry ? 16 : 0 })
      if (this.showRetry) {
        Button('重新加载')
          .fontSize(13)
          .backgroundColor('#409EFF')
          .fontColor('#FFFFFF')
          .onClick(() => this.onRetry?.())
      }
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(200)
  }
}
