/**
 * @file 页面标题栏组件
 * 白色背景，56高度，圆角8，支持返回按钮和右侧操作区
 */

@ComponentV2
export struct PageHeader {
  @Param title: string = ''
  @Param showBack: boolean = false
  @Event onBack: () => void = () => {}

  build() {
    Row() {
      // 返回按钮
      if (this.showBack) {
        Row() {
          Image($r('app.media.app_icon'))
            .width(20)
            .height(20)
          Blank()
        }
        .width('10%')
        .onClick(() => {
          this.onBack()
        })
      } else {
        Blank().width('10%')
      }

      // 标题
      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .textAlign(TextAlign.Center)
        .width('80%')

      // 右侧操作区（预留BuilderParam）
      Blank().width('10%')
    }
    .width('100%')
    .height(56)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .padding({ left: 16, right: 16 })
  }
}
