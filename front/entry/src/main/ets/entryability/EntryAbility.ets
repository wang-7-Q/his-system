import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { StorageUtil } from '../common/StorageUtil';
import { BreakpointSystem } from '../common/BreakpointSystem';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    AppStorage.setOrCreate('isLoggedIn', false);
    AppStorage.setOrCreate('loginUser', null);
    hilog.info(DOMAIN, 'HIS', '%{public}s', 'Application onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'HIS', '%{public}s', 'Application onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    hilog.info(DOMAIN, 'HIS', '%{public}s', 'Ability onWindowStageCreate');

    try {
      const windowClass = await windowStage.getMainWindow();

      // Initialize StorageUtil
      await StorageUtil.init(this.context);

      // Set up breakpoint system for responsive layout
      BreakpointSystem.updateBreakpoint(windowClass);
      windowClass.on('windowSizeChange', () => {
        BreakpointSystem.updateBreakpoint(windowClass);
      });
    } catch (err) {
      hilog.error(DOMAIN, 'HIS', 'Window init error: %{public}s', JSON.stringify(err));
    }

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'HIS', 'Failed to load content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'HIS', 'Succeeded in loading content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'HIS', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'HIS', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'HIS', '%{public}s', 'Ability onBackground');
  }
}
