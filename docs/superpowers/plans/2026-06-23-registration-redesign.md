# 挂号模块重新设计 — 实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 重构挂号收费模块5个页面，补齐缺失功能，修复API对接错误，以工作台模式组织导航。

**Architecture:** MVVM模式，V2状态管理，Navigation路由。主页面 RegistrationWorkbenchPage 作为挂号工作台，通过 navPathStack 导航到4个子页面。Drawer 面板替代 Dialog 弹窗填写挂号表单。

**Tech Stack:** HarmonyOS ArkTS V2, ArkUI, Navigation, @kit.NetworkKit

---

## 文件结构

```
Modify:
  front/entry/src/main/ets/models/Registration.ets     — 扩展数据模型
  front/entry/src/main/ets/models/RestBean.ets         — 添加 RestBeanMap / ExpenseItem
  front/entry/src/main/ets/services/RegistrationService.ets — 修复API签名

Rewrite:
  front/entry/src/main/ets/pages/registration/OnsiteRegistrationPage.ets → 挂号工作台+Drawer表单
  front/entry/src/main/ets/pages/registration/ExpenseChargePage.ets      → 搜索+多选+收费
  front/entry/src/main/ets/pages/registration/ExpenseRefundPage.ets      → 搜索+多选+退费

Minor modify:
  front/entry/src/main/ets/pages/registration/RegistrationRecordPage.ets — 添加搜索

Modify:
  front/entry/src/main/ets/pages/HomePage.ets          — 传递 navStack @Param

No change:
  front/entry/src/main/ets/pages/registration/ExpenseManagePage.ets     — 保持不变
```

---

### Task 1: 扩展数据模型

**Files:**
- Modify: `front/entry/src/main/ets/models/Registration.ets`
- Modify: `front/entry/src/main/ets/models/RestBean.ets`

- [ ] **Step 1: 更新 Registration.ets — 扩展 Registration 接口和 RegisLevel/Doctor**

替换 `front/entry/src/main/ets/models/Registration.ets` 全部内容为：

```typescript
// 挂号记录 — 完整字段对齐后端 addRegister 参数
export interface Registration {
  id: number
  regist_id: string
  patient_id: number
  patient_name: string
  dept_id: number
  dept_name: string
  doctor_id: number
  doctor_name: string
  regist_level: string
  settle_category: string
  status: string
  regist_date: string
  case_number: string
}

// 挂号级别 — 对齐后端 getRegistLevelList 返回的数据库字段
export interface RegistLevel {
  id: number
  regist_name: string
  regist_fee: string
  regist_quota: string
  sequence_no: number
}

// 科室 — 对齐后端 getAllDeptList 返回字段
export interface Department {
  id: number
  dept_name: string
  dept_code: string
  dept_type: string
}

// 医生 — 对齐后端 getRegistDoctorList 返回字段
export interface Doctor {
  id: number
  realname: string
  username: string
  dept_type: string
  dept_name: string
  regist_level_id: string
  regist_level: string
}

// 结算类别 — 对齐后端 getSettleCategory 返回字段
export interface SettleCategory {
  id: number
  settle_name: string
}
```

- [ ] **Step 2: 更新 RestBean.ets — 添加 RestBeanMap 和 ExpenseItem**

替换 `front/entry/src/main/ets/models/RestBean.ets` 全部内容为：

```typescript
export interface RestBean<T> {
  list: T[]
  totalCount: number
  msg: string
  status: number
}

export function createRestBean<T>(list: T[], msg: string, status: number): RestBean<T> {
  return { list: list, totalCount: list.length, msg: msg, status: status } as RestBean<T>
}

// 后端 searchExpenseChargePatient / searchExpenseRefundPatient 返回格式
export interface RestBeanMap {
  msg: string
  status: number
  registMap: Object | null
  requestList: ExpenseItem[]
}

// 收费/退费项目
export interface ExpenseItem {
  id: number
  item_name: string
  item_price: string
  item_type: string
  item_format: string
  item_number: string
  item_create_time: string
  regist_id: number
  case_number: string
  patient_name: string
  status: string
}
```

- [ ] **Step 3: Commit**

```bash
git add front/entry/src/main/ets/models/Registration.ets front/entry/src/main/ets/models/RestBean.ets
git commit -m "refactor: expand registration models and add RestBeanMap/ExpenseItem"
```

---

### Task 2: 修复 RegistrationService API 签名

**Files:**
- Modify: `front/entry/src/main/ets/services/RegistrationService.ets`

- [ ] **Step 1: 重写 RegistrationService — 对齐后端 API 契约**

替换 `front/entry/src/main/ets/services/RegistrationService.ets` 全部内容为：

