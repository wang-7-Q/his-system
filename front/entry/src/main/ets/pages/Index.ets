import { hilog } from '@kit.PerformanceAnalysisKit'
import { StorageUtil } from '../common/StorageUtil'
import { AuthService } from '../services/AuthService'
import { User, userFromPlain } from '../models/User'
import { Constants } from '../common/Constants'
import LoginPage from './LoginPage'
import HomePage from './HomePage'

const DOMAIN = 0x0000

@Entry
@ComponentV2
struct Index {
  @Local navPathStack: NavPathStack = new NavPathStack()
  @Local initialized: boolean = false

  aboutToAppear(): void {
    this.initApp()
  }

  private async initApp(): Promise<void> {
    try {
      await AuthService.restoreSession()

      const loggedIn: boolean = await StorageUtil.isLoggedIn()
      if (loggedIn) {
        const userJson: string = await StorageUtil.getLoginUser()
        if (userJson) {
          try {
            const parsed: Record<string, Object> = JSON.parse(userJson) as Record<string, Object>
            const user: User = userFromPlain(parsed)
            AppStorage.setOrCreate('loginUser', user)
            AppStorage.setOrCreate('isLoggedIn', true)
          } catch (e) {
            hilog.error(DOMAIN, 'Index', 'Corrupted loginUser data: %{public}s', JSON.stringify(e))
            await StorageUtil.remove('Flag')
            await StorageUtil.remove('loginUser')
          }
        }
      }
    } catch (e) {
      hilog.error(DOMAIN, 'Index', 'Failed to init: %{public}s', JSON.stringify(e))
    }

    this.initialized = true

    setTimeout(() => {
      if (this.initialized) {
        const isLoggedIn: boolean = AppStorage.get<boolean>('isLoggedIn') === true
        if (isLoggedIn) {
          this.navPathStack.pushPath({ name: 'HomePage' })
        } else {
          this.navPathStack.pushPath({ name: 'LoginPage' })
        }
      }
    }, 50)
  }

  build() {
    Navigation(this.navPathStack) {
      Column() {
        Stack() {
          Circle()
            .width(80)
            .height(80)
            .fill('rgba(22,119,255,0.08)')
          Circle()
            .width(64)
            .height(64)
            .fill('rgba(22,119,255,0.15)')
          Image($r('app.media.startIcon'))
            .width(44)
            .height(44)
            .borderRadius(10)
        }
        .margin({ bottom: 20 })

        Text('东软云医院 HIS')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)

        Text('Hospital Information System')
          .fontSize(12)
          .fontColor(Constants.COLOR_TEXT_HINT)
          .margin({ top: 8 })
          .letterSpacing(2)

        LoadingProgress()
          .width(24)
          .height(24)
          .color(Constants.COLOR_PRIMARY)
          .margin({ top: 36 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Constants.COLOR_BG)
    }
    .navDestination(this.routerMap)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }

  @Builder
  routerMap(name: string, param: Object) {
    if (name === 'LoginPage') {
      NavDestination() {
        LoginPage({
          onLoginSuccess: () => {
            this.navPathStack.replacePath({ name: 'HomePage' })
          },
        })
      }
      .hideTitleBar(true)
    } else if (name === 'HomePage') {
      NavDestination() {
        HomePage({
          onLogout: () => {
            this.navPathStack.clear()
            this.navPathStack.pushPath({ name: 'LoginPage' })
          },
        })
      }
      .hideTitleBar(true)
    }
  }
}
