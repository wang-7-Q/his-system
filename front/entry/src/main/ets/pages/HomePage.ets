import { AuthService } from '../services/AuthService'
import { User } from '../models/User'
import { Constants, TabConfig } from '../common/Constants'

// Registration pages (5)
import OnsiteRegistrationPage from './registration/OnsiteRegistrationPage'
import RegistrationRecordPage from './registration/RegistrationRecordPage'
import ExpenseChargePage from './registration/ExpenseChargePage'
import ExpenseRefundPage from './registration/ExpenseRefundPage'
import ExpenseManagePage from './registration/ExpenseManagePage'

// Physician pages (11)
import PhysicianPatientPage from './physician/PhysicianPatientPage'
import PhysicianHistoryPage from './physician/PhysicianHistoryPage'
import HomeMedicalRecordPage from './physician/patient/HomeMedicalRecordPage'
import OutpatientDiagnosisPage from './physician/patient/OutpatientDiagnosisPage'
import CheckRequestPage from './physician/patient/CheckRequestPage'
import CheckResultsPage from './physician/patient/CheckResultsPage'
import InspectionRequestPage from './physician/patient/InspectionRequestPage'
import InspectionResultsPage from './physician/patient/InspectionResultsPage'
import DisposalRequestPage from './physician/patient/DisposalRequestPage'
import WritePrescriptionPage from './physician/patient/WritePrescriptionPage'
import ExpenseQueryPage from './physician/patient/ExpenseQueryPage'

// Check pages (4)
import CheckApplyPage from './check/CheckApplyPage'
import CheckPatientPage from './check/CheckPatientPage'
import CheckInputPage from './check/CheckInputPage'
import CheckManagePage from './check/CheckManagePage'

// Inspection pages (4)
import InspectionApplyPage from './inspection/InspectionApplyPage'
import InspectionPatientPage from './inspection/InspectionPatientPage'
import InspectionInputPage from './inspection/InspectionInputPage'
import InspectionManagePage from './inspection/InspectionManagePage'

// Drugstore pages (4)
import GiveMedicinePage from './drugstore/GiveMedicinePage'
import RefundMedicinePage from './drugstore/RefundMedicinePage'
import DrugStoragePage from './drugstore/DrugStoragePage'
import TranHistoryPage from './drugstore/TranHistoryPage'

// Disposal pages (4)
import DisposalApplyPage from './disposal/DisposalApplyPage'
import DisposalPatientPage from './disposal/DisposalPatientPage'
import DisposalInputPage from './disposal/DisposalInputPage'
import DisposalManagePage from './disposal/DisposalManagePage'

@ComponentV2
struct HomePage {
  @Local currentTab: number = 0
  @Local loginUser: User | null = null
  @Local userDeptType: string = ''
  @Event onLogout: () => void = () => {}

  // NavPathStacks per module
  private regStack: NavPathStack = new NavPathStack()
  private physStack: NavPathStack = new NavPathStack()
  private checkStack: NavPathStack = new NavPathStack()
  private inspStack: NavPathStack = new NavPathStack()
  private drugStack: NavPathStack = new NavPathStack()
  private dispStack: NavPathStack = new NavPathStack()

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
    this.onLogout()
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

      // Module tabs
      Tabs({ index: this.currentTab }) {
        ForEach(this.tabsForUser(), (tab: TabConfig, index: number) => {
          TabContent() {
            this.buildModuleNav(tab)
          }
          .tabBar(this.buildTabBar(tab, index))
        }, (tab: TabConfig) => tab.type)
      }
      .barHeight(56)
      .layoutWeight(1)