```typescript
import { ApiClient, HttpParams } from './ApiClient'
import { RestBean, RestBeanMap } from '../models/RestBean'
import { Registration, RegistLevel, Department, Doctor, SettleCategory } from '../models/Registration'

const PORT: number = 8092

export class RegistrationService {
  private static api: ApiClient = ApiClient.getInstance()

  // ---- 挂号核心 ----

  /** 新增挂号 — 返回纯文本 "添加成功"/"添加失败" */
  static async addRegister(data: HttpParams): Promise<string> {
    const result: RestBean<string> = await RegistrationService.api.post<string>(PORT, '/addRegister', data)
    return result.msg
  }

  /** 退号 — 通过 registId 退号 */
  static async refundMedicalRecord(registId: string): Promise<RestBean<void>> {
    const params: HttpParams = new HttpParams()
    params.add('id', registId)
    return RegistrationService.api.get<void>(PORT, '/refundMedicalRecord', params)
  }

  /** 查询可退号患者列表（状态=1 已挂号患者，分页） */
  static async getRecordRefundPatient(
    caseNumber?: string, realName?: string, page?: number, size?: number
  ): Promise<RestBean<Registration>> {
    const params: HttpParams = new HttpParams()
    if (caseNumber) { params.add('case_number', caseNumber) }
    if (realName) { params.add('real_name', realName) }
    if (page) { params.add('nowPageNumber', String(page)) }
    if (size) { params.add('pageSize', String(size)) }
    return RegistrationService.api.get<Registration>(PORT, '/getRecordRefundPatient', params)
  }

  /** 查询今日已挂号列表 */
  static async getAlreadyRegisterList(
    visitDate?: string, noon?: string, employeeId?: string
  ): Promise<RestBean<Registration>> {
    const params: HttpParams = new HttpParams()
    if (visitDate) { params.add('visitDate', visitDate) }
    if (noon) { params.add('noon', noon) }
    if (employeeId) { params.add('employeeId', employeeId) }
    return RegistrationService.api.get<Registration>(PORT, '/getAlreadyRegisterCount', params)
  }

  /** 查询医生已挂号数量（号额检查）— 返回纯文本数字 */
  static async getAlreadyRegisterCount(
    visitDate: string, noon: string, employeeId: string
  ): Promise<string> {
    const params: HttpParams = new HttpParams()
    params.add('visitDate', visitDate)
    params.add('noon', noon)
    params.add('employeeId', employeeId)
    const result: RestBean<string> = await RegistrationService.api.get<string>(
      PORT, '/getAlreadyRegisterCount', params
    )
    return result.msg || '0'
  }

  // ---- 下拉数据源 ----

  /** 挂号级别列表 */
  static async getRegistLevelList(): Promise<RestBean<RegistLevel>> {
    return RegistrationService.api.get<RegistLevel>(PORT, '/getRegistLevelList')
  }

  /** 科室列表 */
  static async getAllDeptList(): Promise<RestBean<Department>> {
    return RegistrationService.api.get<Department>(PORT, '/getAllDeptList')
  }

  /** 医生列表 — 按科室+号别过滤 */
  static async getRegistDoctorList(deptId?: string, levelId?: string): Promise<RestBean<Doctor>> {
    const params: HttpParams = new HttpParams()
    if (deptId) { params.add('deptmentId', deptId) }
    if (levelId) { params.add('registLevelId', levelId) }
    return RegistrationService.api.get<Doctor>(PORT, '/getRegistDoctorList', params)
  }

  /** 结算类别列表 */
  static async getSettleCategory(): Promise<RestBean<SettleCategory>> {
    return RegistrationService.api.get<SettleCategory>(PORT, '/getSettleCategory')
  }

  /** 获取最大病历号 — 返回纯文本数字字符串 */
  static async getMaxCaseNumber(): Promise<string> {
    const result: RestBean<string> = await RegistrationService.api.get<string>(
      PORT, '/getMaxCaseNumber'
    )
    return result.msg || '0'
  }

  // ---- 收费/退费 ----

  /** 搜索待收费患者 — 返回 RestBeanMap (registMap + requestList) */
  static async searchExpenseChargePatient(
    caseNumber?: string, realName?: string
  ): Promise<RestBeanMap> {
    const params: HttpParams = new HttpParams()
    if (caseNumber) { params.add('case_number', caseNumber) }
    if (realName) { params.add('real_name', realName) }
    return RegistrationService.api.get<RestBeanMap>(
      PORT, '/searchExpenseChargePatient', params
    ) as Promise<RestBeanMap>
  }

  /** 收费结算 — POST JSON body: List<Map> */
  static async expenseCharge(jsonBody: string): Promise<RestBean<void>> {
    return RegistrationService.api.postJson<void>(PORT, '/expenseCharge', jsonBody)
  }

  /** 搜索待退费患者 */
  static async searchExpenseRefundPatient(
    caseNumber?: string, realName?: string
  ): Promise<RestBeanMap> {
    const params: HttpParams = new HttpParams()
    if (caseNumber) { params.add('case_number', caseNumber) }
    if (realName) { params.add('real_name', realName) }
    return RegistrationService.api.get<RestBeanMap>(
      PORT, '/searchExpenseRefundPatient', params
    ) as Promise<RestBeanMap>
  }

  /** 退费结算 — POST JSON body: List<Map> */
  static async expenseRefund(jsonBody: string): Promise<RestBean<void>> {
    return RegistrationService.api.postJson<void>(PORT, '/expenseRefund', jsonBody)
  }

  /** 查询患者全部费用记录（分页） */
  static async searchAllPricePatient(params?: HttpParams): Promise<RestBean<Registration>> {
    return RegistrationService.api.get<Registration>(PORT, '/searchAllPricePatient', params)
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add front/entry/src/main/ets/services/RegistrationService.ets
git commit -m "refactor: fix RegistrationService API signatures to match backend contracts"
```

---

### Task 3: 重写 OnsiteRegistrationPage → 挂号工作台 + Drawer 表单

**Files:**
- Rewrite: `front/entry/src/main/ets/pages/registration/OnsiteRegistrationPage.ets`

这是最核心的改动。当前页面约287行，重写后约350行。

- [ ] **Step 1: 替换 OnsiteRegistrationPage.ets — 挂号工作台（三区布局 + Drawer）**

替换 `front/entry/src/main/ets/pages/registration/OnsiteRegistrationPage.ets` 全部内容为：

