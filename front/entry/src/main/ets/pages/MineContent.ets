import { User } from '../models/User'
import { Constants } from '../common/Constants'
import { AuthService } from '../services/AuthService'
import { hilog } from '@kit.PerformanceAnalysisKit'

const DOMAIN = 0x0000

/**
 * "Mine" tab — user profile card, settings list, and logout.
 * Uses emoji icons since HarmonyOS system symbol names vary by SDK version.
 */
@ComponentV2
struct MineContent {
  @Local loginUser: User | null = null
  @Event onLogout: () => void = () => {}

  aboutToAppear(): void {
    this.loginUser = AppStorage.get<User>('loginUser') || null
  }

  private async handleLogout(): Promise<void> {
    try {
      await AuthService.logout()
    } catch (err) {
      hilog.error(DOMAIN, 'MineContent', 'Logout error: %{public}s', JSON.stringify(err))
    }
    this.onLogout()
  }

  build() {
    Scroll() {
      Column() {
        // ── Profile card ──
        Row() {
          Column() {
            Text((this.loginUser?.realname || '?').charAt(0))
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
          }
          .width(64)
          .height(64)
          .borderRadius(32)
          .backgroundColor(Constants.COLOR_PRIMARY)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 16 })

          Column() {
            Text(this.loginUser?.realname || '未登录')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.COLOR_TEXT_PRIMARY)
            Text(this.loginUser?.dept_name || '')
              .fontSize(13)
              .fontColor(Constants.COLOR_TEXT_SECONDARY)
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text('›')
            .fontSize(20)
            .fontColor(Constants.COLOR_TEXT_HINT)
        }
        .width('100%')
        .padding(20)
        .borderRadius(12)
        .backgroundColor(Constants.COLOR_CARD)
        .margin({ bottom: 16 })

        // ── Settings list ──
        Column() {
          this.settingItem('👤', '个人信息', '查看和修改个人资料')
          this.settingDivider()
          this.settingItem('🔒', '修改密码', '定期更新登录密码')
          this.settingDivider()
          this.settingItem('🔔', '消息通知', '管理系统通知设置')
          this.settingDivider()
          this.settingItem('❓', '使用帮助', '查看系统操作指南')
          this.settingDivider()
          this.settingItem('ℹ️', '关于系统', '东软云医院 HIS v2.0')
        }
        .width('100%')
        .borderRadius(12)
        .backgroundColor(Constants.COLOR_CARD)
        .margin({ bottom: 16 })

        // ── Logout button ──
        Button('退出登录')
          .width('100%')
          .height(48)
          .fontSize(16)
          .fontColor(Constants.COLOR_DANGER)
          .backgroundColor(Constants.COLOR_CARD)
          .borderRadius(12)
          .onClick(() => this.handleLogout())
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 80 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  settingItem(icon: string, title: string, desc: string) {
    Row() {
      Text(icon)
        .fontSize(20)
        .margin({ right: 14 })
      Column() {
        Text(title).fontSize(15).fontColor(Constants.COLOR_TEXT_PRIMARY)
        Text(desc).fontSize(12).fontColor(Constants.COLOR_TEXT_HINT).margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.Start).layoutWeight(1)
      Text('›')
        .fontSize(18)
        .fontColor(Constants.COLOR_TEXT_HINT)
    }
    .width('100%').padding({ left: 16, right: 16, top: 14, bottom: 14 })
  }

  @Builder
  settingDivider() {
    Divider()
      .color(Constants.COLOR_DIVIDER)
      .margin({ left: 50 })
  }
}

export default MineContent
