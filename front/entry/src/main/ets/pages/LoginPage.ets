import { AuthService } from '../services/AuthService'
import { Constants } from '../common/Constants'

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
      // ── Brand header ──
      Column() {
        // Logo with gradient circle
        Stack() {
          Circle()
            .width(88)
            .height(88)
            .fill('rgba(22,119,255,0.08)')
          Circle()
            .width(72)
            .height(72)
            .fill('rgba(22,119,255,0.15)')
          Image($r('app.media.startIcon'))
            .width(48)
            .height(48)
            .borderRadius(12)
        }
        .margin({ bottom: 20 })

        Text('东软云医院 HIS')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)

        Text('Hospital Information System')
          .fontSize(13)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ top: 8 })
          .letterSpacing(2)
      }
      .margin({ top: 80, bottom: 48 })

      // ── Login form card ──
      Column() {
        // Username
        Row() {
          Text('👤')
            .fontSize(18)
            .margin({ right: 10 })
          TextInput({ placeholder: '请输入用户名' })
            .width('100%')
            .height(44)
            .fontSize(15)
            .borderRadius(0)
            .backgroundColor(Color.Transparent)
            .layoutWeight(1)
            .onChange((value: string) => {
              this.username = value
              this.errorMsg = ''
            })
        }
        .width('100%')
        .padding({ left: 14, right: 14 })
        .borderRadius(10)
        .backgroundColor(Constants.COLOR_BG)
        .margin({ bottom: 14 })

        // Password
        Row() {
          Text('🔒')
            .fontSize(18)
            .margin({ right: 10 })
          TextInput({ placeholder: '请输入密码' })
            .width('100%')
            .height(44)
            .fontSize(15)
            .borderRadius(0)
            .backgroundColor(Color.Transparent)
            .type(InputType.Password)
            .layoutWeight(1)
            .onChange((value: string) => {
              this.password = value
              this.errorMsg = ''
            })
        }
        .width('100%')
        .padding({ left: 14, right: 14 })
        .borderRadius(10)
        .backgroundColor(Constants.COLOR_BG)

        // Error message
        if (this.errorMsg) {
          Text(this.errorMsg)
            .fontSize(12)
            .fontColor(Constants.COLOR_DANGER)
            .margin({ top: 10 })
            .width('100%')
            .textAlign(TextAlign.Start)
        }

        // Login button
        Button(this.loading ? '登录中...' : '登 录')
          .width('100%')
          .height(46)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .backgroundColor(Constants.COLOR_PRIMARY)
          .borderRadius(10)
          .margin({ top: 24 })
          .enabled(!this.loading)
          .shadow({ radius: 4, color: 'rgba(22,119,255,0.3)' })
          .onClick(() => this.doLogin())

        // Demo credentials hint
        Text('演示账号: root / 挂号 / 扁鹊 / 检查 / 检验 / 处置')
          .fontSize(11)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ top: 16 })
      }
      .width('100%')
      .padding({ top: 24, bottom: 28, left: 20, right: 20 })
      .backgroundColor(Constants.COLOR_CARD)
      .borderRadius(16)
      .shadow({ radius: 8, color: 'rgba(0,0,0,0.06)' })

      // ── Footer ──
      Text('请使用分配的科室账号登录')
        .fontSize(11)
        .fontColor('#C8CCD0')
        .margin({ top: 36 })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 24, right: 24 })
    .backgroundColor(Constants.COLOR_BG)
  }
}

export default LoginPage