```typescript
/**
 * @file 挂号工作台
 * 功能：快捷操作卡导航 + 今日挂号列表 + 侧边抽屉新增挂号表单
 * 号别-医生联动、号额检查、病历本费用计算
 */
import { HttpParams } from '../../services/ApiClient'
import { PageHeader } from '../../components/PageHeader'
import { RegistrationService } from '../../services/RegistrationService'
import { PageInfo, PaginationBar } from '../../components/PaginationBar'
import { RegistLevel, Department, Doctor, SettleCategory } from '../../models/Registration'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { promptAction } from '@kit.ArkUI'

interface SelectOption {
  label: string
  value: string
}

@ComponentV2
struct OnsiteRegistrationPage {
  // ---- 列表数据 ----
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }

  // ---- 过滤器 ----
  @Local visitDate: string = ''
  @Local noon: string = '上午'

  // ---- 下拉数据源 ----
  @Local registLevels: RegistLevel[] = []
  @Local departments: Department[] = []
  @Local doctors: Doctor[] = []
  @Local settleCategories: SettleCategory[] = []

  // ---- Drawer 状态 ----
  @Local drawerVisible: boolean = false
  @Local formSubmitting: boolean = false

  // ---- 表单字段（基本信息） ----
  @Local caseNumber: string = ''
  @Local patientName: string = ''
  @Local gender: string = '男'
  @Local age: string = ''
  @Local ageType: string = '年'
  @Local birthday: string = ''
  @Local idCard: string = ''
  @Local address: string = ''

  // ---- 表单字段（挂号信息） ----
  @Local selectedDeptId: string = ''
  @Local selectedLevelId: string = ''
  @Local selectedDoctorId: string = ''
  @Local selectedSettleId: string = ''
  @Local registMoney: string = ''
  @Local totalNumber: string = ''
  @Local usedNumber: string = '0'
  @Local isBook: boolean = false
  @Local registMethod: string = '医保卡'

  // ---- 导航 ----
  @Param navStack: NavPathStack = new NavPathStack()

  private columns: ColumnConfig[] = [
    { key: 'case_number', title: '病历号', width: 100 },
    { key: 'patient_name', title: '姓名', width: 80 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'doctor_name', title: '医生', width: 80 },
    { key: 'regist_level', title: '挂号级别', width: 80 },
    { key: 'status', title: '状态', width: 70 },
  ]

  aboutToAppear(): void {
    this.initDateTime()
    this.loadDropdowns()
    this.loadList()
  }

  // ==================== 初始化 ====================

  private initDateTime(): void {
    const now: Date = new Date()
    const year: number = now.getFullYear()
    const month: number = now.getMonth() + 1
    const day: number = now.getDate()
    this.visitDate = `${year}-${month}-${day}`
    this.noon = now.getHours() <= 12 ? '上午' : '下午'
  }

  // ==================== 数据加载 ====================

  private async loadDropdowns(): Promise<void> {
    try {
      const results: RestBean<Object>[] = await Promise.all([
        RegistrationService.getRegistLevelList() as Promise<RestBean<Object>>,
        RegistrationService.getAllDeptList() as Promise<RestBean<Object>>,
        RegistrationService.getSettleCategory() as Promise<RestBean<Object>>,
      ])
      this.registLevels = (results[0].list || []) as RegistLevel[]
      this.departments = (results[1].list || []) as Department[]
      this.settleCategories = (results[2].list || []) as SettleCategory[]
      // 初始加载全部医生
      this.loadDoctors()
    } catch (_e) {
      promptAction.showToast({ message: '加载下拉选项失败', duration: 2000 })
    }
  }

  private async loadDoctors(): Promise<void> {
    try {
      const result: RestBean<Doctor> = await RegistrationService.getRegistDoctorList(
        this.selectedDeptId, this.selectedLevelId
      )
      this.doctors = result.list || []
    } catch (_e) {
      this.doctors = []
    }
  }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const result: RestBean<Object> = await RegistrationService.getAlreadyRegisterList(
        this.visitDate, this.noon, ''
      ) as Promise<RestBean<Object>>
      this.tableData = (result.list || []) as Object[]
      this.pageInfo.total = result.totalCount
    } catch (_e) {
      promptAction.showToast({ message: '加载挂号列表失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  // ==================== 联动逻辑 ====================

  /**
   * 号别变化 — 更新费用、号额，重新加载医生
   */
  private onLevelChange(levelId: string): void {
    this.selectedLevelId = levelId
    this.isBook = false
    this.selectedDoctorId = ''
    this.usedNumber = '0'

    for (let i = 0; i < this.registLevels.length; i++) {
      if (String(this.registLevels[i].id) === levelId) {
        this.registMoney = this.registLevels[i].regist_fee
        this.totalNumber = this.registLevels[i].regist_quota
        break
      }
    }
    // 科室+号别变化时重新拉取医生列表
    this.loadDoctors()
  }

  /**
   * 科室变化 — 重新加载医生（联动号别过滤）
   */
  private onDeptChange(deptId: string): void {
    this.selectedDeptId = deptId
    this.selectedDoctorId = ''
    this.usedNumber = '0'
    this.loadDoctors()
  }

  /**
   * 医生变化 — 查询已用号额，检查是否满额
   */
  private async onDoctorChange(doctorId: string): Promise<void> {
    this.selectedDoctorId = doctorId
    if (!doctorId || !this.visitDate || !this.noon) {
      this.usedNumber = '0'
      return
    }
    try {
      const count: string = await RegistrationService.getAlreadyRegisterCount(
        this.visitDate, this.noon, doctorId
      )
      this.usedNumber = count || '0'
      const used: number = parseInt(count) || 0
      const total: number = parseInt(this.totalNumber) || 0
      if (total > 0 && used >= total) {
        promptAction.showToast({ message: '警告：该医生号额已满，请选择其他医生', duration: 2000 })
      }
    } catch (_e) {
      this.usedNumber = '0'
    }
  }

  /**
   * 病历本开关 — 应收金额 ±1 元
   */
  private onBookToggle(val: boolean): void {
    this.isBook = val
    const current: number = parseFloat(this.registMoney) || 0
    if (val) {
      this.registMoney = (current + 1).toFixed(2)
    } else {
      this.registMoney = (current - 1).toFixed(2)
    }
  }

  // ==================== 表单操作 ====================

  private async openDrawer(): Promise<void> {
    // 生成病历号
    try {
      const max: string = await RegistrationService.getMaxCaseNumber()
      const num: number = parseInt(max) || 0
      this.caseNumber = String(num + 1)
    } catch (_e) {
      this.caseNumber = ''
    }
    this.initDateTime()
    this.drawerVisible = true
  }

  private async onSubmit(): Promise<void> {
    if (!this.patientName) {
      promptAction.showToast({ message: '请输入患者姓名', duration: 2000 })
      return
    }
    if (!this.selectedDeptId) {
      promptAction.showToast({ message: '请选择科室', duration: 2000 })
      return
    }
    if (!this.selectedLevelId) {
      promptAction.showToast({ message: '请选择号别', duration: 2000 })
      return
    }
    if (!this.selectedDoctorId) {
      promptAction.showToast({ message: '请选择医生', duration: 2000 })
      return
    }

    this.formSubmitting = true
    try {
      const data: HttpParams = new HttpParams()
      data.add('case_number', this.caseNumber)
      data.add('real_name', this.patientName)
      data.add('gender', this.gender)
      data.add('age', this.age)
      data.add('age_type', this.ageType)
      data.add('birthday', this.birthday)
      data.add('card_number', this.idCard)
      data.add('home_address', this.address)
      data.add('visit_date', this.visitDate)
      data.add('noon', this.noon)
      data.add('deptment_id', this.selectedDeptId)
      data.add('employee_id', this.selectedDoctorId)
      data.add('regist_level_id', this.selectedLevelId)
      data.add('settle_category_id', this.selectedSettleId || '1')
      data.add('is_book', this.isBook ? 'true' : 'false')
      data.add('regist_method', this.registMethod)
      data.add('regist_money', this.registMoney)

      const msg: string = await RegistrationService.addRegister(data)
      promptAction.showToast({ message: msg, duration: 2000 })
      if (msg === '添加成功') {
        this.drawerVisible = false
        this.resetForm()
        this.loadDropdowns()
        this.loadList()
      }
    } catch (_e) {
      promptAction.showToast({ message: '挂号提交失败', duration: 2000 })
    } finally {
      this.formSubmitting = false
    }
  }

  private resetForm(): void {
    this.patientName = ''
    this.gender = '男'
    this.age = ''
    this.ageType = '年'
    this.birthday = ''
    this.idCard = ''
    this.address = ''
    this.selectedDeptId = ''
    this.selectedLevelId = ''
    this.selectedDoctorId = ''
    this.selectedSettleId = ''
    this.registMoney = ''
    this.totalNumber = ''
    this.usedNumber = '0'
    this.isBook = false
    this.registMethod = '医保卡'
  }

  // ==================== 下拉选项构建 ====================

  private buildDeptOptions(): SelectOption[] {
    const opts: SelectOption[] = []
    for (let i = 0; i < this.departments.length; i++) {
      opts.push({ label: this.departments[i].dept_name, value: String(this.departments[i].id) })
    }
    return opts
  }

  private buildDoctorOptions(): SelectOption[] {
    const opts: SelectOption[] = []
    for (let i = 0; i < this.doctors.length; i++) {
      opts.push({ label: this.doctors[i].realname, value: String(this.doctors[i].id) })
    }
    return opts
  }

  private buildLevelOptions(): SelectOption[] {
    const opts: SelectOption[] = []
    for (let i = 0; i < this.registLevels.length; i++) {
      const label: string = this.registLevels[i].regist_name +
        ' (¥' + this.registLevels[i].regist_fee + ')'
      opts.push({ label: label, value: String(this.registLevels[i].id) })
    }
    return opts
  }

  private buildSettleOptions(): SelectOption[] {
    const opts: SelectOption[] = []
    for (let i = 0; i < this.settleCategories.length; i++) {
      opts.push({
        label: this.settleCategories[i].settle_name,
        value: String(this.settleCategories[i].id)
      })
    }
    return opts
  }

  private findSelectedIndex(options: SelectOption[], value: string): number {
    for (let i = 0; i < options.length; i++) {
      if (options[i].value === value) { return i }
    }
    return 0
  }

  // ==================== Builder 方法 ====================

  @Builder
  shortcutCards() {
    Row() {
      this.shortcutCard('新增挂号', '#409EFF', () => this.openDrawer())
      this.shortcutCard('退号', '#E6A23C', () => this.navStack.pushPath({ name: 'RegistrationRecordPage' }))
      this.shortcutCard('收费', '#67C23A', () => this.navStack.pushPath({ name: 'ExpenseChargePage' }))
      this.shortcutCard('退费', '#F56C6C', () => this.navStack.pushPath({ name: 'ExpenseRefundPage' }))
      this.shortcutCard('费用查询', '#909399', () => this.navStack.pushPath({ name: 'ExpenseManagePage' }))
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 12 })
  }

  @Builder
  shortcutCard(label: string, color: string, onClick: () => void) {
    Column() {
      Text(label)
        .fontSize(13)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Medium)
    }
    .width('18%')
    .height(56)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(color)
    .borderRadius(8)
    .onClick(onClick)
  }

  @Builder
  filterRow() {
    Row() {
      Text('今日挂号')
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor('#303133')
        .margin({ right: 16 })

      Text('日期: ' + this.visitDate)
        .fontSize(12)
        .fontColor('#909399')
        .margin({ right: 12 })

      Text('午别: ')
        .fontSize(12)
        .fontColor('#909399')
      Select([
        { value: '上午', label: '上午' } as SelectOption,
        { value: '下午', label: '下午' } as SelectOption
      ])
        .selected(this.noon === '上午' ? 0 : 1)
        .width(80)
        .height(28)
        .fontSize(12)
        .onSelect((index: number) => {
          this.noon = index === 0 ? '上午' : '下午'
          this.loadList()
        })

      Blank()

      Button('刷新')
        .fontSize(12)
        .height(28)
        .backgroundColor('#F5F5F5')
        .fontColor('#606266')
        .onClick(() => this.loadList())
    }
    .width('100%')
    .height(36)
    .margin({ bottom: 8 })
  }

  @Builder
  formField(label: string, value: string, onChange: (v: string) => void, w?: number, enabled: boolean = true) {
    Row() {
      Text(label)
        .fontSize(13)
        .fontColor('#606266')
        .width(w || 72)
      TextInput({ text: value })
        .layoutWeight(1)
        .height(34)
        .fontSize(13)
        .enabled(enabled)
        .onChange(onChange)
    }
    .margin({ bottom: 8 })
  }

  @Builder
  formPicker(label: string, options: SelectOption[], selected: string, onChange: (v: string) => void) {
    Row() {
      Text(label)
        .fontSize(13)
        .fontColor('#606266')
        .width(72)
      Select(options)
        .layoutWeight(1)
        .height(34)
        .fontSize(13)
        .selected(this.findSelectedIndex(options, selected))
        .onSelect((index: number) => onChange(options[index].value))
    }
    .margin({ bottom: 8 })
  }

  @Builder
  drawerPanel() {
    if (this.drawerVisible) {
      Stack() {
        // 遮罩层
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#00000050')
          .onClick(() => {
            this.drawerVisible = false
            this.resetForm()
          })

        // Drawer 面板 — 从右侧滑入
        Column() {
          // 标题栏
          Row() {
            Text('新增挂号')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#303133')
              .layoutWeight(1)
            Button({ type: ButtonType.Circle }) {
              Text('✕').fontSize(16)
            }
            .width(32).height(32)
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              this.drawerVisible = false
              this.resetForm()
            })
          }
          .width('100%')
          .margin({ bottom: 12 })

          // 表单区域 — 可滚动
          Scroll() {
            Column() {
              // 基本信息
              Text('基本信息')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#303133')
                .margin({ bottom: 8 })

              this.formField('病历号', this.caseNumber, (_v: string) => {}, 72, false)
              this.formField('姓名 *', this.patientName, (v: string) => { this.patientName = v })
              Row() {
                this.formField('性别', this.gender, (v: string) => { this.gender = v }, 40)
                this.formField('年龄', this.age, (v: string) => { this.age = v }, 40)
                this.formField('类型', this.ageType, (v: string) => { this.ageType = v }, 40)
              }
              this.formField('出生日期', this.birthday, (v: string) => { this.birthday = v })
              this.formField('身份证号', this.idCard, (v: string) => { this.idCard = v })
              this.formField('家庭住址', this.address, (v: string) => { this.address = v })

              // 挂号信息
              Text('挂号信息')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#303133')
                .margin({ top: 12, bottom: 8 })

              Row() {
                this.formField('看诊日期', this.visitDate, (_v: string) => {}, 72, false)
                this.formField('午别', this.noon, (_v: string) => {}, 40, false)
              }
              this.formPicker('科室 *', this.buildDeptOptions(), this.selectedDeptId,
                (v: string) => { this.onDeptChange(v) })
              this.formPicker('号别 *', this.buildLevelOptions(), this.selectedLevelId,
                (v: string) => { this.onLevelChange(v) })
              this.formPicker('医生 *', this.buildDoctorOptions(), this.selectedDoctorId,
                (v: string) => { this.onDoctorChange(v) })

              Row() {
                this.formField('初始号额', this.totalNumber, (_v: string) => {}, 72, false)
                this.formField('已用号额', this.usedNumber, (_v: string) => {}, 72, false)
              }
              Row() {
                Column() {
                  Text('病历本')
                    .fontSize(13)
                    .fontColor('#606266')
                    .width(72)
                    .margin({ bottom: 8 })
                }
                Toggle({ type: ToggleType.Switch, isOn: this.isBook })
                  .onChange((val: boolean) => { this.onBookToggle(val) })
                Blank()
              }
              .width('100%')
              .margin({ bottom: 8 })

              this.formField('应收金额', this.registMoney + ' 元', (_v: string) => {}, 72, false)
              this.formPicker('收费方式', [
                { value: '现金', label: '现金' } as SelectOption,
                { value: '微信', label: '微信' } as SelectOption,
                { value: '支付宝', label: '支付宝' } as SelectOption,
                { value: '银行卡', label: '银行卡' } as SelectOption,
                { value: '医保卡', label: '医保卡' } as SelectOption,
              ], this.registMethod, (v: string) => { this.registMethod = v })
              this.formPicker('结算类别', this.buildSettleOptions(), this.selectedSettleId,
                (v: string) => { this.selectedSettleId = v })
            }
          }
          .layoutWeight(1)

          // 底部按钮
          Row() {
            Button('清空')
              .backgroundColor('#F5F5F5')
              .fontColor('#606266')
              .layoutWeight(1)
              .height(40)
              .onClick(() => this.resetForm())
            Blank().width(12)
            Button(this.formSubmitting ? '提交中...' : '提交')
              .backgroundColor('#409EFF')
              .fontColor('#FFFFFF')
              .layoutWeight(1)
              .height(40)
              .enabled(!this.formSubmitting)
              .onClick(() => this.onSubmit())
          }
          .width('100%')
          .margin({ top: 12 })
        }
        .width('88%')
        .height('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .position({ x: '12%', y: 0 })
        .transition(TransitionEffect.OPACITY
          .animation({ duration: 200, curve: Curve.EaseOut })
          .combine(TransitionEffect.translate({ x: 50, y: 0 })
            .animation({ duration: 200, curve: Curve.EaseOut })))
      }
      .width('100%')
      .height('100%')
      .position({ x: 0, y: 0 })
    }
  }

  // ==================== 主构建 ====================

  build() {
    Stack() {
      Column() {
        // 快捷操作卡
        this.shortcutCards()

        // 过滤器行
        this.filterRow()

        // 挂号列表表格
        DataTable({
          columns: this.columns,
          data: this.tableData,
          loading: this.loading,
          showIndex: true,
        })
        .layoutWeight(1)

        // 分页
        PaginationBar({
          pageInfo: this.pageInfo,
          onChange: (page: number, _size: number) => {
            this.pageInfo.page = page
            this.loadList()
          }
        })
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor('#F0F2F5')

      // Drawer 面板
      this.drawerPanel()
    }
    .width('100%')
    .height('100%')
  }
}

export default OnsiteRegistrationPage
```

