/**
 * @file 应用根入口页面
 * 根据登录状态切换显示 LoginPage 或 HomePage
 */

import { isLoggedIn, getLoginUser } from '../common/StorageUtil'
import { LoginPage } from './LoginPage'
import { HomePage } from './HomePage'

@ComponentV2
export struct AppEntry {
  @Local currentPage: string = 'LoginPage'

  aboutToAppear(): void {
    this.checkLoginState()
  }

  async checkLoginState(): Promise<void> {
    try {
      const loggedIn: boolean = await isLoggedIn()
      if (loggedIn) {
        AppStorage.set<string>('Flag', 'isLogin')
        const userData = await getLoginUser()
        if (userData != null) {
          AppStorage.set<string>('loginUser', JSON.stringify(userData))
        }
        this.currentPage = 'HomePage'
      } else {
        this.currentPage = 'LoginPage'
      }
    } catch {
      this.currentPage = 'LoginPage'
    }
  }

  build() {
    Column() {
      if (this.currentPage === 'LoginPage') {
        LoginPage({
          onLoginSuccess: () => {
            this.currentPage = 'HomePage'
          }
        })
      } else if (this.currentPage === 'HomePage') {
        HomePage({
          onLogout: () => {
            this.currentPage = 'LoginPage'
          }
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}
