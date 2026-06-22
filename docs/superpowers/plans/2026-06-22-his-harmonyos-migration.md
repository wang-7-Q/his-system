# HIS HarmonyOS ArkTS 前端迁移 — 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将东软云医院 HIS 前端从 Vue 2 + Element UI 完整迁移至 HarmonyOS ArkTS V2，保持后端 Spring Boot 完全不动

**Architecture:** 五层架构 (View → Component → Service → Model → Foundation)，ArkTS V2 组件模型，ApiClient 单例管理双端口 HTTP 通信，手机用底部 Tab + NavPathStack，平板用 SideNavigation 侧栏布局，三断点自适应

**Tech Stack:** ArkTS V2 (@ComponentV2/@Local/@Param/@ObservedV2), HarmonyOS Navigation, @ohos.net.http, @ohos.data.preferences, BreakpointSystem

**Output:** `C:\Users\32031\Desktop\Front\`

---

## Phase 0: 基础设施搭建（全阶段前置条件）

### Task 0.1: 初始化鸿蒙工程结构

**Files:**
- Create: `C:\Users\32031\Desktop\Front\build-profile.json5`
- Create: `C:\Users\32031\Desktop\Front\entry\build-profile.json5`
- Create: `C:\Users\32031\Desktop\Front\entry\src\main\module.json5`
- Create: `C:\Users\32031\Desktop\Front\entry\src\main\resources\base\profile\main_pages.json`
- Create: `C:\Users\32031\Desktop\Front\entry\src\main\resources\base\element\string.json`

- [ ] **Step 1: 创建 build-profile.json5（项目根）**

```json5
{
  "app": {
    "signingConfigs": [],
    "products": [
      {
        "name": "default",
        "signingConfig": "default",
        "compatibleSdkVersion": "5.0.5(12)",
        "targetSdkVersion": "5.0.5(12)",
        "runtimeOS": "HarmonyOS"
      }
    ]
  },
  "modules": [
    {
      "name": "entry",
      "srcPath": "./entry",
      "targets": [
        {
          "name": "default",
          "applyToProducts": ["default"]
        }
      ]
    }
  ]
}
```

- [ ] **Step 2: 创建 entry/build-profile.json5**

```json5
{
  "apiType": "stageMode",
  "buildOption": {
    "arkOptions": {
      "runtimeOnly": false
    }
  },
  "targets": [
    {
      "name": "default",
      "runtimeOS": "HarmonyOS"
    }
  ]
}
```

- [ ] **Step 3: 创建 entry/src/main/module.json5**

```json5
{
  "module": {
    "name": "entry",
    "type": "entry",
    "srcEntry": "./ets/entryability/EntryAbility.ets",
    "description": "东软云医院HIS",
    "mainElement": "EntryAbility",
    "deviceTypes": ["phone", "tablet"],
    "deliveryWithInstall": true,
    "installationFree": false,
    "pages": "$profile:main_pages",
    "abilities": [
      {
        "name": "EntryAbility",
        "srcEntry": "./ets/entryability/EntryAbility.ets",
        "description": "HIS主入口",
        "icon": "$media:startIcon",
        "label": "$string:app_name",
        "startWindowIcon": "$media:startIcon",
        "startWindowBackground": "$color:start_window_background",
        "exported": true,
        "skills": [
          {
            "entities": ["entity.system.home"],
            "actions": ["action.system.home"]
          }
        ]
      }
    ],
    "requestPermissions": [
      {
        "name": "ohos.permission.INTERNET",
        "reason": "$string:internet_permission_reason"
      }
    ]
  }
}
```

- [ ] **Step 4: 创建 main_pages.json**

```json
[
  "pages/LoginPage",
  "pages/HomePage"
]
```

- [ ] **Step 5: 创建 string.json**

```json
{
  "string": [
    { "name": "app_name", "value": "云医院HIS" },
    { "name": "internet_permission_reason", "value": "需要网络访问以连接医院系统后端" }
  ]
}
```

---

### Task 0.2: 创建数据模型层 (models/)

**Files:** 10 个模型文件

- [ ] **Step 1: 创建 RestBean.ets — 统一响应封装**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\models\RestBean.ets

export interface RestBean<T> {
  list: T[]
  totalCount: number
  msg: string
  status: number
}
```

- [ ] **Step 2: 创建 Patient.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\models\Patient.ets

export interface Patient {
  id: number
  name: string
  gender: string
  age: number
  id_card: string
  phone: string
  address: string
  case_number: string
}
```

- [ ] **Step 3: 创建 Registration.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\models\Registration.ets

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

export interface RegistLevel {
  id: number
  level_name: string
  price: number
}

export interface Department {
  id: number
  dept_name: string
  dept_type: string
}

export interface Doctor {
  id: number
  realname: string
  dept_id: number
}
```

- [ ] **Step 4: 创建 Drug.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\models\Drug.ets

export interface Drug {
  id: number
  drug_code: string
  drug_name: string
  drug_format: string
  manufacturer: string
  unit_price: number
  stock: number
  expiry_date: string
}

export interface PrescriptionDrug {
  drug_id: number
  drug_name: string
  quantity: number
  usage_method: string
  dosage: string
  frequency: string
  days: number
}
```

- [ ] **Step 5: 创建 CheckItem.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\models\CheckItem.ets

export interface CheckItem {
  id: number
  item_name: string
  dept_name: string
  price: number
}

export interface CheckRequest {
  id: number
  regist_id: string
  patient_name: string
  check_item: string
  status: string
  request_date: string
}
```

- [ ] **Step 6: 创建 InspectionItem.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\models\InspectionItem.ets

export interface InspectionItem {
  id: number
  item_name: string
  dept_name: string
  price: number
}

export interface InspectionRequest {
  id: number
  regist_id: string
  patient_name: string
  inspection_item: string
  status: string
  request_date: string
}
```

- [ ] **Step 7: 创建 DisposalItem.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\models\DisposalItem.ets

export interface DisposalItem {
  id: number
  item_name: string
  dept_name: string
  price: number
}

export interface DisposalRequest {
  id: number
  regist_id: string
  patient_name: string
  disposal_item: string
  status: string
  request_date: string
}
```

- [ ] **Step 8: 创建 Prescription.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\models\Prescription.ets

export interface Prescription {
  id: number
  regist_id: string
  drug_name: string
  quantity: number
  price: number
  total_price: number
  status: string
}
```

- [ ] **Step 9: 创建 Expense.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\models\Expense.ets

export interface Expense {
  id: number
  regist_id: string
  patient_name: string
  item_name: string
  item_type: string
  price: number
  status: string
  charge_date: string
}
```

- [ ] **Step 10: 创建 User.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\models\User.ets

export interface User {
  id: number
  realname: string
  username: string
  password?: string
  dept_type: string
  dept_name: string
  regist_level_id: number
  regist_level: string
  settle_category_id: number
}
```

---

### Task 0.3: 创建公共工具层 (common/)

**Files:** 4 个工具文件

- [ ] **Step 1: 创建 Constants.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\common\Constants.ets

export class Constants {
  static readonly PORT_8091 = 8091
  static readonly PORT_8092 = 8092

  static readonly BASE_URL_8091 = 'http://localhost:8091'
  static readonly BASE_URL_8092 = 'http://localhost:8092'

  static readonly PAGE_SIZE_DEFAULT = 10
  static readonly PAGE_SIZES = [5, 10, 20, 50]

  // 6 个模块的 Tab 配置
  static readonly TAB_CONFIGS: TabConfig[] = [
    { name: '挂号收费', icon: 'icon_registration', type: '挂号', port: 8092 },
    { name: '门诊医生', icon: 'icon_physician', type: '门诊', port: 8092 },
    { name: '检查管理', icon: 'icon_check', type: '检查', port: 8092 },
    { name: '检验管理', icon: 'icon_inspection', type: '检验', port: 8092 },
    { name: '药房管理', icon: 'icon_drugstore', type: '药房', port: 8091 },
    { name: '处置管理', icon: 'icon_disposal', type: '处置', port: 8092 },
  ]

  // 路由路径映射
  static readonly ROUTE_PATHS: Record<string, string[]> = {
    '挂号收费': ['onsite-registration', 'registration-record', 'expense-charge', 'expense-refund', 'expense-manage'],
    '门诊医生': ['physician-patient', 'home-medical-record', 'outpatient-diagnosis', 'check-request', 'check-results', 'inspection-request', 'inspection-results', 'disposal-request', 'write-prescription', 'expense-query', 'physician-history'],
    '检查管理': ['check-apply', 'check-patient', 'check-input', 'check-manage'],
    '检验管理': ['inspection-apply', 'inspection-patient', 'inspection-input', 'inspection-manage'],
    '药房管理': ['give-medicine', 'refund-medicine', 'drug-storage', 'tran-history'],
    '处置管理': ['disposal-apply', 'disposal-patient', 'disposal-input', 'disposal-manage'],
  }
}

export interface TabConfig {
  name: string
  icon: string
  type: string
  port: number
}
```