- [ ] **Step 2: Commit**

```bash
git add front/entry/src/main/ets/pages/registration/OnsiteRegistrationPage.ets
git commit -m "feat: rewrite OnsiteRegistrationPage as workbench with drawer form and shortcut nav"
```

---

### Task 4: 重写 ExpenseChargePage（收费）

**Files:**
- Rewrite: `front/entry/src/main/ets/pages/registration/ExpenseChargePage.ets`

- [ ] **Step 1: 替换 ExpenseChargePage.ets — 搜索+多选+收费**

替换 `front/entry/src/main/ets/pages/registration/ExpenseChargePage.ets` 全部内容为：

```typescript
/**
 * @file 收费页面
 * 功能：搜索患者 → 显示待收费项目明细（多选）→ 合计收费结算
 */
import { PageHeader } from '../../components/PageHeader'
import { RegistrationService } from '../../services/RegistrationService'
import { RestBeanMap, ExpenseItem } from '../../models/RestBean'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct ExpenseChargePage {
  // ---- 搜索 ----
  @Local caseNumber: string = ''
  @Local realName: string = ''

  // ---- 患者信息 ----
  @Local patientName: string = ''
  @Local patientCard: string = ''
  @Local patientAge: string = ''
  @Local patientGender: string = ''

  // ---- 项目列表 ----
  @Local items: ExpenseItem[] = []
  @Local selectedIds: Set<number> = new Set<number>()
  @Local totalPrice: string = '0.00'
  @Local loading: boolean = false

  aboutToAppear(): void {
    // 页面初始化不查询，等用户输入搜索
  }

  // ==================== 搜索 ====================

  private async searchPatient(): Promise<void> {
    if (!this.caseNumber && !this.realName) {
      promptAction.showToast({ message: '请输入病历号或患者姓名', duration: 2000 })
      return
    }
    this.loading = true
    try {
      const resp: RestBeanMap = await RegistrationService.searchExpenseChargePatient(
        this.caseNumber, this.realName
      )
      if (resp.registMap == null) {
        promptAction.showToast({ message: '未找到患者信息', duration: 2000 })
        this.clearPatientInfo()
        return
      }
      const reg: Record<string, Object> = resp.registMap as Record<string, Object>
      const keys: string[] = Object.keys(reg)
      const values: Object[] = Object.values(reg)
      for (let i = 0; i < keys.length; i++) {
        const k: string = keys[i]
        const v: string = String(values[i] || '')
        if (k === 'real_name') { this.patientName = v }
        else if (k === 'card_number') { this.patientCard = v }
        else if (k === 'age') { this.patientAge = v }
        else if (k === 'gender') { this.patientGender = v }
      }
      this.items = resp.requestList || []
      this.selectedIds = new Set<number>()
      this.calcTotal()
    } catch (_e) {
      promptAction.showToast({ message: '查询失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  private clearPatientInfo(): void {
    this.patientName = ''
    this.patientCard = ''
    this.patientAge = ''
    this.patientGender = ''
    this.items = []
    this.selectedIds = new Set<number>()
    this.totalPrice = '0.00'
  }

  // ==================== 选择逻辑 ====================

  private toggleItem(itemId: number): void {
    if (this.selectedIds.has(itemId)) {
      this.selectedIds.delete(itemId)
    } else {
      this.selectedIds.add(itemId)
    }
    this.calcTotal()
  }

  private isSelected(itemId: number): boolean {
    return this.selectedIds.has(itemId)
  }

  private calcTotal(): void {
    let total: number = 0
    for (let i = 0; i < this.items.length; i++) {
      if (this.selectedIds.has(this.items[i].id)) {
        const price: number = parseFloat(this.items[i].item_price) || 0
        const num: number = parseInt(this.items[i].item_number) || 1
        total = total + price * num
      }
    }
    this.totalPrice = total.toFixed(2)
  }

  // ==================== 收费 ====================

  private async doCharge(): Promise<void> {
    if (this.selectedIds.size === 0) {
      promptAction.showToast({ message: '请选择要收费的项目', duration: 2000 })
      return
    }
    const selectedList: Object[] = []
    for (let i = 0; i < this.items.length; i++) {
      if (this.selectedIds.has(this.items[i].id)) {
        selectedList.push(this.items[i] as Object)
      }
    }
    try {
      const jsonBody: string = JSON.stringify(selectedList)
      const result = await RegistrationService.expenseCharge(jsonBody)
      if (result.status === 1) {
        promptAction.showToast({ message: '收费成功，合计 ¥' + this.totalPrice, duration: 2000 })
        // 刷新——重新搜索
        this.searchPatient()
      } else {
        promptAction.showToast({ message: result.msg || '收费失败', duration: 2000 })
      }
    } catch (_e) {
      promptAction.showToast({ message: '收费失败', duration: 2000 })
    }
  }

  // ==================== Builder ====================

  @Builder
  patientInfoBar() {
    if (this.patientName) {
      Row() {
        Text('患者信息确认')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#303133')
          .margin({ right: 16 })
        Text('姓名: ' + this.patientName).fontSize(13).fontColor('#606266').margin({ right: 8 })
        Text('身份证: ' + this.patientCard).fontSize(13).fontColor('#606266').margin({ right: 8 })
        Text('年龄: ' + this.patientAge).fontSize(13).fontColor('#606266').margin({ right: 8 })
        Text('性别: ' + this.patientGender).fontSize(13).fontColor('#606266')
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(8)
      .margin({ bottom: 12 })
    }
  }

  @Builder
  itemHeader() {
    Row() {
      Text('选择').fontSize(12).fontWeight(FontWeight.Medium).width(50)
      Text('项目名称').fontSize(12).fontWeight(FontWeight.Medium).layoutWeight(1)
      Text('单价').fontSize(12).fontWeight(FontWeight.Medium).width(70)
      Text('类型').fontSize(12).fontWeight(FontWeight.Medium).width(60)
      Text('规格').fontSize(12).fontWeight(FontWeight.Medium).width(100)
      Text('数量').fontSize(12).fontWeight(FontWeight.Medium).width(50)
      Text('开立时间').fontSize(12).fontWeight(FontWeight.Medium).width(140)
    }
    .width('100%')
    .height(36)
    .backgroundColor('#F5F7FA')
    .borderRadius({ topLeft: 8, topRight: 8 })
    .padding({ left: 8, right: 8 })
  }

  @Builder
  itemRow(item: ExpenseItem, index: number) {
    Row() {
      Button(this.isSelected(item.id) ? '☑' : '☐')
        .fontSize(14)
        .fontColor(this.isSelected(item.id) ? '#409EFF' : '#909399')
        .backgroundColor(Color.Transparent)
        .width(50)
        .height(32)
        .onClick(() => { this.toggleItem(item.id) })
      Text(item.item_name)
        .fontSize(12)
        .fontColor('#303133')
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(item.item_price)
        .fontSize(12)
        .fontColor('#303133')
        .width(70)
      Text(item.item_type)
        .fontSize(12)
        .fontColor('#303133')
        .width(60)
      Text(item.item_format)
        .fontSize(12)
        .fontColor('#303133')
        .width(100)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(item.item_number)
        .fontSize(12)
        .fontColor('#303133')
        .width(50)
      Text(item.item_create_time)
        .fontSize(12)
        .fontColor('#303133')
        .width(140)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(36)
    .backgroundColor(index % 2 === 0 ? '#FFFFFF' : '#FAFAFA')
    .padding({ left: 8, right: 8 })
  }

  @Builder
  bottomBar() {
    Row() {
      Text('已选: ' + String(this.selectedIds.size) + ' 项')
        .fontSize(13)
        .fontColor('#606266')
      Blank()
      Text('合计: ¥' + this.totalPrice)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#E6A23C')
        .margin({ right: 16 })
      Button('收费结算')
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor('#67C23A')
        .borderRadius(4)
        .height(40)
        .padding({ left: 20, right: 20 })
        .onClick(() => this.doCharge())
    }
    .width('100%')
    .height(52)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .shadow({ radius: 4, color: '#00000010' })
  }

  // ==================== 主构建 ====================

  build() {
    Column() {
      PageHeader({ title: '收费' })

      // 搜索区
      Row() {
        TextInput({ placeholder: '请输入病历号' })
          .value(this.caseNumber)
          .onChange((v: string) => { this.caseNumber = v })
          .fontSize(13)
          .height(36)
          .layoutWeight(1)
          .margin({ right: 12 })

        TextInput({ placeholder: '请输入患者名' })
          .value(this.realName)
          .onChange((v: string) => { this.realName = v })
          .fontSize(13)
          .height(36)
          .layoutWeight(1)
          .margin({ right: 12 })

        Button('搜索')
          .fontSize(13)
          .fontColor('#FFFFFF')
          .backgroundColor('#409EFF')
          .borderRadius(4)
          .height(36)
          .padding({ left: 16, right: 16 })
          .onClick(() => this.searchPatient())
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 患者信息
      this.patientInfoBar()

      // 项目表格
      if (this.loading) {
        LoadingProgress().width(40).height(40).margin({ top: 60 })
      } else if (this.items.length > 0) {
        Column() {
          this.itemHeader()
          Scroll() {
            Column() {
              ForEach(this.items, (item: ExpenseItem, index: number) => {
                this.itemRow(item, index)
              }, (item: ExpenseItem) => String(item.id))
            }
          }
          .layoutWeight(1)
        }
        .layoutWeight(1)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#F0F2F5')

    // 底部操作栏
    this.bottomBar()
  }
}

export default ExpenseChargePage
```

