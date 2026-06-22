import { AuthService } from '../services/AuthService'
import { User } from '../models/User'
import { Constants, TabConfig } from '../common/Constants'

@ComponentV2
struct HomePage {
  @Local currentTab: number = 0
  @Local loginUser: User | null = null
  @Local userDeptType: string = ''
  @Event onLogout?: () => void

  aboutToAppear(): void {
    this.loadUser()
  }

  private loadUser(): void {
    const cached: User | undefined = AppStorage.get<User>('loginUser')
    if (cached) {
      this.loginUser = cached
      this.userDeptType = cached.dept_type
    }
  }

  private tabsForUser(): TabConfig[] {
    if (!this.loginUser || this.userDeptType === 'root') {
      return Constants.TAB_CONFIGS
    }
    const filtered: TabConfig[] = []
    for (let i = 0; i < Constants.TAB_CONFIGS.length; i++) {
      if (Constants.TAB_CONFIGS[i].type === this.userDeptType) {
        filtered.push(Constants.TAB_CONFIGS[i])
      }
    }
    return filtered
  }

  private async onLogoutAction(): Promise<void> {
    await AuthService.logout()
    this.onLogout?.()
  }

  build() {
    Column() {
      // Header bar
      Row() {
        Text('云医院HIS - ' + (this.loginUser?.realname || ''))
          .fontSize(16).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
          .layoutWeight(1)
        Row() {
          Text(this.loginUser?.dept_name || '')
            .fontSize(13).fontColor('#FFFFFF').margin({ right: 16 })
          Button('退出')
            .fontSize(13).backgroundColor(Color.Transparent).fontColor('#FFFFFF')
            .border({ width: 1, color: '#FFFFFF' })
            .onClick(() => this.onLogoutAction())
        }
      }
      .width('100%').height(48)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#20A0FF')

      // Tab content area
      Tabs({ index: this.currentTab }) {
        ForEach(this.tabsForUser(), (tab: TabConfig, index: number) => {
          TabContent() {
            Navigation(new NavPathStack()) {
              Column() {
                Text(tab.name + '模块')
                  .fontSize(16)
                Text('模块页面开发中...')
                  .fontSize(14).fontColor('#909399').margin({ top: 20 })
              }
              .width('100%').height('100%')
              .justifyContent(FlexAlign.Center)
            }
            .mode(NavigationMode.Stack)
            .hideTitleBar(true)
          }
          .tabBar(this.buildTabBar(tab, index))
        }, (tab: TabConfig) => tab.type)
      }
      .barHeight(56)
      .layoutWeight(1)

      // Root account warning
      if (this.loginUser?.dept_type === 'root') {
        Text('警告: 请勿使用root账号执行具体业务操作')
          .fontSize(11).fontColor('#E6A23C').padding({ top: 4, bottom: 8 })
      }
    }
    .width('100%').height('100%')
    .backgroundColor('#F0F2F5')
  }

  @Builder
  buildTabBar(tab: TabConfig, index: number) {
    Column() {
      Image($r('app.media.startIcon'))
        .width(24).height(24)
        .fillColor(index === this.currentTab ? '#20A0FF' : '#909399')
      Text(tab.name)
        .fontSize(11)
        .fontColor(index === this.currentTab ? '#20A0FF' : '#909399')
    }
  }
}

export default HomePage