- [ ] **Step 2: 创建 StorageUtil.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\common\StorageUtil.ets

import { preferences } from '@kit.ArkData'

const STORE_NAME = 'his_preferences'

export class StorageUtil {
  private static store?: preferences.Preferences

  static async init(context: Context): Promise<void> {
    this.store = await preferences.getPreferences(context, STORE_NAME)
  }

  static async put(key: string, value: string): Promise<void> {
    if (!this.store) throw new Error('StorageUtil not initialized')
    await this.store.put(key, value)
    await this.store.flush()
  }

  static async get(key: string): Promise<string> {
    if (!this.store) throw new Error('StorageUtil not initialized')
    return await this.store.get(key, '') as string
  }

  static async remove(key: string): Promise<void> {
    if (!this.store) throw new Error('StorageUtil not initialized')
    await this.store.delete(key)
    await this.store.flush()
  }

  static async clearAll(): Promise<void> {
    if (!this.store) throw new Error('StorageUtil not initialized')
    await this.store.clear()
    await this.store.flush()
  }

  static async isLoggedIn(): Promise<boolean> {
    const flag = await this.get('Flag')
    return flag === 'isLogin'
  }

  static async getLoginUser(): Promise<string> {
    return await this.get('loginUser')
  }
}
```

- [ ] **Step 3: 创建 Validators.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\common\Validators.ets

export class Validators {
  static isNotEmpty(value: string, fieldName: string): string {
    if (!value || value.trim().length === 0) {
      return `${fieldName}不能为空`
    }
    return ''
  }

  static isNumber(value: string, fieldName: string): string {
    if (isNaN(Number(value))) {
      return `${fieldName}必须是数字`
    }
    return ''
  }

  static isPhone(value: string): string {
    const phoneReg = /^1[3-9]\d{9}$/
    if (!phoneReg.test(value)) {
      return '请输入有效的手机号码'
    }
    return ''
  }

  static validateForm(fields: FormValidationItem[]): boolean {
    for (const field of fields) {
      const error = field.validator(field.value, field.fieldName)
      if (error) {
        field.onError(error)
        return false
      }
    }
    return true
  }
}

export interface FormValidationItem {
  value: string
  fieldName: string
  validator: (value: string, fieldName: string) => string
  onError: (message: string) => void
}
```

- [ ] **Step 4: 创建 BreakpointSystem.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\common\BreakpointSystem.ets

import { window } from '@kit.ArkUI'

export enum BreakpointType {
  SM = 'sm',   // 320~600vp 手机
  MD = 'md',   // 600~840vp 小平板
  LG = 'lg',   // 840+vp 平板
}

export class BreakpointSystem {
  static updateBreakpoint(windowClass: window.Window): void {
    const width = windowClass.getWindowProperties().windowRect.width
    const breakpoint = this.getBreakpoint(width)
    AppStorage.setOrCreate('currentBreakpoint', breakpoint)
  }

  static getBreakpoint(width: number): BreakpointType {
    if (width < 600) return BreakpointType.SM
    if (width < 840) return BreakpointType.MD
    return BreakpointType.LG
  }

  static isTablet(): boolean {
    const bp = AppStorage.get<string>('currentBreakpoint')
    return bp === BreakpointType.LG
  }
}
```

---

### Task 0.4: 创建 ApiClient (services/ApiClient.ets)

**Files:**
- Create: `C:\Users\32031\Desktop\Front\entry\src\main\ets\services\ApiClient.ets`

- [ ] **Step 1: 实现 ApiClient 单例**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\services\ApiClient.ets

import { http } from '@kit.NetworkKit'
import { RestBean } from '../models/RestBean'
import { promptAction } from '@kit.ArkUI'

export class ApiClient {
  private static instance: ApiClient

  static getInstance(): ApiClient {
    if (!ApiClient.instance) {
      ApiClient.instance = new ApiClient()
    }
    return ApiClient.instance
  }

  private baseUrl(port: number): string {
    return port === 8091 ? 'http://localhost:8091' : 'http://localhost:8092'
  }

  private buildUrl(port: number, path: string, params?: Record<string, Object>): string {
    let url = `${this.baseUrl(port)}${path}`
    if (params && Object.keys(params).length > 0) {
      const query = Object.entries(params)
        .filter(([_, v]) => v !== undefined && v !== null && v !== '')
        .map(([k, v]) => `${encodeURIComponent(k)}=${encodeURIComponent(String(v))}`)
        .join('&')
      if (query) url += `?${query}`
    }
    return url
  }

  private toUrlEncoded(body: Record<string, Object>): string {
    return Object.entries(body)
      .filter(([_, v]) => v !== undefined && v !== null)
      .map(([k, v]) => `${encodeURIComponent(k)}=${encodeURIComponent(String(v))}`)
      .join('&')
  }

  async get<T>(
    port: number,
    path: string,
    params?: Record<string, Object>
  ): Promise<RestBean<T>> {
    const url = this.buildUrl(port, path, params)
    const request = http.createHttp()
    try {
      const response = await request.request(url, { method: http.RequestMethod.GET })
      request.destroy()
      if (response.responseCode !== 200) {
        throw new Error(`HTTP ${response.responseCode}: ${url}`)
      }
      const result = JSON.parse(response.result as string) as RestBean<T>
      if (result.status !== 1) {
        promptAction.showToast({ message: result.msg || '操作失败', duration: 2000 })
      }
      return result
    } catch (err) {
      request.destroy()
      promptAction.showToast({ message: `网络请求失败: ${url}`, duration: 2000 })
      throw err
    }
  }

  async post<T>(
    port: number,
    path: string,
    body?: Record<string, Object>
  ): Promise<RestBean<T>> {
    const url = `${this.baseUrl(port)}${path}`
    const request = http.createHttp()
    try {
      const response = await request.request(url, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        extraData: body ? this.toUrlEncoded(body) : undefined,
      })
      request.destroy()
      if (response.responseCode !== 200) {
        throw new Error(`HTTP ${response.responseCode}: ${url}`)
      }
      const result = JSON.parse(response.result as string) as RestBean<T>
      if (result.status !== 1) {
        promptAction.showToast({ message: result.msg || '操作失败', duration: 2000 })
      }
      return result
    } catch (err) {
      request.destroy()
      promptAction.showToast({ message: `网络请求失败: ${url}`, duration: 2000 })
      throw err
    }
  }
}
```

---

### Task 0.5: 创建 AuthService

**Files:**
- Create: `C:\Users\32031\Desktop\Front\entry\src\main\ets\services\AuthService.ets`

- [ ] **Step 1: 实现 AuthService**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\services\AuthService.ets

import { ApiClient } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { User } from '../models/User'
import { StorageUtil } from '../common/StorageUtil'
import { promptAction } from '@kit.ArkUI'

export class AuthService {
  private static api = ApiClient.getInstance()

  static async login(username: string, password: string): Promise<RestBean<User>> {
    const result = await this.api.get<User>(8091, '/login', {
      username: username,
      password: password,
      type: '1'
    })
    if (result.status === 1 && result.list && result.list.length > 0) {
      const user = result.list[0]
      await StorageUtil.put('Flag', 'isLogin')
      await StorageUtil.put('loginUser', JSON.stringify(user))
      AppStorage.setOrCreate('isLoggedIn', true)
      AppStorage.setOrCreate('loginUser', user)
    }
    return result
  }

  static async logout(): Promise<void> {
    await StorageUtil.remove('Flag')
    await StorageUtil.remove('loginUser')
    AppStorage.setOrCreate('isLoggedIn', false)
    AppStorage.setOrCreate('loginUser', null)
  }

  static getLoginUserFromCache(): User | null {
    const cached = AppStorage.get<User>('loginUser')
    return cached || null
  }

