/**
 * @file 首页（应用主界面）
 * 顶部标题栏 + 用户信息 + Tabs + Navigation 子页面路由
 */

import { TAB_CONFIGS, TabConfig } from '../common/Constants'
import { OnsiteRegistrationPage } from './registration/OnsiteRegistrationPage'
import { RegistrationRecordPage } from './registration/RegistrationRecordPage'
import { ExpenseChargePage } from './registration/ExpenseChargePage'
import { ExpenseRefundPage } from './registration/ExpenseRefundPage'
import { ExpenseManagePage } from './registration/ExpenseManagePage'
import { logout } from '../services/AuthService'

@ComponentV2
export struct HomePage {
  @Event onLogout: () => void = () => {}

  @Local currentTabIndex: number = 0
  @Local loginUserStr: string = AppStorage.get<string>('loginUser') as string ?? ''

  // 主路由栈
  private navPathStack: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    AppStorage.on('change', 'loginUser', (val: string) => {
      this.loginUserStr = val
    })
  }

  /**
   * 获取登录用户名
   */
  getLoginUserName(): string {
    if (this.loginUserStr === '') {
      return ''
    }
    try {
      const user: Record<string, Object> = JSON.parse(this.loginUserStr) as Record<string, Object>
      return String(user['realname'] ?? '')
    } catch {
      return ''
    }
  }

  /**
   * 获取用户部门类型
   */
  getUserType(): string {
    if (this.loginUserStr === '') {
      return ''
    }
    try {
      const user: Record<string, Object> = JSON.parse(this.loginUserStr) as Record<string, Object>
      return String(user['dept_type'] ?? '')
    } catch {
      return ''
    }
  }

  /**
   * 判断Tab是否对当前用户可见
   */
  isTabVisible(tab: TabConfig): boolean {
    const userType: string = this.getUserType()
    if (userType === 'root') {
      return true
    }
    return tab.type === userType
  }

  /**
   * 退出登录
   */
  async handleLogout(): Promise<void> {
    await logout()
    this.onLogout()
  }

  build() {
    Navigation(this.navPathStack) {
      Column() {
        // 顶部标题栏
        Row() {
          Text('东软云医院 HIS')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .margin({ left: 16 })

          Blank()

          Row() {
            Text(this.getLoginUserName())
              .fontSize(14)
              .fontColor(Color.White)
              .margin({ right: 8 })
          }

          Button('退出')
            .fontSize(13)
            .fontColor(Color.White)
            .backgroundColor('#ff4d4f')
            .borderRadius(4)
            .height(32)
            .padding({ left: 12, right: 12 })
            .margin({ right: 16 })
            .onClick(() => {
              this.handleLogout()
            })
        }
        .width('100%')
        .height(56)
        .backgroundColor('#20A0FF')
        .alignItems(VerticalAlign.Center)

        // root用户警告
        if (this.getUserType() === 'root') {
          Text('注意：root账号可查看所有功能，请不要进行业务操作')
            .fontSize(12)
            .fontColor('#ff4d4f')
            .backgroundColor('#fff2f0')
            .width('100%')
            .padding({ left: 16, top: 6, bottom: 6 })
        }

        // 主体 Tabs
        Tabs({
          barPosition: BarPosition.End,
          index: this.currentTabIndex,
          controller: new TabsController()
        }) {
          ForEach(TAB_CONFIGS, (tab: TabConfig, index: number) => {
            if (this.isTabVisible(tab)) {
              TabContent() {
                // 模块首页：显示子功能按钮列表
                Column() {
                  Text(tab.name)
                    .fontSize(18)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#333333')
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .margin({ top: 24, bottom: 16, left: 16 })

                  if (index === 0) {
                    this.buildButton('窗口挂号', 'OnsiteRegistration')
                    this.buildButton('窗口退号', 'RegistrationRecord')
                    this.buildButton('收费', 'ExpenseCharge')
                    this.buildButton('退费', 'ExpenseRefund')
                    this.buildButton('费用记录查询', 'ExpenseManage')
                  } else if (index === 1) {
                    this.buildButton('患者查看', 'PhysicianPatient')
                    this.buildButton('看诊记录', 'PhysicianHistory')
                  } else if (index === 2) {
                    this.buildButton('检查申请', 'CheckApply')
                    this.buildButton('患者录入', 'CheckPatient')
                    this.buildButton('检查结果录入', 'CheckInput')
                    this.buildButton('检查管理', 'CheckManage')
                  } else if (index === 3) {
                    this.buildButton('检验申请', 'InspectionApply')
                    this.buildButton('患者录入', 'InspectionPatient')
                    this.buildButton('检验结果录入', 'InspectionInput')
                    this.buildButton('检验管理', 'InspectionManage')
                  } else if (index === 4) {
                    this.buildButton('药房发药', 'GiveMedicine')
                    this.buildButton('药房退药', 'RefundMedicine')
                    this.buildButton('药库管理', 'DrugStorage')
                    this.buildButton('交易记录', 'TranHistory')
                  } else if (index === 5) {
                    this.buildButton('处置申请', 'DisposalApply')
                    this.buildButton('患者录入', 'DisposalPatient')
                    this.buildButton('处置录入', 'DisposalInput')
                    this.buildButton('处置管理', 'DisposalManage')
                  }
                }
                .width('100%')
                .height('100%')
                .padding({ left: 16, right: 16 })
                .alignItems(HorizontalAlign.Start)
              }
              .tabBar(tab.name)
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f5f5f5')
    }
    .title('')
    .navDestination(this.pageRouter)
  }

  /**
   * 构建子功能按钮
   * @param label - 按钮文字
   * @param routeName - 路由名称
   */
  @Builder
  buildButton(label: string, routeName: string): void {
    Button(label)
      .fontSize(15)
      .fontColor('#333333')
      .backgroundColor(Color.White)
      .borderRadius(8)
      .height(52)
      .width('100%')
      .margin({ bottom: 10 })
      .shadow({ radius: 4, color: '#1a000000', offsetY: 2 })
      .align(Alignment.Start)
      .padding({ left: 20 })
      .onClick(() => {
        this.navPathStack.pushPath({ name: routeName })
      })
  }

  /**
   * 页面路由映射
   */
  @Builder
  pageRouter(name: string, param: ESObject): void {
    if (name === 'OnsiteRegistration') {
      OnsiteRegistrationPage()
    } else if (name === 'RegistrationRecord') {
      RegistrationRecordPage()
    } else if (name === 'ExpenseCharge') {
      ExpenseChargePage()
    } else if (name === 'ExpenseRefund') {
      ExpenseRefundPage()
    } else if (name === 'ExpenseManage') {
      ExpenseManagePage()
    }
  }
}
