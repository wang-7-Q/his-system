import { ModuleConfig, Constants } from '../common/Constants'
import { User } from '../models/User'

// Registration pages
import OnsiteRegistrationPage from './registration/OnsiteRegistrationPage'
import RegistrationRecordPage from './registration/RegistrationRecordPage'
import ExpenseChargePage from './registration/ExpenseChargePage'
import ExpenseRefundPage from './registration/ExpenseRefundPage'
import ExpenseManagePage from './registration/ExpenseManagePage'

// Physician pages
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

// Check pages
import CheckApplyPage from './check/CheckApplyPage'
import CheckPatientPage from './check/CheckPatientPage'
import CheckInputPage from './check/CheckInputPage'
import CheckManagePage from './check/CheckManagePage'

// Inspection pages
import InspectionApplyPage from './inspection/InspectionApplyPage'
import InspectionPatientPage from './inspection/InspectionPatientPage'
import InspectionInputPage from './inspection/InspectionInputPage'
import InspectionManagePage from './inspection/InspectionManagePage'

// Drugstore pages
import GiveMedicinePage from './drugstore/GiveMedicinePage'
import RefundMedicinePage from './drugstore/RefundMedicinePage'
import DrugStoragePage from './drugstore/DrugStoragePage'
import TranHistoryPage from './drugstore/TranHistoryPage'

// Disposal pages
import DisposalApplyPage from './disposal/DisposalApplyPage'
import DisposalPatientPage from './disposal/DisposalPatientPage'
import DisposalInputPage from './disposal/DisposalInputPage'
import DisposalManagePage from './disposal/DisposalManagePage'

/**
 * Workbench tab — shows available module cards filtered by user role.
 * Uses a single Navigation stack for all module pages and their sub-pages.
 */