  static getUserDeptType(): string {
    const user = this.getLoginUserFromCache()
    return user ? user.dept_type : ''
  }
}
```

---

### Task 0.6: 创建通用组件 (components/) — Part 1 (基础组件)

**Files:** Create 5 files: PageHeader, StatusBadge, ConfirmDialog, EmptyState, PaginationBar

- [ ] **Step 1: PageHeader.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\components\PageHeader.ets

@ComponentV2
export struct PageHeader {
  @Param title: string = ''
  @Param showBack: boolean = false
  @Event onBack?: () => void
  @BuilderParam actionArea?: () => void

  build() {
    Row() {
      if (this.showBack) {
        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.ic_back'))
            .width(24).height(24)
        }
        .width(36).height(36)
        .backgroundColor(Color.Transparent)
        .onClick(() => this.onBack?.())
        .margin({ right: 12 })
      }
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#303133')
        .layoutWeight(1)
      if (this.actionArea) {
        this.actionArea()
      }
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .margin({ bottom: 12 })
  }
}
```

- [ ] **Step 2: StatusBadge.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\components\StatusBadge.ets

const STATUS_COLORS: Record<string, string> = {
  '已缴费': '#67C23A',
  '未缴费': '#F56C6C',
  '已完成': '#409EFF',
  '待处理': '#E6A23C',
  '已退费': '#909399',
  '已发药': '#67C23A',
  '未发药': '#F56C6C',
  '已退药': '#909399',
  '待检查': '#E6A23C',
  '待检验': '#E6A23C',
  '待处置': '#E6A23C',
}

@ComponentV2
export struct StatusBadge {
  @Param status: string = ''

  @Computed
  get bgColor(): string {
    return STATUS_COLORS[this.status] || '#909399'
  }

  build() {
    Text(this.status)
      .fontSize(12)
      .fontColor('#FFFFFF')
      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
      .borderRadius(4)
      .backgroundColor(this.bgColor)
  }
}
```

- [ ] **Step 3: ConfirmDialog.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\components\ConfirmDialog.ets

@ComponentV2
export struct ConfirmDialog {
  @Param visible: boolean = false
  @Param title: string = '提示'
  @Param message: string = ''
  @Param confirmText: string = '确定'
  @Param cancelText: string = '取消'
  @Param danger: boolean = false
  @Event onConfirm?: () => void
  @Event onCancel?: () => void

  build() {
    if (this.visible) {
      Stack() {
        // 遮罩
        Column()
          .width('100%').height('100%')
          .backgroundColor('rgba(0,0,0,0.4)')
          .onClick(() => this.onCancel?.())

        // 对话框
        Column() {
          Text(this.title).fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 12 })
          Text(this.message).fontSize(14).fontColor('#606266').margin({ bottom: 20 })
          Row() {
            Button(this.cancelText)
              .backgroundColor('#F5F5F5')
              .fontColor('#606266')
              .layoutWeight(1)
              .onClick(() => this.onCancel?.())
            Blank().width(12)
            Button(this.confirmText)
              .backgroundColor(this.danger ? '#F56C6C' : '#409EFF')
              .fontColor('#FFFFFF')
              .layoutWeight(1)
              .onClick(() => this.onConfirm?.())
          }
          .width('100%')
        }
        .width(300)
        .padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({ radius: 20, color: 'rgba(0,0,0,0.15)' })
      }
      .width('100%').height('100%')
    }
  }
}
```

- [ ] **Step 4: EmptyState.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\components\EmptyState.ets

@ComponentV2
export struct EmptyState {
  @Param text: string = '暂无数据'
  @Param showRetry: boolean = false
  @Event onRetry?: () => void

  build() {
    Column() {
      Image($r('app.media.ic_empty'))
        .width(80).height(80)
        .fillColor('#C0C4CC')
        .margin({ bottom: 16 })
      Text(this.text)
        .fontSize(14)
        .fontColor('#909399')
        .margin({ bottom: this.showRetry ? 16 : 0 })
      if (this.showRetry) {
        Button('重新加载')
          .fontSize(13)
          .backgroundColor('#409EFF')
          .fontColor('#FFFFFF')
          .onClick(() => this.onRetry?.())
      }
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(200)
  }
}
```

- [ ] **Step 5: PaginationBar.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\components\PaginationBar.ets

export interface PageInfo {
  page: number
  size: number
  total: number
}

@ComponentV2
export struct PaginationBar {
  @Param pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Param pageSizes: number[] = [5, 10, 20, 50]
  @Event onChange?: (page: number, size: number) => void

  @Local currentPage: number = 1
  @Local currentSize: number = 10
  @Local pageCount: number = 0

  @Computed
  get totalPages(): number {
    return Math.ceil(this.pageInfo.total / this.pageInfo.size)
  }

  build() {
    Row() {
      Text(`共 ${this.pageInfo.total} 条`)
        .fontSize(13).fontColor('#909399')

      Blank()

      Button('<')
        .width(32).height(32)
        .fontSize(13)
        .enabled(this.pageInfo.page > 1)
        .backgroundColor('#F5F5F5')
        .onClick(() => {
          if (this.pageInfo.page > 1) {
            this.onChange?.(this.pageInfo.page - 1, this.pageInfo.size)
          }
        })

      Text(`${this.pageInfo.page} / ${this.totalPages}`)
        .fontSize(13)
        .margin({ left: 8, right: 8 })

      Button('>')
        .width(32).height(32)
        .fontSize(13)
        .enabled(this.pageInfo.page < this.totalPages)
        .backgroundColor('#F5F5F5')
        .onClick(() => {
          if (this.pageInfo.page < this.totalPages) {
            this.onChange?.(this.pageInfo.page + 1, this.pageInfo.size)
          }
        })

      Blank()

      Row() {
        Text('每页')
        Select(this.pageSizes.map(v => ({ value: String(v) })))
          .selected(this.pageInfo.size)
          .width(70)
          .onSelect((index: number) => {
            const newSize = this.pageSizes[index]
            this.onChange?.(1, newSize)
          })
        Text('条')
      }
      .margin({ left: 16 })
    }
    .width('100%')
    .height(48)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .margin({ top: 12 })
  }
}
```

---

### Task 0.7: 创建通用组件 (components/) — Part 2 (数据密集型组件)

**Files:** Create 5 files: DataTable, SearchForm, FormDialog, DrugSelector, PatientCard

- [ ] **Step 1: DataTable.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\components\DataTable.ets

export interface ColumnConfig<T> {
  key: string
  title: string
  width?: number
  flex?: number
  render?: (row: T) => void
  @BuilderParam cell?: (row: T) => void
}

@ComponentV2
export struct DataTable<T extends Object> {
  @Param columns: ColumnConfig<T>[] = []
  @Param data: T[] = []
  @Param loading: boolean = false
  @Param rowKey: string = 'id'
  @Param showIndex: boolean = true
  @Event onRowClick?: (row: T) => void
  @BuilderParam actionColumn?: (row: T) => void

