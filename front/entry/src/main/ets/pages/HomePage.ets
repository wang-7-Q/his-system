import { Constants } from '../common/Constants'

// Tab content pages
import HomeContent from './HomeContent'
import WorkbenchContent from './WorkbenchContent'
import MineContent from './MineContent'

/**
 * Main home page with WeChat-style bottom navigation bar.
 * Three bottom tabs: Home / Workbench / Mine.
 * Custom tab bar drawn below Tabs content area.
 */
@ComponentV2
struct HomePage {
  @Local currentTab: number = 0
  @Event onLogout: () => void = () => {}

  build() {
    Column() {
      // Main content — fills remaining space
      Tabs({ index: this.currentTab }) {
        TabContent() {
          HomeContent()
        }
        .tabBar(this.emptyTabBar)

        TabContent() {
          WorkbenchContent()
        }
        .tabBar(this.emptyTabBar)

        TabContent() {
          MineContent({ onLogout: this.onLogout })
        }
        .tabBar(this.emptyTabBar)
      }
      .barHeight(0)
      .layoutWeight(1)
      .onChange((index: number) => {
        this.currentTab = index
      })

      // ════ Custom bottom tab bar (WeChat style) ════
      Divider()
        .color(Constants.COLOR_DIVIDER)
        .strokeWidth(0.5)

      Row() {
        // Tab 0: Home
        Column() {
          Text('🏠')
            .fontSize(22)
            .margin({ bottom: 2 })
            .fontColor(this.currentTab === 0 ? Constants.COLOR_TAB_ACTIVE : Constants.COLOR_TAB_INACTIVE)
          Text('首页')
            .fontSize(10)
            .fontWeight(this.currentTab === 0 ? FontWeight.Medium : FontWeight.Normal)
            .fontColor(this.currentTab === 0 ? Constants.COLOR_TAB_ACTIVE : Constants.COLOR_TAB_INACTIVE)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .padding({ top: 4, bottom: 4 })
        .onClick(() => { this.currentTab = 0 })

        // Tab 1: Workbench
        Column() {
          Text('💼')
            .fontSize(22)
            .margin({ bottom: 2 })
            .fontColor(this.currentTab === 1 ? Constants.COLOR_TAB_ACTIVE : Constants.COLOR_TAB_INACTIVE)
          Text('工作台')
            .fontSize(10)
            .fontWeight(this.currentTab === 1 ? FontWeight.Medium : FontWeight.Normal)
            .fontColor(this.currentTab === 1 ? Constants.COLOR_TAB_ACTIVE : Constants.COLOR_TAB_INACTIVE)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .padding({ top: 4, bottom: 4 })
        .onClick(() => { this.currentTab = 1 })

        // Tab 2: Mine
        Column() {
          Text('👤')
            .fontSize(22)
            .margin({ bottom: 2 })
            .fontColor(this.currentTab === 2 ? Constants.COLOR_TAB_ACTIVE : Constants.COLOR_TAB_INACTIVE)
          Text('我的')
            .fontSize(10)
            .fontWeight(this.currentTab === 2 ? FontWeight.Medium : FontWeight.Normal)
            .fontColor(this.currentTab === 2 ? Constants.COLOR_TAB_ACTIVE : Constants.COLOR_TAB_INACTIVE)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .padding({ top: 4, bottom: 4 })
        .onClick(() => { this.currentTab = 2 })
      }
      .width('100%')
      .height(56)
      .backgroundColor(Constants.COLOR_CARD)
      .padding({ bottom: 4 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  emptyTabBar() {
    Column() {}
  }
}

export default HomePage