- [ ] **Step 2: Commit**

```bash
git add front/entry/src/main/ets/pages/registration/ExpenseChargePage.ets
git commit -m "feat: rewrite ExpenseChargePage with search, multi-select item list, and JSON charge API"
```

---

### Task 5: 重写 ExpenseRefundPage（退费）

**Files:**
- Rewrite: `front/entry/src/main/ets/pages/registration/ExpenseRefundPage.ets`

- [ ] **Step 1: 替换 ExpenseRefundPage.ets — 镜像收费页结构**

替换 `front/entry/src/main/ets/pages/registration/ExpenseRefundPage.ets` 全部内容为：

```typescript
/**
 * @file 退费页面
 * 功能：搜索患者 → 显示已收费项目明细（多选）→ 确认退费结算
 */
import { ConfirmDialog } from '../../components/ConfirmDialog'
import { PageHeader } from '../../components/PageHeader'
import { RegistrationService } from '../../services/RegistrationService'
import { RestBeanMap, ExpenseItem } from '../../models/RestBean'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct ExpenseRefundPage {
  // ---- 搜索 ----
  @Local caseNumber: string = ''
  @Local realName: string = ''

  // ---- 患者信息 ----
  @Local patientName: string = ''
  @Local patientCard: string = ''
  @Local patientAge: string = ''
  @Local patientGender: string = ''

  // ---- 项目列表 ----
  @Local items: ExpenseItem[] = []
  @Local selectedIds: Set<number> = new Set<number>()
  @Local totalPrice: string = '0.00'
  @Local loading: boolean = false

  // ---- 确认对话框 ----
  @Local confirmVisible: boolean = false

  // ==================== 搜索 ====================

  private async searchPatient(): Promise<void> {
    if (!this.caseNumber && !this.realName) {
      promptAction.showToast({ message: '请输入病历号或患者姓名', duration: 2000 })
      return
    }
    this.loading = true
    try {
      const resp: RestBeanMap = await RegistrationService.searchExpenseRefundPatient(
        this.caseNumber, this.realName
      )
      if (resp.registMap == null) {
        promptAction.showToast({ message: '未找到患者信息', duration: 2000 })
        this.clearPatientInfo()
        return
      }
      const reg: Record<string, Object> = resp.registMap as Record<string, Object>
      const keys: string[] = Object.keys(reg)
      const values: Object[] = Object.values(reg)
      for (let i = 0; i < keys.length; i++) {
        const k: string = keys[i]
        const v: string = String(values[i] || '')
        if (k === 'real_name') { this.patientName = v }
        else if (k === 'card_number') { this.patientCard = v }
        else if (k === 'age') { this.patientAge = v }
        else if (k === 'gender') { this.patientGender = v }
      }
      this.items = resp.requestList || []
      this.selectedIds = new Set<number>()
      this.calcTotal()
    } catch (_e) {
      promptAction.showToast({ message: '查询失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  private clearPatientInfo(): void {
    this.patientName = ''
    this.patientCard = ''
    this.patientAge = ''
    this.patientGender = ''
    this.items = []
    this.selectedIds = new Set<number>()
    this.totalPrice = '0.00'
  }

  // ==================== 选择逻辑 ====================

  private toggleItem(itemId: number): void {
    if (this.selectedIds.has(itemId)) {
      this.selectedIds.delete(itemId)
    } else {
      this.selectedIds.add(itemId)
    }
    this.calcTotal()
  }

  private isSelected(itemId: number): boolean {
    return this.selectedIds.has(itemId)
  }

  private calcTotal(): void {
    let total: number = 0
    for (let i = 0; i < this.items.length; i++) {
      if (this.selectedIds.has(this.items[i].id)) {
        const price: number = parseFloat(this.items[i].item_price) || 0
        const num: number = parseInt(this.items[i].item_number) || 1
        total = total + price * num
      }
    }
    this.totalPrice = total.toFixed(2)
  }

  // ==================== 退费 ====================

  private async doRefund(): Promise<void> {
    this.confirmVisible = false
    if (this.selectedIds.size === 0) {
      promptAction.showToast({ message: '请选择要退费的项目', duration: 2000 })
      return
    }
    const selectedList: Object[] = []
    for (let i = 0; i < this.items.length; i++) {
      if (this.selectedIds.has(this.items[i].id)) {
        selectedList.push(this.items[i] as Object)
      }
    }
    try {
      const jsonBody: string = JSON.stringify(selectedList)
      const result = await RegistrationService.expenseRefund(jsonBody)
      if (result.status === 1) {
        promptAction.showToast({ message: '退费成功，合计 ¥' + this.totalPrice, duration: 2000 })
        this.searchPatient()
      } else {
        promptAction.showToast({ message: result.msg || '退费失败', duration: 2000 })
      }
    } catch (_e) {
      promptAction.showToast({ message: '退费失败', duration: 2000 })
    }
  }

  // ==================== Builder ====================

  @Builder
  patientInfoBar() {
    if (this.patientName) {
      Row() {
        Text('患者信息确认')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#303133')
          .margin({ right: 16 })
        Text('姓名: ' + this.patientName).fontSize(13).fontColor('#606266').margin({ right: 8 })
        Text('身份证: ' + this.patientCard).fontSize(13).fontColor('#606266').margin({ right: 8 })
        Text('年龄: ' + this.patientAge).fontSize(13).fontColor('#606266').margin({ right: 8 })
        Text('性别: ' + this.patientGender).fontSize(13).fontColor('#606266')
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(8)
      .margin({ bottom: 12 })
    }
  }

  @Builder
  itemHeader() {
    Row() {
      Text('选择').fontSize(12).fontWeight(FontWeight.Medium).width(50)
      Text('项目名称').fontSize(12).fontWeight(FontWeight.Medium).layoutWeight(1)
      Text('单价').fontSize(12).fontWeight(FontWeight.Medium).width(70)
      Text('类型').fontSize(12).fontWeight(FontWeight.Medium).width(60)
      Text('规格').fontSize(12).fontWeight(FontWeight.Medium).width(100)
      Text('数量').fontSize(12).fontWeight(FontWeight.Medium).width(50)
      Text('开立时间').fontSize(12).fontWeight(FontWeight.Medium).width(140)
    }
    .width('100%')
    .height(36)
    .backgroundColor('#F5F7FA')
    .borderRadius({ topLeft: 8, topRight: 8 })
    .padding({ left: 8, right: 8 })
  }

  @Builder
  itemRow(item: ExpenseItem, index: number) {
    Row() {
      Button(this.isSelected(item.id) ? '☑' : '☐')
        .fontSize(14)
        .fontColor(this.isSelected(item.id) ? '#F56C6C' : '#909399')
        .backgroundColor(Color.Transparent)
        .width(50)
        .height(32)
        .onClick(() => { this.toggleItem(item.id) })
      Text(item.item_name)
        .fontSize(12)
        .fontColor('#303133')
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(item.item_price)
        .fontSize(12)
        .fontColor('#303133')
        .width(70)
      Text(item.item_type)
        .fontSize(12)
        .fontColor('#303133')
        .width(60)
      Text(item.item_format)
        .fontSize(12)
        .fontColor('#303133')
        .width(100)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(item.item_number)
        .fontSize(12)
        .fontColor('#303133')
        .width(50)
      Text(item.item_create_time)
        .fontSize(12)
        .fontColor('#303133')
        .width(140)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(36)
    .backgroundColor(index % 2 === 0 ? '#FFFFFF' : '#FAFAFA')
    .padding({ left: 8, right: 8 })
  }

  @Builder
  bottomBar() {
    Row() {
      Text('已选: ' + String(this.selectedIds.size) + ' 项')
        .fontSize(13)
        .fontColor('#606266')
      Blank()
      Text('合计: ¥' + this.totalPrice)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F56C6C')
        .margin({ right: 16 })
      Button('确认退费')
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor('#F56C6C')
        .borderRadius(4)
        .height(40)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          if (this.selectedIds.size === 0) {
            promptAction.showToast({ message: '请选择要退费的项目', duration: 2000 })
          } else {
            this.confirmVisible = true
          }
        })
    }
    .width('100%')
    .height(52)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .shadow({ radius: 4, color: '#00000010' })
  }

  // ==================== 主构建 ====================

  build() {
    Stack() {
      Column() {
        PageHeader({ title: '退费' })

        // 搜索区
        Row() {
          TextInput({ placeholder: '请输入病历号' })
            .value(this.caseNumber)
            .onChange((v: string) => { this.caseNumber = v })
            .fontSize(13)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 12 })

          TextInput({ placeholder: '请输入患者名' })
            .value(this.realName)
            .onChange((v: string) => { this.realName = v })
            .fontSize(13)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 12 })

          Button('搜索')
            .fontSize(13)
            .fontColor('#FFFFFF')
            .backgroundColor('#409EFF')
            .borderRadius(4)
            .height(36)
            .padding({ left: 16, right: 16 })
            .onClick(() => this.searchPatient())
        }
        .width('100%')
        .margin({ bottom: 12 })

        // 患者信息
        this.patientInfoBar()

        // 项目表格
        if (this.loading) {
          LoadingProgress().width(40).height(40).margin({ top: 60 })
        } else if (this.items.length > 0) {
          Column() {
            this.itemHeader()
            Scroll() {
              Column() {
                ForEach(this.items, (item: ExpenseItem, index: number) => {
                  this.itemRow(item, index)
                }, (item: ExpenseItem) => String(item.id))
              }
            }
            .layoutWeight(1)
          }
          .layoutWeight(1)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
        }
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor('#F0F2F5')

      // 底部操作栏
      this.bottomBar()

      // 确认对话框
      ConfirmDialog({
        visible: this.confirmVisible,
        title: '确认退费',
        message: '确定要对已选项目进行退费吗？合计金额: ¥' + this.totalPrice,
        danger: true,
        onConfirm: () => this.doRefund(),
        onCancel: () => { this.confirmVisible = false },
      })
    }
    .width('100%')
    .height('100%')
  }
}

export default ExpenseRefundPage
```