      // Root warning
      if (this.loginUser?.dept_type === 'root') {
        Text('警告: 请勿使用root账号执行具体业务操作')
          .fontSize(11).fontColor('#E6A23C').padding({ top: 4, bottom: 8 })
      }
    }
    .width('100%').height('100%')
    .backgroundColor('#F0F2F5')
  }

  @Builder
  buildModuleNav(tab: TabConfig) {
    if (tab.type === '挂号') {
      Navigation(this.regStack) {
        OnsiteRegistrationPage()
      }
      .navDestination(this.regRouterMap)
      .mode(NavigationMode.Stack)
      .hideTitleBar(true)
    } else if (tab.type === '门诊') {
      Navigation(this.physStack) {
        PhysicianPatientPage()
      }
      .navDestination(this.physRouterMap)
      .mode(NavigationMode.Stack)
      .hideTitleBar(true)
    } else if (tab.type === '检查') {
      Navigation(this.checkStack) {
        CheckApplyPage()
      }
      .navDestination(this.checkRouterMap)
      .mode(NavigationMode.Stack)
      .hideTitleBar(true)
    } else if (tab.type === '检验') {
      Navigation(this.inspStack) {
        InspectionApplyPage()
      }
      .navDestination(this.inspRouterMap)
      .mode(NavigationMode.Stack)
      .hideTitleBar(true)
    } else if (tab.type === '药房') {
      Navigation(this.drugStack) {
        GiveMedicinePage()
      }
      .navDestination(this.drugRouterMap)
      .mode(NavigationMode.Stack)
      .hideTitleBar(true)
    } else if (tab.type === '处置') {
      Navigation(this.dispStack) {
        DisposalApplyPage()
      }
      .navDestination(this.dispRouterMap)
      .mode(NavigationMode.Stack)
      .hideTitleBar(true)
    }
  }

  // ---- Router Maps ----

  @Builder
  regRouterMap(name: string, _param: Object) {
    if (name === 'RegistrationRecordPage') {
      NavDestination() { RegistrationRecordPage() }.hideTitleBar(true)
    } else if (name === 'ExpenseChargePage') {
      NavDestination() { ExpenseChargePage() }.hideTitleBar(true)
    } else if (name === 'ExpenseRefundPage') {
      NavDestination() { ExpenseRefundPage() }.hideTitleBar(true)
    } else if (name === 'ExpenseManagePage') {
      NavDestination() { ExpenseManagePage() }.hideTitleBar(true)
    }
  }

  @Builder
  physRouterMap(name: string, _param: Object) {
    if (name === 'PhysicianHistoryPage') {
      NavDestination() { PhysicianHistoryPage() }.hideTitleBar(true)
    } else if (name === 'HomeMedicalRecordPage') {
      NavDestination() { HomeMedicalRecordPage() }.hideTitleBar(true)
    } else if (name === 'OutpatientDiagnosisPage') {
      NavDestination() { OutpatientDiagnosisPage() }.hideTitleBar(true)
    } else if (name === 'CheckRequestPage') {
      NavDestination() { CheckRequestPage() }.hideTitleBar(true)
    } else if (name === 'CheckResultsPage') {
      NavDestination() { CheckResultsPage() }.hideTitleBar(true)
    } else if (name === 'InspectionRequestPage') {
      NavDestination() { InspectionRequestPage() }.hideTitleBar(true)
    } else if (name === 'InspectionResultsPage') {
      NavDestination() { InspectionResultsPage() }.hideTitleBar(true)
    } else if (name === 'DisposalRequestPage') {
      NavDestination() { DisposalRequestPage() }.hideTitleBar(true)
    } else if (name === 'WritePrescriptionPage') {
      NavDestination() { WritePrescriptionPage() }.hideTitleBar(true)
    } else if (name === 'ExpenseQueryPage') {
      NavDestination() { ExpenseQueryPage() }.hideTitleBar(true)
    }
  }

  @Builder
  checkRouterMap(name: string, _param: Object) {
    if (name === 'CheckPatientPage') {
      NavDestination() { CheckPatientPage() }.hideTitleBar(true)
    } else if (name === 'CheckInputPage') {
      NavDestination() { CheckInputPage() }.hideTitleBar(true)
    } else if (name === 'CheckManagePage') {
      NavDestination() { CheckManagePage() }.hideTitleBar(true)
    }
  }

  @Builder
  inspRouterMap(name: string, _param: Object) {
    if (name === 'InspectionPatientPage') {
      NavDestination() { InspectionPatientPage() }.hideTitleBar(true)
    } else if (name === 'InspectionInputPage') {
      NavDestination() { InspectionInputPage() }.hideTitleBar(true)
    } else if (name === 'InspectionManagePage') {
      NavDestination() { InspectionManagePage() }.hideTitleBar(true)
    }
  }

  @Builder
  drugRouterMap(name: string, _param: Object) {
    if (name === 'RefundMedicinePage') {
      NavDestination() { RefundMedicinePage() }.hideTitleBar(true)
    } else if (name === 'DrugStoragePage') {
      NavDestination() { DrugStoragePage() }.hideTitleBar(true)
    } else if (name === 'TranHistoryPage') {
      NavDestination() { TranHistoryPage() }.hideTitleBar(true)
    }
  }

  @Builder
  dispRouterMap(name: string, _param: Object) {
    if (name === 'DisposalPatientPage') {
      NavDestination() { DisposalPatientPage() }.hideTitleBar(true)
    } else if (name === 'DisposalInputPage') {
      NavDestination() { DisposalInputPage() }.hideTitleBar(true)
    } else if (name === 'DisposalManagePage') {
      NavDestination() { DisposalManagePage() }.hideTitleBar(true)
    }
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
