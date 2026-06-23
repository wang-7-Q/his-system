/**
 * @file 窗口挂号页面
 * 对应 Vue 版 onsite_registration.vue
 * 功能：基本信息 + 挂号信息表单，提交挂号
 */

import { promptAction } from '@kit.ArkUI'
import {
  addRegister,
  getRegistLevelList,
  getAllDeptList,
  getSettleCategory,
  getMaxCaseNumber,
  getRegistDoctorList,
  getAlreadyRegisterCount
} from '../../services/RegistrationService'
import { RegistLevel, Department, Doctor, SettleCategory } from '../../models/Registration'

@ComponentV2
export struct OnsiteRegistrationPage {
  // 表单数据
  @Local case_number: string = ''
  @Local real_name: string = ''
  @Local gender: string = '男'
  @Local age: string = ''
  @Local age_type: string = '年'
  @Local birthday: string = ''
  @Local card_number: string = ''
  @Local home_address: string = ''
  @Local settle_id: string = ''
  @Local visit_date: string = ''
  @Local noon: string = '上午'
  @Local deptment_id: string = ''
  @Local regist_level_id: string = ''
  @Local employee_id: string = ''
  @Local total_number: string = ''
  @Local used_number: string = '0'
  @Local is_book: boolean = false
  @Local regist_money: string = ''
  @Local regist_method: string = '医保卡'

  // 下拉数据源
  @Local register_level: RegistLevel[] = []
  @Local register_employee: Doctor[] = []
  @Local register_settle: SettleCategory[] = []
  @Local register_dept: Department[] = []

  aboutToAppear(): void {
    this.initDateTime()
    this.getRegistLevelList()
    this.getDeptList()
    this.getSettleCategory()
    this.getMaxCaseNumber()
  }

  /**
   * 初始化日期和时间
   */
  initDateTime(): void {
    const now: Date = new Date()
    const year: number = now.getFullYear()
    const month: number = now.getMonth() + 1
    const day: number = now.getDate()
    this.visit_date = year + '-' + month + '-' + day
    this.noon = now.getHours() <= 12 ? '上午' : '下午'
  }

  /**
   * 获取挂号级别
   */
  async getRegistLevelList(): Promise<void> {
    try {
      this.register_level = await getRegistLevelList()
    } catch {
      promptAction.showToast({ message: '获取挂号级别失败', duration: 1500 })
    }
  }

  /**
   * 获取科室列表
   */
  async getDeptList(): Promise<void> {
    try {
      this.register_dept = await getAllDeptList()
    } catch {
      promptAction.showToast({ message: '获取科室列表失败', duration: 1500 })
    }
  }

  /**
   * 获取结算类别
   */
  async getSettleCategory(): Promise<void> {
    try {
      this.register_settle = await getSettleCategory()
    } catch {
      promptAction.showToast({ message: '获取结算类别失败', duration: 1500 })
    }
  }

  /**
   * 获取最大病历号
   */
  async getMaxCaseNumber(): Promise<void> {
    try {
      const max: string = await getMaxCaseNumber()
      const num: number = parseInt(max)
      this.case_number = (num + 1).toString()
    } catch {
      promptAction.showToast({ message: '获取病历号失败', duration: 1500 })
    }
  }

  /**
   * 号别变化
   */
  async registerLevelChange(val: string): Promise<void> {
    this.is_book = false
    this.employee_id = ''
    for (const item of this.register_level) {
      if (val === item.sequence_no.toString()) {
        this.regist_money = item.regist_fee
        this.total_number = item.regist_quota
      }
    }
    // 重新加载医生列表
    try {
      this.register_employee = await getRegistDoctorList({
        deptment_id: this.deptment_id,
        regist_level_id: this.regist_level_id
      })
    } catch {
      this.register_employee = []
    }
  }

  /**
   * 医生变化，获取已用号额
   */
  async getAlreadyRegisterCount(): Promise<void> {
    try {
      const count: number = await getAlreadyRegisterCount({
        visitDate: this.visit_date,
        noon: this.noon,
        employeeId: this.employee_id
      })
      this.used_number = count.toString()
      if (count >= parseInt(this.total_number)) {
        promptAction.showToast({ message: '警告，该医生号额已满，请选择其他医生', duration: 2000 })
      }
    } catch {
      this.used_number = '0'
    }
  }

  /**
   * 病历本开关
   */
  registerIsbookChange(): void {
    const currentMoney: number = parseFloat(this.regist_money) || 0
    if (this.is_book) {
      this.regist_money = (currentMoney + 1).toFixed(2)
    } else {
      this.regist_money = (currentMoney - 1).toFixed(2)
    }
  }

