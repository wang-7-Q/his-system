/**
 * @file 应用程序入口 Ability
 * 初始化存储、断点监听、加载根页面
 */

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { window } from '@kit.ArkUI'
import { initStorage } from '../common/StorageUtil'
import { updateBreakpoint } from '../common/BreakpointSystem'

const DOMAIN: number = 0x0000

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'EntryAbility', 'Ability onCreate')
    AppStorage.set<string>('Flag', '')
    AppStorage.set<string>('loginUser', '')
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'EntryAbility', 'Ability onDestroy')
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    hilog.info(DOMAIN, 'EntryAbility', 'Ability onWindowStageCreate')

    try {
      await initStorage(this.context)
    } catch (error) {
      hilog.error(DOMAIN, 'EntryAbility', 'Storage init failed: %{public}s', JSON.stringify(error))
    }

    windowStage.loadContent('pages/AppEntry', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'EntryAbility', 'Failed to load content: %{public}s', JSON.stringify(err))
        return
      }
      hilog.info(DOMAIN, 'EntryAbility', 'Succeeded in loading content')
    })

    const windowClass: window.Window = windowStage.getMainWindowSync()
    updateBreakpoint(windowClass)
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'EntryAbility', 'Ability onWindowStageDestroy')
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'EntryAbility', 'Ability onForeground')
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'EntryAbility', 'Ability onBackground')
  }
}
