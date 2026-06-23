@ComponentV2
export struct ConfirmDialog {
  @Param visible: boolean = false
  @Param title: string = '提示'
  @Param message: string = ''
  @Param confirmText: string = '确定'
  @Param cancelText: string = '取消'
  @Param danger: boolean = false
  @Event onConfirm: () => void = () => {}
  @Event onCancel: () => void = () => {}

  build() {
    if (this.visible) {
      Stack() {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(0,0,0,0.4)')
          .onClick(() => this.onCancel())

        Column() {
          Text(this.title)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 12 })
          Text(this.message)
            .fontSize(14)
            .fontColor('#606266')
            .margin({ bottom: 20 })
          Row() {
            Button(this.cancelText)
              .backgroundColor('#F5F5F5')
              .fontColor('#606266')
              .layoutWeight(1)
              .onClick(() => this.onCancel())
            Blank().width(12)
            Button(this.confirmText)
              .backgroundColor(this.danger ? '#F56C6C' : '#409EFF')
              .fontColor('#FFFFFF')
              .layoutWeight(1)
              .onClick(() => this.onConfirm())
          }
          .width('100%')
        }
        .width(300)
        .padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({ radius: 20, color: 'rgba(0,0,0,0.15)' })
      }
      .width('100%')
      .height('100%')
    }
  }
}