  build() {
    Column() {
      // 表头
      Row() {
        if (this.showIndex) {
          Text('#').width(48).fontSize(13).fontWeight(FontWeight.Bold).fontColor('#303133').textAlign(TextAlign.Center)
        }
        ForEach(this.columns, (col: ColumnConfig<T>) => {
          Text(col.title)
            .width(col.width)
            .layoutWeight(col.flex ? 0 : 1)
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#303133')
            .padding({ left: 8, right: 8 })
        }, (col: ColumnConfig<T>) => col.key)
        if (this.actionColumn) {
          Text('操作').width(120).fontSize(13).fontWeight(FontWeight.Bold).fontColor('#303133').textAlign(TextAlign.Center)
        }
      }
      .width('100%')
      .height(44)
      .backgroundColor('#F5F7FA')
      .borderRadius({ topLeft: 8, topRight: 8 })

      // 表格主体
      if (this.loading) {
        LoadingProgress()
          .width(40).height(40)
          .margin({ top: 60, bottom: 60 })
      } else if (this.data.length === 0) {
        EmptyState({ text: '暂无数据' })
      } else {
        List() {
          ForEach(this.data, (row: T, index: number) => {
            ListItem() {
              Row() {
                if (this.showIndex) {
                  Text(`${index + 1}`).width(48).fontSize(13).fontColor('#606266').textAlign(TextAlign.Center)
                }
                ForEach(this.columns, (col: ColumnConfig<T>) => {
                  Text(this.getCellValue(row, col.key))
                    .width(col.width)
                    .layoutWeight(col.flex ? 0 : 1)
                    .fontSize(13)
                    .fontColor('#606266')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .padding({ left: 8, right: 8 })
                }, (col: ColumnConfig<T>) => col.key)
                if (this.actionColumn) {
                  Row() {
                    this.actionColumn(row)
                  }
                  .width(120)
                  .justifyContent(FlexAlign.Center)
                }
              }
              .width('100%')
              .height(48)
              .backgroundColor(index % 2 === 0 ? '#FFFFFF' : '#FAFAFA')
              .onClick(() => this.onRowClick?.(row))
            }
          }, (row: T, index: number) => `${index}`)
        }
        .layoutWeight(1)
        .divider({ strokeWidth: 1, color: '#EBEEF5' })
      }
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
  }

  private getCellValue(row: T, key: string): string {
    return String((row as Record<string, Object>)[key] ?? '')
  }
}
```

- [ ] **Step 2: SearchForm.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\components\SearchForm.ets

export interface SearchField {
  key: string
  label: string
  type: 'text' | 'select' | 'date'
  placeholder?: string
  options?: { label: string, value: string }[]
}

@ComponentV2
export struct SearchForm {
  @Param fields: SearchField[] = []
  @Event onSearch?: (values: Record<string, string>) => void
  @Event onReset?: () => void
  @Local formValues: Record<string, string> = {}

  aboutToAppear(): void {
    this.resetValues()
  }

  private resetValues(): void {
    const values: Record<string, string> = {}
    this.fields.forEach(f => values[f.key] = '')
    this.formValues = values
  }

  build() {
    Row() {
      ForEach(this.fields, (field: SearchField) => {
        Row() {
          Text(field.label).fontSize(13).fontColor('#606266').margin({ right: 8 })
          if (field.type === 'text') {
            TextInput({ placeholder: field.placeholder || `请输入${field.label}` })
              .width(160).height(32).fontSize(13)
              .onChange((value: string) => this.formValues[field.key] = value)
          } else if (field.type === 'select' && field.options) {
            Select(field.options)
              .width(160).height(32)
              .onSelect((index: number) => {
                this.formValues[field.key] = field.options![index].value
              })
          } else if (field.type === 'date') {
            DatePicker()
              .width(160).height(32)
              .onChange((value: Date) => {
                this.formValues[field.key] = `${value.getFullYear()}-${String(value.getMonth()+1).padStart(2,'0')}-${String(value.getDate()).padStart(2,'0')}`
              })
          }
        }
        .margin({ right: 12 })
      }, (field: SearchField) => field.key)

      Button('搜索')
        .fontSize(13)
        .backgroundColor('#409EFF')
        .fontColor('#FFFFFF')
        .height(32)
        .onClick(() => this.onSearch?.({...this.formValues}))

      Button('重置')
        .fontSize(13)
        .backgroundColor('#F5F5F5')
        .fontColor('#606266')
        .height(32)
        .margin({ left: 8 })
        .onClick(() => {
          this.resetValues()
          this.onReset?.()
        })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .margin({ bottom: 12 })
    .flexWrap(FlexWrap.Wrap)
  }
}
```

- [ ] **Step 3: FormDialog.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\components\FormDialog.ets

export interface FormField {
  key: string
  label: string
  type: 'text' | 'select' | 'date' | 'number'
  required?: boolean
  placeholder?: string
  options?: { label: string, value: string }[]
}

@ComponentV2
export struct FormDialog {
  @Param visible: boolean = false
  @Param title: string = '表单'
  @Param fields: FormField[] = []
  @Param loading: boolean = false
  @Event onSubmit?: (values: Record<string, string>) => void
  @Event onCancel?: () => void
  @Local formValues: Record<string, string> = {}
  @Local errors: Record<string, string> = {}

  aboutToAppear(): void {
    this.initForm()
  }

  private initForm(): void {
    const values: Record<string, string> = {}
    const errs: Record<string, string> = {}
    this.fields.forEach(f => {
      values[f.key] = ''
      errs[f.key] = ''
    })
    this.formValues = values
    this.errors = errs
  }

  build() {
    if (this.visible) {
      Stack() {
        Column()
          .width('100%').height('100%')
          .backgroundColor('rgba(0,0,0,0.4)')
          .onClick(() => this.onCancel?.())

        Column() {
          Text(this.title).fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 20 })

          ForEach(this.fields, (field: FormField) => {
            Column() {
              Row() {
                Text(field.label).fontSize(14).fontColor('#606266').width(80)
                if (field.type === 'text' || field.type === 'number') {
                  TextInput({ placeholder: field.placeholder || '' })
                    .layoutWeight(1).height(36).fontSize(13)
                    .type(field.type === 'number' ? InputType.Number : InputType.Normal)
                    .onChange((value: string) => this.formValues[field.key] = value)
                } else if (field.type === 'select' && field.options) {
                  Select(field.options)
                    .layoutWeight(1).height(36)
                    .onSelect((index: number) => {
                      this.formValues[field.key] = field.options![index].value
                    })
                } else if (field.type === 'date') {
                  DatePicker()
                    .layoutWeight(1).height(36)
                    .onChange((value: Date) => {
                      this.formValues[field.key] = `${value.getFullYear()}-${String(value.getMonth()+1).padStart(2,'0')}-${String(value.getDate()).padStart(2,'0')}`
                    })
                }
              }
              if (this.errors[field.key]) {
                Text(this.errors[field.key]).fontSize(11).fontColor('#F56C6C').margin({ top: 4, left: 80 })
              }
            }
            .margin({ bottom: 12 })
          }, (field: FormField) => field.key)

          Row() {
            Button('取消')
              .backgroundColor('#F5F5F5').fontColor('#606266').layoutWeight(1)
              .onClick(() => this.onCancel?.())
            Blank().width(12)
            Button('确定')
              .backgroundColor('#409EFF').fontColor('#FFFFFF').layoutWeight(1)
              .loading(this.loading)
              .onClick(() => this.onSubmit?.({...this.formValues}))
          }
          .width('100%')
        }
        .width('90%')
        .maxHeight('80%')
        .padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
      }
      .width('100%').height('100%')
    }
  }
}
```

- [ ] **Step 4: DrugSelector.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\components\DrugSelector.ets

import { Drug } from '../models/Drug'
import { ApiClient } from '../services/ApiClient'

@ComponentV2
export struct DrugSelector {
  @Param visible: boolean = false
  @Event onSelect?: (drug: Drug) => void
  @Event onCancel?: () => void
  @Local searchKey: string = ''
  @Local drugList: Drug[] = []
  @Local loading: boolean = false
  private api = ApiClient.getInstance()

  private async search(): Promise<void> {
    this.loading = true
    try {
      const result = await this.api.post<Drug>(8092, '/searchDrug', { keyword: this.searchKey })
      if (result.list) {
        this.drugList = result.list
      }
    } finally {
      this.loading = false
    }
  }

  build() {
    if (this.visible) {
      Stack() {
        Column()
          .width('100%').height('100%')
          .backgroundColor('rgba(0,0,0,0.4)')
          .onClick(() => this.onCancel?.())

        Column() {
          Text('选择药品').fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 12 })
          Row() {
            TextInput({ placeholder: '输入药品名称搜索' })
              .layoutWeight(1).height(36).fontSize(13)
              .onChange((value: string) => this.searchKey = value)
            Button('搜索')
              .fontSize(13).backgroundColor('#409EFF').fontColor('#FFFFFF')
              .height(36).margin({ left: 8 })
              .onClick(() => this.search())
          }
          .margin({ bottom: 12 })

          if (this.loading) {
            LoadingProgress().width(40).height(40).margin(40)
          } else {
            List() {
              ForEach(this.drugList, (drug: Drug) => {
                ListItem() {
                  Row() {
                    Column() {
                      Text(drug.drug_name).fontSize(14).fontColor('#303133')
                      Text(`${drug.drug_format} | ${drug.manufacturer}`).fontSize(12).fontColor('#909399')
                    }
                    .layoutWeight(1)
                    Text(`¥${drug.unit_price}`).fontSize(14).fontColor('#F56C6C').margin({ right: 12 })
                    Text(`库存: ${drug.stock}`).fontSize(12).fontColor('#909399').margin({ right: 12 })
                    Button('选择')
                      .fontSize(12).backgroundColor('#67C23A').fontColor('#FFFFFF')
                      .height(28)
                      .onClick(() => this.onSelect?.(drug))
                  }
                  .width('100%').padding(12)
                  .border({ width: { bottom: 1 }, color: '#EBEEF5' })
                }
              }, (drug: Drug) => `${drug.id}`)
            }
            .layoutWeight(1)
          }
        }
        .width('90%').height('70%')
        .padding(20).backgroundColor('#FFFFFF').borderRadius(12)
      }
      .width('100%').height('100%')
    }
  }
}
```