  /**
   * 添加挂号
   */
  async addNewRegist(): Promise<void> {
    if (isNaN(parseInt(this.case_number))) {
      promptAction.showToast({ message: '病历号必须为数字', duration: 1500 })
      return
    }
    const data: Record<string, Object | undefined> = {
      case_number: this.case_number,
      real_name: this.real_name,
      gender: this.gender,
      age: this.age,
      age_type: this.age_type,
      birthday: this.birthday,
      card_number: this.card_number,
      home_address: this.home_address,
      visit_date: this.visit_date,
      noon: this.noon,
      deptment_id: this.deptment_id,
      employee_id: this.employee_id,
      regist_level_id: this.regist_level_id,
      settle_category_id: '1',
      is_book: this.is_book ? '1' : '0',
      regist_method: this.regist_method,
      regist_money: this.regist_money,
      used_number: this.used_number,
      total_number: this.total_number,
      settle_id: this.settle_id
    }
    try {
      const resp: string = await addRegister(data)
      promptAction.showToast({ message: resp, duration: 1500 })
      this.clearRegist()
    } catch {
      promptAction.showToast({ message: '挂号失败', duration: 1500 })
    }
  }

  /**
   * 清空表单
   */
  clearRegist(): void {
    this.real_name = ''
    this.gender = '男'
    this.card_number = ''
    this.birthday = ''
    this.age = ''
    this.age_type = '年'
    this.home_address = ''
    this.initDateTime()
    this.settle_id = ''
    this.deptment_id = ''
    this.employee_id = ''
    this.regist_level_id = ''
    this.is_book = false
    this.used_number = '0'
    this.regist_method = '医保卡'
    this.regist_money = ''
    this.used_number = '0'
    this.total_number = ''
    this.getMaxCaseNumber()
  }

