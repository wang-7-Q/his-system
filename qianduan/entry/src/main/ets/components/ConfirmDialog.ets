/**
 * @file 确认对话框组件
 * 居中白色卡片，支持自定义标题/消息/按钮文字
 */

@ComponentV2
export struct ConfirmDialog {
  @Param visible: boolean = false
  @Param title: string = '确认操作'
  @Param message: string = ''
  @Param confirmText: string = '确定'
  @Param cancelText: string = '取消'
  @Param danger: boolean = false
  @Event onConfirm: () => void = () => {}
  @Event onCancel: () => void = () => {}

  build() {
    Stack() {
      if (this.visible) {
        // 遮罩层
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#66000000')
          .onClick(() => {
            this.onCancel()
          })

        // 对话框卡片
        Column() {
          // 标题
          Text(this.title)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
            .margin({ bottom: 16 })

          // 消息内容
          Text(this.message)
            .fontSize(14)
            .fontColor('#666666')
            .textAlign(TextAlign.Center)
            .margin({ bottom: 24 })

          // 按钮区域
          Row() {
            // 取消按钮
            Button(this.cancelText)
              .fontSize(14)
              .fontColor('#666666')
              .backgroundColor('#f5f5f5')
              .borderRadius(4)
              .width('45%')
              .height(40)
              .onClick(() => {
                this.onCancel()
              })

            // 确认按钮
            Button(this.confirmText)
              .fontSize(14)
              .fontColor(Color.White)
              .backgroundColor(this.danger ? '#ff4d4f' : '#20A0FF')
              .borderRadius(4)
              .width('45%')
              .height(40)
              .onClick(() => {
                this.onConfirm()
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('75%')
        .padding(24)
        .backgroundColor(Color.White)
        .borderRadius(12)
      }
    }
    .width('100%')
    .height('100%')
  }
}
