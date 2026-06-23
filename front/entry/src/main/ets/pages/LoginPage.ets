import { AuthService } from '../services/AuthService'

@ComponentV2
struct LoginPage {
  @Local username: string = ''
  @Local password: string = ''
  @Local loading: boolean = false
  @Local errorMsg: string = ''
  @Event onLoginSuccess: () => void = () => {}

  private async doLogin(): Promise<void> {
    if (!this.username || !this.password) {
      this.errorMsg = '请输入用户名和密码'
      return
    }
    this.loading = true
    this.errorMsg = ''
    try {
      const result = await AuthService.login(this.username, this.password)
      if (result.status === 1) {
        this.onLoginSuccess()
      } else {
        this.errorMsg = result.msg || '登录失败，请检查用户名和密码'
      }
    } catch (err) {
      let detail: string = ''
      if (err instanceof Error) {
        detail = (err as Error).message
      } else if (typeof err === 'string') {
        detail = err as string
      } else {
        detail = JSON.stringify(err)
      }
      this.errorMsg = '网络连接失败 | ' + detail
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      // Brand header
      Column() {
        Image($r('app.media.startIcon'))
          .width(72).height(72).margin({ bottom: 16 })
        Text('东软云医院 HIS')
          .fontSize(28).fontWeight(FontWeight.Bold).fontColor('#20A0FF')
        Text('Hospital Information System')
          .fontSize(14).fontColor('#909399').margin({ top: 8 })
      }.margin({ top: 80, bottom: 60 })

      // Login form
      Column() {
        TextInput({ placeholder: '请输入用户名' })
          .width('100%').height(44).fontSize(15)
          .borderRadius(8).backgroundColor('#F5F7FA')
          .margin({ bottom: 16 })
          .onChange((value: string) => {
            this.username = value
            this.errorMsg = ''
          })

        TextInput({ placeholder: '请输入密码' })
          .width('100%').height(44).fontSize(15)
          .borderRadius(8).backgroundColor('#F5F7FA')
          .type(InputType.Password)
          .onChange((value: string) => {
            this.password = value
            this.errorMsg = ''
          })

        if (this.errorMsg) {
          Text(this.errorMsg).fontSize(13).fontColor('#F56C6C').margin({ top: 8 })
        }

        Button(this.loading ? '登录中...' : '登 录')
          .width('100%').height(44).fontSize(16)
          .backgroundColor('#20A0FF').fontColor('#FFFFFF')
          .borderRadius(8).margin({ top: 24 })
          .enabled(!this.loading)
          .onClick(() => this.doLogin())
      }
      .width('100%').padding(24).backgroundColor('#FFFFFF')
      .borderRadius(12).shadow({ radius: 10, color: 'rgba(0,0,0,0.08)' })

      Text('提示: 请使用分配的科室账号登录')
        .fontSize(11).fontColor('#C0C4CC').margin({ top: 40 })
    }
    .width('100%').height('100%').padding(24).backgroundColor('#F0F2F5')
  }
}

export default LoginPage