  build() {
    NavDestination() {
      Column() {
        // 操作按钮
        Row() {
          Button('挂号')
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('#20A0FF')
            .borderRadius(4)
            .height(36)
            .padding({ left: 20, right: 20 })
            .margin({ right: 12 })
            .onClick(() => {
              this.addNewRegist()
            })

          Button('清空')
            .fontSize(14)
            .fontColor('#666666')
            .backgroundColor('#f5f5f5')
            .borderRadius(4)
            .height(36)
            .padding({ left: 20, right: 20 })
            .onClick(() => {
              this.clearRegist()
            })
        }
        .width('100%')
        .margin({ bottom: 16 })

        // 基本信息
        Text('基本信息')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .margin({ bottom: 12 })

        Column() {
          // 第一行：病历号 姓名 性别
          Row() {
            Column() {
              Text('病历号')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: '病历号' })
                .value(this.case_number)
                .onChange((val: string) => { this.case_number = val })
                .fontSize(13)
                .height(36)
                .width('90%')
            }
            .constraintWidth({ min: 80, max: 150 })

            Column() {
              Text('姓名')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: '姓名' })
                .value(this.real_name)
                .onChange((val: string) => { this.real_name = val })
                .fontSize(13)
                .height(36)
                .width('90%')
            }
            .constraintWidth({ min: 80, max: 150 })

            Column() {
              Text('性别')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: '男/女' })
                .value(this.gender)
                .onChange((val: string) => { this.gender = val })
                .fontSize(13)
                .height(36)
                .width('90%')
            }
            .constraintWidth({ min: 80, max: 150 })
          }
          .width('100%')
          .margin({ bottom: 8 })

          // 第二行：年龄 年龄类型 出生日期
          Row() {
            Column() {
              Text('年龄')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: '年龄' })
                .value(this.age)
                .onChange((val: string) => { this.age = val })
                .fontSize(13)
                .height(36)
                .width('45%')
            }
            .constraintWidth({ min: 80, max: 150 })

            Column() {
              Text('年龄类型')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: '年/天' })
                .value(this.age_type)
                .onChange((val: string) => { this.age_type = val })
                .fontSize(13)
                .height(36)
                .width('45%')
            }
            .constraintWidth({ min: 80, max: 150 })

            Column() {
              Text('出生日期')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: 'yyyy-MM-dd' })
                .value(this.birthday)
                .onChange((val: string) => { this.birthday = val })
                .fontSize(13)
                .height(36)
                .width('90%')
            }
            .constraintWidth({ min: 80, max: 150 })
          }
          .width('100%')
          .margin({ bottom: 8 })

          // 第三行：身份证号 家庭住址
          Row() {
            Column() {
              Text('身份证号')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: '身份证号' })
                .value(this.card_number)
                .onChange((val: string) => { this.card_number = val })
                .fontSize(13)
                .height(36)
                .width('95%')
            }
            .layoutWeight(1)

            Column() {
              Text('家庭住址')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: '家庭住址（可选）' })
                .value(this.home_address)
                .onChange((val: string) => { this.home_address = val })
                .fontSize(13)
                .height(36)
                .width('95%')
            }
            .layoutWeight(1)
          }
          .width('100%')
        }
        .width('100%')
        .padding(16)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 16 })

        // 挂号信息
        Text('挂号信息')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .margin({ bottom: 12 })

        Column() {
          // 第一行：结算类别 看诊日期 午别
          Row() {
            Column() {
              Text('结算类别')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: '结算类别' })
                .value(this.settle_id)
                .onChange((val: string) => { this.settle_id = val })
                .fontSize(13)
                .height(36)
                .width('90%')
            }
            .constraintWidth({ min: 80, max: 150 })

            Column() {
              Text('看诊日期')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({})
                .value(this.visit_date)
                .fontSize(13)
                .height(36)
                .width('90%')
                .enabled(false)
            }
            .constraintWidth({ min: 80, max: 150 })

            Column() {
              Text('午别')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({})
                .value(this.noon)
                .fontSize(13)
                .height(36)
                .width('90%')
                .enabled(false)
            }
            .constraintWidth({ min: 80, max: 150 })
          }
          .width('100%')
          .margin({ bottom: 8 })

          // 第二行：挂号科室 号别
          Row() {
            Column() {
              Text('挂号科室')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: '科室ID' })
                .value(this.deptment_id)
                .onChange((val: string) => { this.deptment_id = val })
                .fontSize(13)
                .height(36)
                .width('95%')
            }
            .layoutWeight(1)

            Column() {
              Text('号别')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: '号别ID' })
                .value(this.regist_level_id)
                .onChange((val: string) => {
                  this.regist_level_id = val
                  this.registerLevelChange(val)
                })
                .fontSize(13)
                .height(36)
                .width('95%')
            }
            .layoutWeight(1)
          }
          .width('100%')
          .margin({ bottom: 8 })

          // 第三行：看诊医生
          Row() {
            Column() {
              Text('看诊医生')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: '医生ID' })
                .value(this.employee_id)
                .onChange((val: string) => {
                  this.employee_id = val
                  this.getAlreadyRegisterCount()
                })
                .fontSize(13)
                .height(36)
                .width('95%')
            }
            .layoutWeight(1)
          }
          .width('100%')
          .margin({ bottom: 8 })

          // 第四行：初始号额 已用号额
          Row() {
            Column() {
              Text('初始号额')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({})
                .value(this.total_number)
                .fontSize(13)
                .height(36)
                .width('90%')
                .enabled(false)
            }
            .constraintWidth({ min: 80, max: 150 })

            Column() {
              Text('已用号额')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({})
                .value(this.used_number)
                .fontSize(13)
                .height(36)
                .width('90%')
                .enabled(false)
            }
            .constraintWidth({ min: 80, max: 150 })

            Column() {
              Text('病历本')
                .fontSize(12)
                .fontColor('#666666')
              ToggleSwitch({ isOn: this.is_book })
                .onChange((val: boolean) => {
                  this.is_book = val
                  this.registerIsbookChange()
                })
            }
            .constraintWidth({ min: 80, max: 150 })
          }
          .width('100%')
          .margin({ bottom: 8 })

          // 第五行：应收金额 收费方式
          Row() {
            Column() {
              Text('应收金额')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({})
                .value(this.regist_money)
                .fontSize(13)
                .height(36)
                .width('90%')
                .enabled(false)
            }
            .constraintWidth({ min: 80, max: 150 })

            Column() {
              Text('收费方式')
                .fontSize(12)
                .fontColor('#666666')
              TextInput({ placeholder: '现金/微信/支付宝/银行卡/医保卡' })
                .value(this.regist_method)
                .onChange((val: string) => { this.regist_method = val })
                .fontSize(13)
                .height(36)
                .width('90%')
            }
            .constraintWidth({ min: 80, max: 150 })
          }
          .width('100%')
        }
        .width('100%')
        .padding(16)
        .backgroundColor(Color.White)
        .borderRadius(8)
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor('#f5f5f5')
      .scrollable(ScrollDirection.Vertical)
    }
    .title('窗口挂号')
  }
}