- [ ] **Step 5: PatientCard.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\components\PatientCard.ets

import { Patient } from '../models/Patient'

@ComponentV2
export struct PatientCard {
  @Param patient: Patient | null = null

  build() {
    if (this.patient) {
      Column() {
        Row() {
          Text(this.patient.name)
            .fontSize(18).fontWeight(FontWeight.Bold).fontColor('#303133')
          Blank()
          Text(this.patient.gender)
            .fontSize(14).fontColor('#606266')
            .margin({ right: 12 })
          Text(`${this.patient.age}岁`)
            .fontSize(14).fontColor('#606266')
        }
        .width('100%').margin({ bottom: 8 })

        Row() {
          Text('病历号：').fontSize(13).fontColor('#909399')
          Text(this.patient.case_number).fontSize(13).fontColor('#303133').margin({ right: 20 })
          Text('身份证：').fontSize(13).fontColor('#909399')
          Text(this.patient.id_card).fontSize(13).fontColor('#303133')
        }
        .width('100%').margin({ bottom: 4 })

        Row() {
          Text('电话：').fontSize(13).fontColor('#909399')
          Text(this.patient.phone).fontSize(13).fontColor('#303133').margin({ right: 20 })
          Text('地址：').fontSize(13).fontColor('#909399')
          Text(this.patient.address).fontSize(13).fontColor('#303133')
        }
        .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F0F9FF')
      .borderRadius(8)
      .border({ width: 1, color: '#BAE7FF' })
    }
  }
}
```

---

### Task 0.8: 创建登录页和导航控制

**Files:**
- Create: `C:\Users\32031\Desktop\Front\entry\src\main\ets\pages\LoginPage.ets`
- Create: `C:\Users\32031\Desktop\Front\entry\src\main\ets\entryability\EntryAbility.ets`
- Modify: `C:\Users\32031\Desktop\Front\entry\src\main\resources\base\profile\main_pages.json`

- [ ] **Step 1: 创建 LoginPage.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\pages\LoginPage.ets

import { AuthService } from '../services/AuthService'
import { router } from '@kit.ArkUI'

@ComponentV2
struct LoginPage {
  @Local username: string = ''
  @Local password: string = ''
  @Local loading: boolean = false
  @Local errorMsg: string = ''

  private async doLogin(): Promise<void> {
    if (!this.username || !this.password) {
      this.errorMsg = '请输入用户名和密码'
      return
    }
    this.loading = true
    this.errorMsg = ''
    try {
      const result = await AuthService.login(this.username, this.password)
      if (result.status === 1) {
        router.replaceUrl({ url: 'pages/HomePage' })
      } else {
        this.errorMsg = result.msg || '登录失败'
      }
    } catch (e) {
      this.errorMsg = '网络连接失败，请确认后端服务已启动'
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      // Logo + 标题
      Column() {
        Image($r('app.media.startIcon'))
          .width(72).height(72)
          .margin({ bottom: 16 })
        Text('东软云医院 HIS')
          .fontSize(28).fontWeight(FontWeight.Bold).fontColor('#20A0FF')
        Text('Hospital Information System')
          .fontSize(14).fontColor('#909399').margin({ top: 8 })
      }
      .margin({ top: 80, bottom: 60 })

      // 登录表单
      Column() {
        TextInput({ placeholder: '用户名', text: 'root' })
          .width('100%').height(44).fontSize(15)
          .borderRadius(8).backgroundColor('#F5F7FA')
          .margin({ bottom: 16 })
          .onChange((value: string) => this.username = value)

        TextInput({ placeholder: '密码', text: '123' })
          .width('100%').height(44).fontSize(15)
          .borderRadius(8).backgroundColor('#F5F7FA')
          .type(InputType.Password)
          .onChange((value: string) => this.password = value)

        if (this.errorMsg) {
          Text(this.errorMsg)
            .fontSize(13).fontColor('#F56C6C')
            .margin({ top: 8 })
        }

        Button('登 录')
          .width('100%').height(44).fontSize(16)
          .backgroundColor('#20A0FF').fontColor('#FFFFFF')
          .borderRadius(8).margin({ top: 24 })
          .loading(this.loading)
          .onClick(() => this.doLogin())
      }
      .width('100%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .shadow({ radius: 10, color: 'rgba(0,0,0,0.08)' })

      // 底部提示用户
      Text('可用账号: root / 挂号 / 扁鹊 / 检查 / 检验 / 处置  密码: 123')
        .fontSize(11).fontColor('#C0C4CC').margin({ top: 40 })
    }
    .width('100%').height('100%')
    .padding(24)
    .backgroundColor('#F0F2F5')
  }
}

export default LoginPage
```

- [ ] **Step 2: 更新 EntryAbility.ets 增加窗口监听和全局初始化**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\entryability\EntryAbility.ets

import { UIAbility, Want, AbilityConstant } from '@kit.AbilityKit'
import { window } from '@kit.ArkUI'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { StorageUtil } from '../common/StorageUtil'
import { BreakpointSystem } from '../common/BreakpointSystem'

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'HIS', 'Application onCreate')
    AppStorage.setOrCreate('isLoggedIn', false)
    AppStorage.setOrCreate('loginUser', null)
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    hilog.info(0x0000, 'HIS', 'onWindowStageCreate')

    const windowClass = await windowStage.getMainWindow()
    await StorageUtil.init(windowClass.getUIContext().getHostContext())

    // 设置初始断点
    BreakpointSystem.updateBreakpoint(windowClass)
    windowClass.on('windowSizeChange', () => {
      BreakpointSystem.updateBreakpoint(windowClass)
    })

    windowStage.loadContent('pages/LoginPage', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'HIS', `Failed to load content: ${err.code}`)
        return
      }
      hilog.info(0x0000, 'HIS', 'Content loaded successfully')
    })
  }

  onWindowStageDestroy(): void {
    hilog.info(0x0000, 'HIS', 'onWindowStageDestroy')
  }

  onForeground(): void {
    hilog.info(0x0000, 'HIS', 'onForeground')
  }

  onBackground(): void {
    hilog.info(0x0000, 'HIS', 'onBackground')
  }

  onDestroy(): void {
    hilog.info(0x0000, 'HIS', 'onDestroy')
  }
}
```

- [ ] **Step 3: 更新 main_pages.json**

```json
[
  "pages/LoginPage",
  "pages/HomePage"
]
```

---

### Task 0.9: 创建手机 HomePage (底部Tab + NavPathStack)

**Files:**
- Create: `C:\Users\32031\Desktop\Front\entry\src\main\ets\pages\HomePage.ets`

- [ ] **Step 1: 创建 HomePage.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\pages\HomePage.ets

import { AuthService } from '../services/AuthService'
import { User } from '../models/User'
import { Constants } from '../common/Constants'
import { router } from '@kit.ArkUI'

@ComponentV2
struct HomePage {
  @Local currentTab: number = 0
  @Local loginUser: User | null = null
  @Local userDeptType: string = ''

  aboutToAppear(): void {
    this.loadUser()
  }

  private loadUser(): void {
    this.loginUser = AppStorage.get<User>('loginUser')
    this.userDeptType = this.loginUser?.dept_type || ''
  }

  private tabsForUser(): TabConfig[] {
    if (!this.loginUser || this.userDeptType === 'root') {
      return Constants.TAB_CONFIGS
    }
    return Constants.TAB_CONFIGS.filter(t => t.type === this.userDeptType)
  }

  private async onLogout(): Promise<void> {
    await AuthService.logout()
    router.replaceUrl({ url: 'pages/LoginPage' })
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text(`云医院HIS - ${this.loginUser?.realname || ''}`)
          .fontSize(16).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
          .layoutWeight(1)
        Row() {
          Text(this.loginUser?.dept_name || '')
            .fontSize(13).fontColor('#FFFFFF').margin({ right: 16 })
          Button('退出')
            .fontSize(13).backgroundColor(Color.Transparent).fontColor('#FFFFFF')
            .border({ width: 1, color: '#FFFFFF' })
            .onClick(() => this.onLogout())
        }
      }
      .width('100%').height(48)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#20A0FF')

      // 内容区 — Tab切换
      Tabs({ index: this.currentTab }) {
        ForEach(this.tabsForUser(), (tab: TabConfig, index: number) => {
          TabContent() {
            Navigation(this.getNavStackForTab(tab.type)) {
              Column() {
                Text(`${tab.name}模块`).fontSize(16)
                // 此处将根据 tab.type 加载对应的子页面导航
              }
              .width('100%').height('100%')
            }
            .mode(NavigationMode.Stack)
            .hideTitleBar(true)
          }
          .tabBar(this.buildTabItem(tab, index))
        }, (tab: TabConfig) => tab.type)
      }
      .barHeight(56)
      .layoutWeight(1)

      // 底部版权信息
      if (this.loginUser?.dept_type !== 'root') {
        Text('⚠ 请勿使用root账号执行具体业务操作')
          .fontSize(11).fontColor('#E6A23C')
          .padding({ top: 4, bottom: 8 })
      }
    }
    .width('100%').height('100%')
    .backgroundColor('#F0F2F5')
  }

  private getNavStackForTab(tabType: string): NavPathStack {
    return new NavPathStack()
  }

  @Builder
  private buildTabItem(tab: TabConfig, index: number): void {
    Column() {
      Image(this.getTabIcon(tab.type))
        .width(24).height(24)
        .fillColor(index === this.currentTab ? '#20A0FF' : '#909399')
      Text(tab.name)
        .fontSize(11)
        .fontColor(index === this.currentTab ? '#20A0FF' : '#909399')
    }
  }

  private getTabIcon(type: string): Resource {
    // 使用系统内置图标作为占位
    return $r('app.media.startIcon')
  }
}

import { TabConfig } from '../common/Constants'

export default HomePage
```