@ComponentV2
struct WorkbenchContent {
  @Local loginUser: User | null = null
  @Local userDeptType: string = ''
  @Local modules: ModuleConfig[] = []
  @Local workbenchStack: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    this.loginUser = AppStorage.get<User>('loginUser') || null
    if (this.loginUser) {
      this.userDeptType = this.loginUser.dept_type
    }
    this.modules = this.filteredModules()
  }

  private filteredModules(): ModuleConfig[] {
    if (!this.loginUser || this.userDeptType === 'root') {
      return Constants.MODULE_CONFIGS
    }
    const result: ModuleConfig[] = []
    for (let i = 0; i < Constants.MODULE_CONFIGS.length; i++) {
      if (Constants.MODULE_CONFIGS[i].type === this.userDeptType) {
        result.push(Constants.MODULE_CONFIGS[i])
      }
    }
    return result
  }

  build() {
    Navigation(this.workbenchStack) {
      Column() {
        // ── Section header ──
        Text('业务模块')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(Constants.COLOR_TEXT_PRIMARY)
          .margin({ bottom: 12, left: 16, right: 16 })
          .alignSelf(ItemAlign.Start)

        // ── Module grid ──
        Grid() {
          ForEach(this.modules, (mod: ModuleConfig) => {
            GridItem() {
              this.moduleCard(mod)
            }
          }, (mod: ModuleConfig) => mod.type)
        }
        .columnsTemplate('1fr 1fr')
        .rowsGap(12)
        .columnsGap(12)
        .width('100%')
        .padding({ left: 16, right: 16 })

        // ── Root warning ──
        if (this.userDeptType === 'root') {
          Text('⚠️ 请勿使用 root 账号执行具体业务操作')
            .fontSize(12)
            .fontColor(Constants.COLOR_WARNING)
            .margin({ top: 16, left: 16, right: 16 })
        }
      }
      .width('100%')
      .height('100%')
      .padding({ top: 8, bottom: 80 })
      .backgroundColor(Constants.COLOR_BG)
    }
    .navDestination(this.moduleRouterMap)
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
  }

  @Builder
  moduleCard(mod: ModuleConfig) {
    Column() {
      Text(mod.icon)
        .fontSize(36)
        .margin({ bottom: 8 })
      Text(mod.name)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(Constants.COLOR_TEXT_PRIMARY)
        .margin({ bottom: 4 })
      Text(mod.description)
        .fontSize(11)
        .fontColor(Constants.COLOR_TEXT_HINT)
        .maxLines(2)
        .textAlign(TextAlign.Center)
        .lineHeight(16)
    }
    .width('100%')
    .padding({ top: 20, bottom: 20, left: 8, right: 8 })
    .borderRadius(12)
    .backgroundColor(Constants.COLOR_CARD)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)' })
    .onClick(() => {
      this.workbenchStack.pushPath({ name: mod.type })
    })
  }

  // ── Unified router map for all module pages & sub-pages ─────

  @Builder
  moduleRouterMap(name: string, _param: Object) {
    // ── Registration (挂号收费) ──
    if (name === '挂号') {
      NavDestination() {
        OnsiteRegistrationPage({ navStack: this.workbenchStack })
      }
      .hideTitleBar(true)
    } else if (name === 'RegistrationRecordPage') {
      NavDestination() { RegistrationRecordPage() }.hideTitleBar(true)
    } else if (name === 'ExpenseChargePage') {
      NavDestination() { ExpenseChargePage() }.hideTitleBar(true)
    } else if (name === 'ExpenseRefundPage') {
      NavDestination() { ExpenseRefundPage() }.hideTitleBar(true)
    } else if (name === 'ExpenseManagePage') {
      NavDestination() { ExpenseManagePage() }.hideTitleBar(true)
    }

    // ── Physician (门诊医生) ──
    if (name === '门诊') {
      NavDestination() {
        PhysicianPatientPage({ navStack: this.workbenchStack })
      }
      .hideTitleBar(true)
    } else if (name === 'PhysicianHistoryPage') {
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

    // ── Check (检查管理) ──
    if (name === '检查') {
      NavDestination() {
        CheckApplyPage()
      }
      .hideTitleBar(true)
    } else if (name === 'CheckPatientPage') {
      NavDestination() { CheckPatientPage() }.hideTitleBar(true)
    } else if (name === 'CheckInputPage') {
      NavDestination() { CheckInputPage() }.hideTitleBar(true)
    } else if (name === 'CheckManagePage') {
      NavDestination() { CheckManagePage() }.hideTitleBar(true)
    }

    // ── Inspection (检验管理) ──
    if (name === '检验') {
      NavDestination() {
        InspectionApplyPage()
      }
      .hideTitleBar(true)
    } else if (name === 'InspectionPatientPage') {
      NavDestination() { InspectionPatientPage() }.hideTitleBar(true)
    } else if (name === 'InspectionInputPage') {
      NavDestination() { InspectionInputPage() }.hideTitleBar(true)
    } else if (name === 'InspectionManagePage') {
      NavDestination() { InspectionManagePage() }.hideTitleBar(true)
    }

    // ── Drugstore (药房管理) ──
    if (name === '药房') {
      NavDestination() {
        GiveMedicinePage()
      }
      .hideTitleBar(true)
    } else if (name === 'RefundMedicinePage') {
      NavDestination() { RefundMedicinePage() }.hideTitleBar(true)
    } else if (name === 'DrugStoragePage') {
      NavDestination() { DrugStoragePage() }.hideTitleBar(true)
    } else if (name === 'TranHistoryPage') {
      NavDestination() { TranHistoryPage() }.hideTitleBar(true)
    }

    // ── Disposal (处置管理) ──
    if (name === '处置') {
      NavDestination() {
        DisposalApplyPage()
      }
      .hideTitleBar(true)
    } else if (name === 'DisposalPatientPage') {
      NavDestination() { DisposalPatientPage() }.hideTitleBar(true)
    } else if (name === 'DisposalInputPage') {
      NavDestination() { DisposalInputPage() }.hideTitleBar(true)
    } else if (name === 'DisposalManagePage') {
      NavDestination() { DisposalManagePage() }.hideTitleBar(true)
    }
  }
}

export default WorkbenchContent
