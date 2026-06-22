import { StorageUtil } from '../common/StorageUtil'
import { AuthService } from '../services/AuthService'
import { User, userFromPlain } from '../models/User'
import LoginPage from './LoginPage'
import HomePage from './HomePage'

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
      // Restore auth session from storage
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
          } catch (_e) {
            // Corrupted user data - force re-login
            await StorageUtil.remove('Flag')
            await StorageUtil.remove('loginUser')
          }
        }
      }
    } catch (_e) {
      // Storage not ready or error - proceed to login
    }

    this.initialized = true

    // Schedule navigation after build cycle completes
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
        Image($r('app.media.startIcon'))
          .width(48).height(48)
        Text('云医院HIS')
          .fontSize(20).fontColor('#909399').margin({ top: 16 })
      }
      .width('100%').height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#F0F2F5')
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