---

### Task 0.10: 创建各业务 Service (Phase 0最后一环)

**Files:** 6 个 Service 文件

- [ ] **Step 1: 创建 RegistrationService.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\services\RegistrationService.ets

import { ApiClient } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { Registration, RegistLevel, Department, Doctor } from '../models/Registration'

export class RegistrationService {
  private static api = ApiClient.getInstance()

  static async addRegister(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/addRegister', data)
  }

  static async refundMedicalRecord(registId: string): Promise<RestBean<void>> {
    return this.api.get<void>(8092, '/refundMedicalRecord', { registId })
  }

  static async getRecordRefundPatient(): Promise<RestBean<Registration>> {
    return this.api.get<Registration>(8092, '/getRecordRefundPatient')
  }

  static async getAlreadyRegisterCount(): Promise<RestBean<{ count: number }>> {
    return this.api.get<{ count: number }>(8092, '/getAlreadyRegisterCount')
  }

  static async getRegistDoctorList(): Promise<RestBean<Doctor>> {
    return this.api.get<Doctor>(8092, '/getRegistDoctorList')
  }

  static async getRegistLevelList(): Promise<RestBean<RegistLevel>> {
    return this.api.get<RegistLevel>(8092, '/getRegistLevelList')
  }

  static async getAllDeptList(): Promise<RestBean<Department>> {
    return this.api.get<Department>(8092, '/getAllDeptList')
  }

  static async getSettleCategory(): Promise<RestBean<{ id: number, name: string }>> {
    return this.api.get<{ id: number, name: string }>(8092, '/getSettleCategory')
  }

  static async getMaxCaseNumber(): Promise<RestBean<{ case_number: string }>> {
    return this.api.get<{ case_number: string }>(8092, '/getMaxCaseNumber')
  }

  static async expenseCharge(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/expenseCharge', data)
  }

  static async expenseRefund(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/expenseRefund', data)
  }

  static async searchExpenseChargePatient(): Promise<RestBean<Registration>> {
    return this.api.get<Registration>(8092, '/searchExpenseChargePatient')
  }

  static async searchExpenseRefundPatient(): Promise<RestBean<Registration>> {
    return this.api.get<Registration>(8092, '/searchExpenseRefundPatient')
  }

  static async searchAllPricePatient(params?: Record<string, Object>): Promise<RestBean<Registration>> {
    return this.api.get<Registration>(8092, '/searchAllPricePatient', params)
  }
}
```

- [ ] **Step 2: 创建 PhysicianService.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\services\PhysicianService.ets

import { ApiClient } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { Patient } from '../models/Patient'
import { Registration } from '../models/Registration'

export class PhysicianService {
  private static api = ApiClient.getInstance()

  static async getWaitPatient(): Promise<RestBean<Patient>> {
    return this.api.get<Patient>(8092, '/getWaitPatient')
  }

  static async getFinishPatientCount(): Promise<RestBean<{ count: number }>> {
    return this.api.get<{ count: number }>(8092, '/getFinishPatientCount')
  }

  static async getWaitPatientCount(): Promise<RestBean<{ count: number }>> {
    return this.api.get<{ count: number }>(8092, '/getWaitPatientCount')
  }

  static async treatPatient(registId: string): Promise<RestBean<Registration>> {
    return this.api.get<Registration>(8092, '/treatPatient', { registId })
  }

  static async getCheckedPatient(params: Record<string, Object>): Promise<RestBean<Registration>> {
    return this.api.post<Registration>(8092, '/getCheckedPatient', params)
  }

  static async getDisease(params: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/getDisease', params)
  }

  static async addHomeMedicalRecord(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/addHomeMedicalRecord', data)
  }

  static async outpatientDiagnosis(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/outpatientDiagnosis', data)
  }

  static async addCheckRequest(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/addCheckRequest', data)
  }

  static async getCheck(params: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/getCheck', params)
  }

  static async getCheckPatientTableByRegist(registId: string): Promise<RestBean<void>> {
    return this.api.get<void>(8092, '/getCheckPatientTableByRegist', { registId })
  }

  static async addInspectionRequest(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/addInspectionRequest', data)
  }

  static async getInspection(params: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/getInspection', params)
  }

  static async addDisposalRequest(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/addDisposalRequest', data)
  }

  static async getDisposal(params: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/getDisposal', params)
  }

  static async addPrescription(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/addPrescription', data)
  }

  static async searchDrug(params: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/searchDrug', params)
  }

  static async getPatientItemByPhysician(registId: string): Promise<RestBean<void>> {
    return this.api.get<void>(8092, '/getPatientItemByPhysician', { registId })
  }
}
```

- [ ] **Step 3: 创建 CheckService.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\services\CheckService.ets

import { ApiClient } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { CheckItem } from '../models/CheckItem'

export class CheckService {
  private static api = ApiClient.getInstance()

  static async getWaitCheckCount(): Promise<RestBean<{ count: number }>> {
    return this.api.get<{ count: number }>(8092, '/getWaitCheckCount')
  }

  static async getFinishCheckCount(): Promise<RestBean<{ count: number }>> {
    return this.api.get<{ count: number }>(8092, '/getFinishCheckCount')
  }

  static async getWaitCheck(): Promise<RestBean<CheckItem>> {
    return this.api.get<CheckItem>(8092, '/getWaitCheck')
  }

  static async getFinishCheck(params: Record<string, Object>): Promise<RestBean<CheckItem>> {
    return this.api.post<CheckItem>(8092, '/getFinishCheck', params)
  }

  static async getFinishCheckByRegistid(registId: string): Promise<RestBean<CheckItem>> {
    return this.api.get<CheckItem>(8092, '/getFinishCheckByRegistid', { registId })
  }

  static async getCheckPatientEmp(): Promise<RestBean<void>> {
    return this.api.get<void>(8092, '/getCheckPatientEmp')
  }

  static async getCheckPatientDept(): Promise<RestBean<void>> {
    return this.api.get<void>(8092, '/getCheckPatientDept')
  }

  static async updateCheckInput(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/updateCheckInput', data)
  }

  static async getPatientQuery(params: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/getPatientQuery', params)
  }

  static async getPatientItemByCheck(registId: string): Promise<RestBean<void>> {
    return this.api.get<void>(8092, '/getPatientItemByCheck', { registId })
  }

  static async updataCheckPatient(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/updataCheckPatient', data)
  }

