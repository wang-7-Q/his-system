@ComponentV2
export struct PageHeader {
  @Param title: string = ''
  @Param showBack: boolean = false
  @Event onBack?: () => void
  @BuilderParam actionArea?: () => void

  build() {
    Row() {
      if (this.showBack) {
        Button({ type: ButtonType.Circle }) {
          Image($r('sys.symbol.chevron_left'))
            .width(24)
            .height(24)
        }
        .width(36)
        .height(36)
        .backgroundColor(Color.Transparent)
        .onClick(() => this.onBack?.())
        .margin({ right: 12 })
      }
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#303133')
        .layoutWeight(1)
      if (this.actionArea) {
        this.actionArea()
      }
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .margin({ bottom: 12 })
  }
}