- [ ] **Step 2: Commit**

```bash
git add front/entry/src/main/ets/pages/registration/ExpenseRefundPage.ets
git commit -m "feat: rewrite ExpenseRefundPage with search, multi-select item list, and JSON refund API"
```

---

### Task 6: 优化 RegistrationRecordPage（退号）— 添加搜索

**Files:**
- Modify: `front/entry/src/main/ets/pages/registration/RegistrationRecordPage.ets`

- [ ] **Step 1: 在 RegistrationRecordPage 添加搜索栏**

修改 `front/entry/src/main/ets/pages/registration/RegistrationRecordPage.ets`：

在 `@Local selectedRow: Object | null = null` 后面添加两行：

```typescript
  @Local searchCaseNumber: string = ''
  @Local searchRealName: string = ''
```

在 `loadList` 方法中，修改调用为带搜索参数：

将：
```typescript
const result = await RegistrationService.getRecordRefundPatient()
```

改为：
```typescript
const result: RestBean<Object> = await RegistrationService.getRecordRefundPatient(
  this.searchCaseNumber, this.searchRealName, this.pageInfo.page, this.pageInfo.size
) as Promise<RestBean<Object>>
```

在 `build()` 方法中，在 `PageHeader` 下面添加搜索区：

在 `PageHeader({ title: '窗口退号' })` 之后添加：