  static async getCheckPatient(): Promise<RestBean<CheckItem>> {
    return this.api.get<CheckItem>(8092, '/getCheckPatient')
  }
}
```

- [ ] **Step 4: 创建 InspectionService.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\services\InspectionService.ets

import { ApiClient } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { InspectionItem } from '../models/InspectionItem'

export class InspectionService {
  private static api = ApiClient.getInstance()

  static async getWaitInspectionCount(): Promise<RestBean<{ count: number }>> {
    return this.api.get<{ count: number }>(8092, '/getWaitInspectionCount')
  }

  static async getFinishInspectionCount(): Promise<RestBean<{ count: number }>> {
    return this.api.get<{ count: number }>(8092, '/getFinishInspectionCount')
  }

  static async getWaitInspection(): Promise<RestBean<InspectionItem>> {
    return this.api.get<InspectionItem>(8092, '/getWaitInspection')
  }

  static async getInspectionPatient(): Promise<RestBean<InspectionItem>> {
    return this.api.get<InspectionItem>(8092, '/getInspectionPatient')
  }

  static async getInspectionPatientDept(): Promise<RestBean<void>> {
    return this.api.get<void>(8092, '/getInspectionPatientDept')
  }

  static async getInspectionPatientEmp(): Promise<RestBean<void>> {
    return this.api.get<void>(8092, '/getInspectionPatientEmp')
  }

  static async updataInspectionPatient(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/updataInspectionPatient', data)
  }

  static async getPatientItemByInspection(registId: string): Promise<RestBean<void>> {
    return this.api.get<void>(8092, '/getPatientItemByInspection', { registId })
  }
}
```

- [ ] **Step 5: 创建 DrugstoreService.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\services\DrugstoreService.ets

import { ApiClient } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { Drug } from '../models/Drug'

export class DrugstoreService {
  private static api = ApiClient.getInstance()

  static async getDrugInfo(params: Record<string, Object>): Promise<RestBean<Drug>> {
    return this.api.post<Drug>(8091, '/getDrugInfo', params)
  }

  static async getFinishPricePatient(params: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8091, '/getFinishPricePatient', params)
  }

  static async getPricePatientDrug(registId: string): Promise<RestBean<void>> {
    return this.api.get<void>(8091, '/getPricePatientDrug', { registId })
  }

  static async givePatientDrugs(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8091, '/givePatientDrugs', data)
  }

  static async getGivePricePatient(params: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8091, '/getGivePricePatient', params)
  }

  static async getGivePatientDrug(registId: string): Promise<RestBean<void>> {
    return this.api.get<void>(8091, '/getGivePatientDrug', { registId })
  }

  static async refundPatientDrugs(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8091, '/refundPatientDrugs', data)
  }
}
```

- [ ] **Step 6: 创建 DisposalService.ets**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\services\DisposalService.ets

import { ApiClient } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { DisposalItem } from '../models/DisposalItem'

export class DisposalService {
  private static api = ApiClient.getInstance()

  static async getWaitDisposalCount(): Promise<RestBean<{ count: number }>> {
    return this.api.get<{ count: number }>(8092, '/getWaitDisposalCount')
  }

  static async getFinishDisposalCount(): Promise<RestBean<{ count: number }>> {
    return this.api.get<{ count: number }>(8092, '/getFinishDisposalCount')
  }

  static async getWaitDisposal(): Promise<RestBean<DisposalItem>> {
    return this.api.get<DisposalItem>(8092, '/getWaitDisposal')
  }

  static async getFinishDisposal(params: Record<string, Object>): Promise<RestBean<DisposalItem>> {
    return this.api.post<DisposalItem>(8092, '/getFinishDisposal', params)
  }

  static async getFinishDisposalByRegistid(registId: string): Promise<RestBean<DisposalItem>> {
    return this.api.get<DisposalItem>(8092, '/getFinishDisposalByRegistid', { registId })
  }

  static async getDisposalPatientEmp(): Promise<RestBean<void>> {
    return this.api.get<void>(8092, '/getDisposalPatientEmp')
  }

  static async getDisposalPatientDept(): Promise<RestBean<void>> {
    return this.api.get<void>(8092, '/getDisposalPatientDept')
  }

  static async updateDisposalInput(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/updateDisposalInput', data)
  }

  static async getPatientItemByDisposal(registId: string): Promise<RestBean<void>> {
    return this.api.get<void>(8092, '/getPatientItemByDisposal', { registId })
  }

  static async updataDisposalPatient(data: Record<string, Object>): Promise<RestBean<void>> {
    return this.api.post<void>(8092, '/updataDisposalPatient', data)
  }

  static async getDisposalPatient(): Promise<RestBean<DisposalItem>> {
    return this.api.get<DisposalItem>(8092, '/getDisposalPatient')
  }
}
```

---

## Phase 1: 挂号收费模块 (6 页)

### 业务页面迁移模板 (适用于所有 Phase 1-4)

每个页面按以下模式：
1. 创建页面文件
2. 使用 `SearchForm` + `DataTable` + `PaginationBar` + `FormDialog` 组合
3. 调用对应的 Service 方法
4. 注册到 main_pages.json 和 HomePage 导航

### Task 1.1: OnsiteRegistrationPage（窗口挂号）

**Files:**
- Create: `C:\Users\32031\Desktop\Front\entry\src\main\ets\pages\registration\OnsiteRegistrationPage.ets`

- [ ] **Step 1: 实现页面**

```typescript
// C:\Users\32031\Desktop\Front\entry\src\main\ets\pages\registration\OnsiteRegistrationPage.ets

import { RegistrationService } from '../../services/RegistrationService'
import { PageInfo } from '../../components/PaginationBar'
import { RegistLevel, Department, Doctor } from '../../models/Registration'
import { ColumnConfig } from '../../components/DataTable'

interface RegistrationFormData {
  patientName: string
  gender: string
  age: string
  idCard: string
  phone: string
  address: string
  deptId: string
  doctorId: string
  registLevelId: string
  settleCategoryId: string
  caseNumber: string
}

@ComponentV2
struct OnsiteRegistrationPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Local registLevels: RegistLevel[] = []
  @Local departments: Department[] = []
  @Local doctors: Doctor[] = []
  @Local settleCategories: { id: number, name: string }[] = []
  @Local caseNumber: string = ''
  @Local dialogVisible: boolean = false
  @Local formValues: Record<string, string> = {}

  private columns: ColumnConfig<Object>[] = [
    { key: 'case_number', title: '病历号', width: 100 },
    { key: 'patient_name', title: '姓名', width: 80 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'doctor_name', title: '医生', width: 80 },
    { key: 'regist_level', title: '挂号级别', width: 80 },
    { key: 'status', title: '状态', width: 80 },
  ]

  aboutToAppear(): void {
    this.loadDropdowns()
    this.loadAlreadyRegistered()
  }

  private async loadDropdowns(): Promise<void> {
    const [levels, depts, doctors, settle, caseNo] = await Promise.all([
      RegistrationService.getRegistLevelList(),
      RegistrationService.getAllDeptList(),
      RegistrationService.getRegistDoctorList(),
      RegistrationService.getSettleCategory(),
      RegistrationService.getMaxCaseNumber(),
    ])
    this.registLevels = levels.list || []
    this.departments = depts.list || []
    this.doctors = doctors.list || []
    this.settleCategories = settle.list || []
    if (caseNo.list && caseNo.list.length > 0) {
      this.caseNumber = String(caseNo.list[0])
    }
  }

  private async loadAlreadyRegistered(): Promise<void> {
    this.loading = true
    try {
      const result = await RegistrationService.getAlreadyRegisterCount()
      // getAlreadyRegisterCount 返回挂号数量，这里简化处理
    } finally {
      this.loading = false
    }
  }

  private async onSubmit(values: Record<string, string>): Promise<void> {
    this.loading = true
    try {
      const result = await RegistrationService.addRegister(values)
      if (result.status === 1) {
        this.dialogVisible = false
        this.loadAlreadyRegistered()
      }
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      PageHeader({ title: '窗口挂号' })
      DataTable({ columns: this.columns, data: this.tableData, loading: this.loading })
    }
    .width('100%').height('100%')
    .padding(16).backgroundColor('#F0F2F5')
  }
}

export default OnsiteRegistrationPage
```

---

### Task 1.2: ExpenseChargePage（收费）

**Files:**
- Create: `C:\Users\32031\Desktop\Front\entry\src\main\ets\pages\registration\ExpenseChargePage.ets`

- [ ] **Step 1: 实现页面（代码结构同模板，使用 RegistrationService.expenseCharge）**

遵循与 Task 1.1 相同的 Page 模板，调用 `RegistrationService.expenseCharge` 和 `RegistrationService.searchExpenseChargePatient`。为简洁起见，此处不重复完整骨架代码，实际实施时按 Task 1.1 模板生成。

