/**
 * @file 登录页面
 * 居中白色卡片登录表单，支持账号提示
 */

import { login } from '../services/AuthService'

@ComponentV2
export struct LoginPage {
  @Event onLoginSuccess: () => void = () => {}

  @Local username: string = ''
  @Local password: string = ''
  @Local loading: boolean = false
  @Local errorMsg: string = ''

  async submitClick(): Promise<void> {
    if (this.username.trim() === '' || this.password.trim() === '') {
      this.errorMsg = '用户名和密码不能为空!'
      return
    }
    this.errorMsg = ''
    this.loading = true
    const success: boolean = await login(this.username.trim(), this.password.trim())
    this.loading = false
    if (success) {
      this.onLoginSuccess()
    }
  }

  build() {
    Column() {
      Blank()

      // 登录卡片
      Column() {
        Text('东软云医院 HIS')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ top: 40, bottom: 8 })

        Text('Hospital Information System')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ bottom: 40 })

        TextInput({ placeholder: '账号' })
          .value(this.username)
          .onChange((val: string) => {
            this.username = val
            this.errorMsg = ''
          })
          .fontSize(14)
          .height(44)
          .width('85%')
          .margin({ bottom: 16 })
          .backgroundColor('#f5f5f5')
          .borderRadius(4)
          .padding({ left: 12 })

        TextInput({ placeholder: '密码' })
          .value(this.password)
          .onChange((val: string) => {
            this.password = val
            this.errorMsg = ''
          })
          .fontSize(14)
          .height(44)
          .width('85%')
          .margin({ bottom: 8 })
          .backgroundColor('#f5f5f5')
          .borderRadius(4)
          .padding({ left: 12 })
          .type(InputType.Password)

        if (this.errorMsg !== '') {
          Text(this.errorMsg)
            .fontSize(12)
            .fontColor('#ff4d4f')
            .width('85%')
            .margin({ bottom: 8 })
        }

        Blank().height(24)

        Button('登录')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#20A0FF')
          .borderRadius(4)
          .width('85%')
          .height(44)
          .enabled(!this.loading)
          .onClick(() => {
            this.submitClick()
          })

        if (this.loading) {
          LoadingProgress()
            .width(24)
            .height(24)
            .color('#20A0FF')
            .margin({ top: 16 })
        }
      }
      .width(350)
      .backgroundColor(Color.White)
      .borderRadius(12)
      .shadow({ radius: 12, color: '#33000000', offsetY: 4 })
      .alignItems(HorizontalAlign.Center)

      Blank()

      Column() {
        Text('登录说明')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#666666')
          .margin({ bottom: 8 })

        Text('超级用户: root（密码: 123）- 请勿进行业务操作')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ bottom: 4 })

        Text('挂号: 挂号（密码: 123）')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ bottom: 4 })

        Text('医生: 扁鹊/范无病/华佗/葛洪（密码: 123）')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ bottom: 4 })

        Text('检查/检验/处置: 检查/检验/处置（密码: 123）')
          .fontSize(12)
          .fontColor('#999999')
      }
      .padding({ bottom: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f0f2f5')
  }
}