```typescript
        Row() {
          TextInput({ placeholder: '请输入病历号' })
            .value(this.searchCaseNumber)
            .onChange((v: string) => { this.searchCaseNumber = v })
            .fontSize(13)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 12 })

          TextInput({ placeholder: '请输入患者名' })
            .value(this.searchRealName)
            .onChange((v: string) => { this.searchRealName = v })
            .fontSize(13)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 12 })

          Button('搜索')
            .fontSize(13)
            .fontColor('#FFFFFF')
            .backgroundColor('#409EFF')
            .borderRadius(4)
            .height(36)
            .padding({ left: 16, right: 16 })
            .onClick(() => this.loadList())

          Button('重置')
            .fontSize(13)
            .backgroundColor('#F5F5F5')
            .fontColor('#606266')
            .borderRadius(4)
            .height(36)
            .padding({ left: 16, right: 16 })
            .margin({ left: 8 })
            .onClick(() => {
              this.searchCaseNumber = ''
              this.searchRealName = ''
              this.loadList()
            })
        }
        .width('100%')
        .margin({ bottom: 12 })
```

同时在文件顶部添加 import：
```typescript
import { RestBean } from '../../models/RestBean'
```

由于这是精准修改，不可用完整替换。给出修改要点：

文件最终完整内容如下：