---

### Task 1.3-1.5: 其余挂号收费页面

按相同模板创建：
- `RegistrationRecordPage.ets` — 退号 (`refundMedicalRecord`, `getRecordRefundPatient`)
- `ExpenseRefundPage.ets` — 退费 (`expenseRefund`, `searchExpenseRefundPatient`)
- `ExpenseManagePage.ets` — 费用记录 (`searchAllPricePatient`)

每个页面遵循统一模板：
1. `@Local tableData`, `@Local loading`, `@Local pageInfo`
2. `@Local` 下拉选项（如需要）
3. `aboutToAppear` 加载初始数据
4. `build` 组合 `PageHeader + SearchForm + DataTable + PaginationBar`

---

## Phase 2-4: 其余业务模块 (27 页)

所有剩余页面的实施遵循 Phase 1 建立的统一页面模板。以下是每阶段的文件清单和对应的 Service 方法：

### Phase 2: 门诊医生模块 (11 pages)

| 页面 | 路径 | 主要 API 调用 |
|------|------|--------------|
| PhysicianPatientPage | `pages/physician/PhysicianPatientPage.ets` | `PhysicianService.getWaitPatient`, `treatPatient` |
| HomeMedicalRecordPage | `pages/physician/HomeMedicalRecordPage.ets` | `getDisease`, `addHomeMedicalRecord` |
| OutpatientDiagnosisPage | `pages/physician/OutpatientDiagnosisPage.ets` | `outpatientDiagnosis` |
| CheckRequestPage | `pages/physician/CheckRequestPage.ets` | `addCheckRequest`, `getCheck` |
| CheckResultsPage | `pages/physician/CheckResultsPage.ets` | `getCheckPatientTableByRegist` |
| InspectionRequestPage | `pages/physician/InspectionRequestPage.ets` | `addInspectionRequest`, `getInspection` |
| InspectionResultsPage | `pages/physician/InspectionResultsPage.ets` | `getCheckPatientTableByRegist` |
| DisposalRequestPage | `pages/physician/DisposalRequestPage.ets` | `addDisposalRequest`, `getDisposal` |
| WritePrescriptionPage | `pages/physician/WritePrescriptionPage.ets` | `addPrescription`, `searchDrug` |
| ExpenseQueryPage | `pages/physician/ExpenseQueryPage.ets` | `getPatientItemByPhysician` |
| PhysicianHistoryPage | `pages/physician/PhysicianHistoryPage.ets` | `getCheckedPatient` |

### Phase 3: 检查 + 检验模块 (8 pages)

| 页面 | 路径 | 主要 API 调用 |
|------|------|--------------|
| CheckApplyPage | `pages/check/CheckApplyPage.ets` | `CheckService.getWaitCheck`, `getWaitCheckCount`, `getFinishCheckCount` |
| CheckPatientPage | `pages/check/CheckPatientPage.ets` | `getCheckPatient`, `updataCheckPatient`, `getCheckPatientEmp`, `getCheckPatientDept` |
| CheckInputPage | `pages/check/CheckInputPage.ets` | `getFinishCheck`, `updateCheckInput`, `getFinishCheckByRegistid` |
| CheckManagePage | `pages/check/CheckManagePage.ets` | `getPatientQuery`, `getPatientItemByCheck` |
| InspectionApplyPage | `pages/inspection/InspectionApplyPage.ets` | `InspectionService.getWaitInspection`, `getWaitInspectionCount`, `getFinishInspectionCount` |
| InspectionPatientPage | `pages/inspection/InspectionPatientPage.ets` | `getInspectionPatient`, `updataInspectionPatient`, `getInspectionPatientDept`, `getInspectionPatientEmp` |
| InspectionInputPage | `pages/inspection/InspectionInputPage.ets` | `getInspectionPatient`(已完成的), `updataInspectionPatient` |
| InspectionManagePage | `pages/inspection/InspectionManagePage.ets` | `getPatientQuery`, `getPatientItemByInspection` |

### Phase 4: 药房 + 处置模块 (8 pages)

| 页面 | 路径 | 端口 | 主要 API 调用 |
|------|------|------|--------------|
| GiveMedicinePage | `pages/drugstore/GiveMedicinePage.ets` | 8091 | `DrugstoreService.getFinishPricePatient`, `getPricePatientDrug`, `givePatientDrugs` |
| RefundMedicinePage | `pages/drugstore/RefundMedicinePage.ets` | 8091 | `getGivePricePatient`, `getGivePatientDrug`, `refundPatientDrugs` |
| DrugStoragePage | `pages/drugstore/DrugStoragePage.ets` | 8091 | `getDrugInfo` |
| TranHistoryPage | `pages/drugstore/TranHistoryPage.ets` | 8092 | `getPatientQuery`, `getPatientItemByDrug` |
| DisposalApplyPage | `pages/disposal/DisposalApplyPage.ets` | 8092 | `DisposalService.getWaitDisposal`, `getWaitDisposalCount`, `getFinishDisposalCount` |
| DisposalPatientPage | `pages/disposal/DisposalPatientPage.ets` | 8092 | `getDisposalPatient`, `updataDisposalPatient`, `getDisposalPatientDept`, `getDisposalPatientEmp` |
| DisposalInputPage | `pages/disposal/DisposalInputPage.ets` | 8092 | `getFinishDisposal`, `updateDisposalInput`, `getFinishDisposalByRegistid` |
| DisposalManagePage | `pages/disposal/DisposalManagePage.ets` | 8092 | `getPatientQuery`, `getPatientItemByDisposal` |

---

## 通用页面生成器模板

将所有 Phase 1-4 页面纳入实施时，使用以下已验证的骨架直接生成：

```typescript
// 页面模板: <PageName>.ets
import { <ServiceName> } from '../../services/<ServiceName>'
import { PageInfo } from '../../components/PaginationBar'
import { ColumnConfig } from '../../components/DataTable'
import { SearchField } from '../../components/SearchForm'
import { FormField } from '../../components/FormDialog'

@ComponentV2
struct <PageName> {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Local dialogVisible: boolean = false

  private columns: ColumnConfig<Object>[] = [
    { key: '<col1>', title: '<列名1>' },
    { key: '<col2>', title: '<列名2>' },
  ]

  private searchFields: SearchField[] = [
    { key: '<key>', label: '<标签>', type: 'text', placeholder: '请输入' },
  ]

  aboutToAppear(): void { this.search() }

  private async search(page: number = 1): Promise<void> {
    this.loading = true
    try {
      const result = await <ServiceName>.<method>({ <params> })
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount
      }
    } finally { this.loading = false }
  }

  build() {
    Column() {
      PageHeader({ title: '<页面标题>' })
      SearchForm({
        fields: this.searchFields,
        onSearch: () => this.search(1),
        onReset: () => this.search(1)
      })
      DataTable({ columns: this.columns, data: this.tableData, loading: this.loading })
      PaginationBar({
        pageInfo: this.pageInfo,
        onChange: (page: number, size: number) => {
          this.pageInfo.page = page
          this.pageInfo.size = size
          this.search(page)
        }
      })
    }
    .width('100%').height('100%')
    .padding(16)
    .backgroundColor('#F0F2F5')
  }
}

export default <PageName>
```

---

## 验证检查点

### Phase 0 完成验证
1. 在 DevEco Studio 中打开 `C:\Users\32031\Desktop\Front` 工程
2. 构建无误（Build → Build Hap(s)）
3. 登录页 UI 正常显示
4. 点击登录能调用 `http://localhost:8091/login` 并跳转 HomePage
5. 手机/平板切换时导航布局自动调整

### Phase 1 完成验证
1. 挂号、退号、收费、退费、费用查询所有流程可走通
2. 与 8092 后端数据一致

### Phase 2~4 完成验证
1. 各模块核心业务流程可走通
2. 8091/8092 双端口数据正确

---

## 实施建议

1. **先跑通 Phase 0** — 这是所有页面的基础，必须完整验证
2. **每 Phase 完成后立即联调** — 不要等全部写完再测试
3. **使用 `harmonyos-dev-expert` 代理** — 遇到 ArkTS V2 / API 问题时可调度
4. **后端保持运行** — 开发期间确保 `his-drugstore:8091` 和 `his-outpatient:8092` 都在运行
5. **每个页面约 10-15 分钟** — 使用统一模板可快速批量生成