```typescript
import { RestBean } from '../../models/RestBean'
import { ConfirmDialog } from '../../components/ConfirmDialog'
import { PageHeader } from '../../components/PageHeader'
import { RegistrationService } from '../../services/RegistrationService'
import { PageInfo, PaginationBar } from '../../components/PaginationBar'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct RegistrationRecordPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Local confirmVisible: boolean = false
  @Local selectedRow: Object | null = null
  @Local searchCaseNumber: string = ''
  @Local searchRealName: string = ''

  private columns: ColumnConfig[] = [
    { key: 'case_number', title: '病历号', width: 100 },
    { key: 'patient_name', title: '姓名', width: 80 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'doctor_name', title: '医生', width: 80 },
    { key: 'regist_level', title: '级别', width: 70 },
    { key: 'status', title: '状态', width: 70 },
  ]

  aboutToAppear(): void {
    this.loadList()
  }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const result: RestBean<Object> = await RegistrationService.getRecordRefundPatient(
        this.searchCaseNumber, this.searchRealName, this.pageInfo.page, this.pageInfo.size
      ) as Promise<RestBean<Object>>
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount
      }
    } catch (_e) {
      promptAction.showToast({ message: '加载退号列表失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  private async doRefund(): Promise<void> {
    if (!this.selectedRow) {
      return
    }
    const keys: string[] = Object.keys(this.selectedRow)
    const values: Object[] = Object.values(this.selectedRow)
    let registId: string = ''
    for (let i = 0; i < keys.length; i++) {
      if (keys[i] === 'id') {
        registId = String(values[i] || '')
        break
      }
    }
    try {
      const result = await RegistrationService.refundMedicalRecord(registId)
      if (result.status === 1) {
        promptAction.showToast({ message: '退号成功', duration: 2000 })
        this.confirmVisible = false
        this.selectedRow = null
        this.loadList()
      }
    } catch (_e) {
      promptAction.showToast({ message: '退号失败', duration: 2000 })
    }
  }

  @Builder
  actionButtons(row: Object) {
    Button('退号')
      .fontSize(12).height(28)
      .backgroundColor('#F56C6C').fontColor('#FFFFFF')
      .onClick(() => {
        this.selectedRow = row
        this.confirmVisible = true
      })
  }

  build() {
    Stack() {
      Column() {
        PageHeader({ title: '窗口退号' })

        // 搜索区
        Row() {
          TextInput({ placeholder: '请输入病历号' })
            .value(this.searchCaseNumber)
            .onChange((v: string) => { this.searchCaseNumber = v })
            .fontSize(13)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 12 })

          TextInput({ placeholder: '请输入患者名' })
            .value(this.searchRealName)
            .onChange((v: string) => { this.searchRealName = v })
            .fontSize(13)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 12 })

          Button('搜索')
            .fontSize(13)
            .fontColor('#FFFFFF')
            .backgroundColor('#409EFF')
            .borderRadius(4)
            .height(36)
            .padding({ left: 16, right: 16 })
            .onClick(() => this.loadList())

          Button('重置')
            .fontSize(13)
            .backgroundColor('#F5F5F5')
            .fontColor('#606266')
            .borderRadius(4)
            .height(36)
            .padding({ left: 16, right: 16 })
            .margin({ left: 8 })
            .onClick(() => {
              this.searchCaseNumber = ''
              this.searchRealName = ''
              this.loadList()
            })
        }
        .width('100%')
        .margin({ bottom: 12 })

        DataTable({
          columns: this.columns,
          data: this.tableData,
          loading: this.loading,
          showActionColumn: true,
          actionColumn: (row: Object) => { this.actionButtons(row) }
        })
      }
      .width('100%').height('100%')
      .padding(16).backgroundColor('#F0F2F5')

      ConfirmDialog({
        visible: this.confirmVisible,
        title: '确认退号',
        message: '确定要退号吗？此操作不可撤销。',
        danger: true,
        onConfirm: () => this.doRefund(),
        onCancel: () => this.confirmVisible = false,
      })
    }
    .width('100%').height('100%')
  }
}

export default RegistrationRecordPage
```

- [ ] **Step 2: Commit**

```bash
git add front/entry/src/main/ets/pages/registration/RegistrationRecordPage.ets
git commit -m "feat: add search inputs to RegistrationRecordPage"
```

---

### Task 7: 更新 HomePage — 传递 navPathStack 给工作台页面

**Files:**
- Modify: `front/entry/src/main/ets/pages/HomePage.ets`

- [ ] **Step 1: 修改 HomePage 传递 navStack @Param**

在 `HomePage.ets` 中 `buildModuleNav` 方法，找到挂号模块的 Navigation：

```typescript
Navigation(this.regStack) {
  OnsiteRegistrationPage()
}
```

改为：

```typescript
Navigation(this.regStack) {
  OnsiteRegistrationPage({ navStack: this.regStack })
}
```

这是唯一的改动。行号约为 L139-L141。

- [ ] **Step 2: Commit**

```bash
git add front/entry/src/main/ets/pages/HomePage.ets
git commit -m "feat: pass navPathStack to OnsiteRegistrationPage for internal navigation"
```

---

### Task 8: 构建验证

**Files:** None (verification only)

- [ ] **Step 1: 运行 ArkTS 编译检查**

```bash
cd front && hvigorw assembleHap -p product=default 2>&1 | tail -30
```

预期结果：BUILD SUCCESSFUL，无编译错误。

- [ ] **Step 2: 检查编译输出中的错误**

若有编译错误，使用 build-error-resolver agent 逐一修正，确保零错误通过。

---

## 自审

- **Spec coverage**: 挂号工作台(Drawer+联动) ✓, 收费(搜索+多选+JSON) ✓, 退费(镜像收费) ✓, 退号(搜索) ✓, 费用查询(不变) ✓
- **Placeholder scan**: 无 TBD/TODO，无模糊描述，所有代码完整可执行
- **Type consistency**: RegistrationService 签名与各页面调用一致，Model 字段与后端数据库列对齐
