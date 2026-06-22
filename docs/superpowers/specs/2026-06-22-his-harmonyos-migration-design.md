# 东软云医院 HIS — Vue 2 → HarmonyOS ArkTS 前端迁移方案

**日期**: 2026-06-22  
**状态**: 设计阶段完成，待用户审阅  
**目标**: 将 HIS 教学项目前端从 Vue 2 + Element UI 重写为 HarmonyOS ArkTS V2，后端 Spring Boot 完全不动  
**输出目录**: `C:\Users\32031\Desktop\Front`（全新的 DevEco Studio 鸿蒙工程）  
**现有前端**: `C:\Users\32031\Desktop\shixun\front\`（Vue 2，保留不动）  
**现有后端**: `C:\Users\32031\Desktop\shixun\backend\`（Spring Boot，保留不动）

---

## 1. 项目现状

### 前端技术栈

| 维度 | 当前 |
|------|------|
| 框架 | Vue 2.6 |
| UI 库 | Element UI 2.15 |
| 路由 | vue-router 3 |
| 状态管理 | Vuex 3（几乎未使用，实际用 sessionStorage） |
| HTTP 请求 | axios 0.26，全部硬编码 URL |
| 构建 | @vue/cli-service 4.x (webpack 4) |

### 页面规模

- 35 个 `.vue` 业务视图文件 + 1 个布局组件 + 1 个登录页
- 6 个路由分组：挂号收费(5) · 门诊医生(11) · 检查管理(4) · 检验管理(4) · 药房管理(4) · 处置管理(4)
- 0 个可复用组件（`components/` 目录为空）
- 65+ 个 API 端点

### 后端（不动）

| 模块 | 端口 | 职责 |
|------|------|------|
| his-drugstore | 8091 | 登录、药房发药/退药、药库管理 |
| his-outpatient | 8092 | 挂号、门诊、检查、检验、处置 |

接口格式：`application/x-www-form-urlencoded` 表单编码  
响应格式：`RestBean { list, totalCount, msg, status }`

---

## 2. 目标技术方案

### 2.1 技术选型

| 维度 | 选择 | 说明 |
|------|------|------|
| 开发工具 | DevEco Studio | 华为官方 IDE |
| 语言 | ArkTS | 鸿蒙官方 TypeScript 超集 |
| 组件模型 | **ArkTS V2** | `@ComponentV2` / `@Local` / `@Param` / `@Event` / `@ObservedV2` / `@Trace` |
| 导航 | `Navigation` + `NavPathStack` | 鸿蒙官方导航组件 |
| 响应式 | `BreakpointSystem` | 三断点自动切换手机/平板布局 |
| HTTP | `@ohos.net.http` | 封装为 ApiClient 单例 |
| 持久化 | `@ohos.data.preferences` | 替代 sessionStorage |
| 目标设备 | 手机 + 平板 | SM(320~600) / MD(600~840) / LG(840+) 三断点 |

### 2.2 总体方案：ArkUI 原生 + 自建通用组件层

**核心思路**：先建约 10 个对标 Element UI 的通用 ArkUI 组件，再做页面迁移。组件和业务完全解耦。

---

## 3. 分层架构

```
┌─────────────────────────────────────────────────────┐
│                  View Layer (页面)                     │
│  LoginPage · HomePage · 30 个业务子页面              │
│  └─ 6 个 Tab 组 → 手机底部导航 / 平板侧栏             │
├─────────────────────────────────────────────────────┤
│               Component Layer (通用组件 ~10 个)        │
│  DataTable · SearchForm · FormDialog · PageHeader     │
│  StatusBadge · ConfirmDialog · DrugSelector           │
│  PatientCard · PaginationBar · EmptyState             │
├─────────────────────────────────────────────────────┤
│              Service Layer (业务 & API)               │
│  ApiClient(统一HTTP) · AuthService                    │
│  RegistrationService · PhysicianService               │
│  CheckService · InspectionService                     │
│  DrugstoreService · DisposalService                   │
├─────────────────────────────────────────────────────┤
│               Model Layer (数据模型)                   │
│  RestBean<T> · Patient · Registration · Drug          │
│  CheckItem · InspectionItem · Prescription · Expense  │
├─────────────────────────────────────────────────────┤
│              Foundation Layer (基础)                   │
│  ApiClient · StorageUtil · BreakpointSystem           │
│  Constants · Validators · RouterConfig                │
└─────────────────────────────────────────────────────┘
```

---

## 4. 项目目录结构

鸿蒙工程根目录：`C:\Users\32031\Desktop\Front\`

```
Front/                              # DevEco Studio 项目根目录 (C:\Users\32031\Desktop\Front)
├── build-profile.json5             # SDK 5.0.5
├── entry/src/main/ets/             # 主模块源码
│   ├── entryability/
│   │   └── EntryAbility.ets
│   ├── pages/
│   │   ├── LoginPage.ets
│   │   ├── HomePage.ets            (手机 Tab 版)
│   │   ├── HomeTabletPage.ets      (平板侧栏版)
│   │   ├── registration/           (5 页 · Phase 1)
│   │   │   ├── OnsiteRegistrationPage.ets
│   │   │   ├── RegistrationRecordPage.ets
│   │   │   ├── ExpenseChargePage.ets
│   │   │   ├── ExpenseRefundPage.ets
│   │   │   └── ExpenseManagePage.ets
│   │   ├── physician/              (11 页 · Phase 2)
│   │   │   ├── PhysicianPatientPage.ets
│   │   │   ├── HomeMedicalRecordPage.ets
│   │   │   ├── OutpatientDiagnosisPage.ets
│   │   │   ├── CheckRequestPage.ets
│   │   │   ├── CheckResultsPage.ets
│   │   │   ├── InspectionRequestPage.ets
│   │   │   ├── InspectionResultsPage.ets
│   │   │   ├── DisposalRequestPage.ets
│   │   │   ├── WritePrescriptionPage.ets
│   │   │   ├── ExpenseQueryPage.ets
│   │   │   └── PhysicianHistoryPage.ets
│   │   ├── check/                  (4 页 · Phase 3)
│   │   │   ├── CheckApplyPage.ets
│   │   │   ├── CheckPatientPage.ets
│   │   │   ├── CheckInputPage.ets
│   │   │   └── CheckManagePage.ets
│   │   ├── inspection/             (4 页 · Phase 3)
│   │   │   ├── InspectionApplyPage.ets
│   │   │   ├── InspectionPatientPage.ets
│   │   │   ├── InspectionInputPage.ets
│   │   │   └── InspectionManagePage.ets
│   │   ├── drugstore/              (4 页 · Phase 4)
│   │   │   ├── GiveMedicinePage.ets
│   │   │   ├── RefundMedicinePage.ets
│   │   │   ├── DrugStoragePage.ets
│   │   │   └── TranHistoryPage.ets
│   │   └── disposal/               (4 页 · Phase 4)
│   │       ├── DisposalApplyPage.ets
│   │       ├── DisposalPatientPage.ets
│   │       ├── DisposalInputPage.ets
│   │       └── DisposalManagePage.ets
│   ├── components/                 (10 个通用组件)
│   │   ├── DataTable.ets
│   │   ├── SearchForm.ets
│   │   ├── FormDialog.ets
│   │   ├── PageHeader.ets
│   │   ├── PaginationBar.ets
│   │   ├── StatusBadge.ets
│   │   ├── ConfirmDialog.ets
│   │   ├── DrugSelector.ets
│   │   ├── PatientCard.ets
│   │   └── EmptyState.ets
│   ├── services/
│   │   ├── ApiClient.ets           (HTTP 单例，双端口配置)
│   │   ├── AuthService.ets
│   │   ├── RegistrationService.ets
│   │   ├── PhysicianService.ets
│   │   ├── CheckService.ets
│   │   ├── InspectionService.ets
│   │   ├── DrugstoreService.ets
│   │   └── DisposalService.ets
│   ├── models/
│   │   ├── RestBean.ets
│   │   ├── Patient.ets
│   │   ├── Registration.ets
│   │   ├── Drug.ets
│   │   ├── CheckItem.ets
│   │   ├── InspectionItem.ets
│   │   ├── DisposalItem.ets
│   │   ├── Prescription.ets
│   │   ├── Expense.ets
│   │   └── User.ets
│   ├── common/
│   │   ├── BreakpointSystem.ets
│   │   ├── StorageUtil.ets
│   │   ├── Constants.ets
│   │   └── Validators.ets
│   └── resources/
```
```

---

## 5. 通用组件设计

### 5.1 组件清单与 Element UI 映射

| # | 通用组件 | 对应 Element UI | 使用频率 | 说明 |
|---|---------|----------------|---------|------|
| 1 | DataTable | el-table | 25+ 页 | 列配置、排序、行选择、操作列 |
| 2 | SearchForm | el-form (inline) | 20+ 页 | 多字段、搜索/重置、日期选择 |
| 3 | FormDialog | el-dialog + el-form | 15+ 页 | 新增/编辑弹窗、校验、提交 |
| 4 | PageHeader | — | 所有页 | 标题、返回、操作按钮 |
| 5 | PaginationBar | el-pagination | 15+ 页 | 页码、每页条数、总数 |
| 6 | StatusBadge | el-tag | 10+ 页 | 状态色标 |
| 7 | ConfirmDialog | el-message-box | 通用 | 确认/取消/危险操作 |
| 8 | DrugSelector | — | 药房专用 | 搜索药品、显示库存 |
| 9 | PatientCard | — | 诊疗专用 | 患者信息卡片 |
| 10 | EmptyState | — | 通用 | 空数据、加载失败 |

### 5.2 设计原则

- **DataTable**: 接受 `columns: ColumnConfig[]` + `data: T[]` + 可选 `onRowClick` + `actions` 插槽
- **SearchForm**: 接受 `fields: SearchField[]` + `onSearch(fields)` + `onReset()`
- **FormDialog**: 接受 `fields: FormField[]` + `onSubmit(values)` + 内置校验
- 所有组件使用 `@Param` 接收配置、`@Event` 回调事件

---

## 6. API 层设计

### 6.1 ApiClient 单例

```typescript
class ApiClient {
  private baseUrl8091 = 'http://localhost:8091'  // 药房 + 登录
  private baseUrl8092 = 'http://localhost:8092'  // 门诊 + 检查 + 检验 + 处置

  get<T>(port: 8091 | 8092, path: string, params?: Record<string, Object>): Promise<RestBean<T>>
  post<T>(port: 8091 | 8092, path: string, body?: Record<string, Object>): Promise<RestBean<T>>
}
```

- 所有请求统一 `Content-Type: application/x-www-form-urlencoded`
- 自动将请求参数转换为 urlencoded 格式
- RestBean 响应自动解析为泛型

### 6.2 Service 模块

每个 Service 封装一个业务域的 API 调用，不包含 UI 逻辑，返回 Promise。

```typescript
class RegistrationService {
  addRegister(data: RegisterForm): Promise<RestBean<Registration>>
  refundMedicalRecord(registId: string): Promise<RestBean<void>>
  expenseCharge(data: ChargeForm): Promise<RestBean<void>>
  expenseRefund(data: RefundForm): Promise<RestBean<void>>
  getRecordRefundPatient(): Promise<RestBean<Patient>>
  getRegistDoctorList(): Promise<RestBean<Doctor>>
  getRegistLevelList(): Promise<RestBean<RegistLevel>>
  getAllDeptList(): Promise<RestBean<Department>>
  getSettleCategory(): Promise<RestBean<SettleCategory>>
  // ...共约 65 个端点
}
```

### 6.3 错误处理三层策略

```
ApiClient 拦截 → 网络异常/HTTP错误 → 统一 Toast
Service 层    → RestBean.status≠1 → 返回错误信息
页面层        → EmptyState / ConfirmDialog / Toast
```

---

## 7. 状态管理（ArkTS V2）

### 7.1 映射关系

| Vue 2 概念 | ArkTS V2 | 说明 |
|-----------|----------|------|
| `data()` | `@Local` | 组件内部状态 |
| `props` | `@Param` + `@Event` | 父→子传参，子→父事件 |
| `computed` | `@Computed` | 派生计算值 |
| `watch` | `@Monitor` | 状态变化监听 |
| Vuex store | `@ObservedV2` + `@Trace` | 跨组件共享的可观察模型 |
| sessionStorage | `@ohos.data.preferences` | 持久化存储 |

### 7.2 页面标准骨架

```typescript
@ComponentV2
struct TypicalPage {
  @Local searchParams: SearchFormData = new SearchFormData()
  @Local tableData: ItemType[] = []
  @Local loading: boolean = false
  @Local pagination: PageInfo = { page: 1, size: 10, total: 0 }
  @Local dropdownOptions: DropdownData = new DropdownData()
  @Local dialogVisible: boolean = false
  @Local dialogForm: FormData = new FormData()

  aboutToAppear(): void {
    this.loadDropdownOptions()
    this.search()
  }

  build() {
    Column() {
      PageHeader({ title: '页面标题' })
      SearchForm({ fields, onSearch: () => this.search() })
      DataTable({ columns, data: this.tableData, loading: this.loading })
      PaginationBar({ info: this.pagination, onChange: (p) => this.search(p) })
    }
  }
}
```

---

## 8. 响应式布局

### 8.1 断点定义

| 断点 | 宽度范围 | 设备 | 导航模式 |
|------|---------|------|---------|
| SM | 320~600vp | 手机竖屏 | 底部 6 Tab + NavPathStack 栈 |
| MD | 600~840vp | 小平板/手机横屏 | 6 Tab 或缩略侧栏 |
| LG | 840+vp | 平板横屏 | SideNavigation 侧栏 + 内容区 |

### 8.2 实现方式

使用 `BreakpointSystem` API 监听窗口宽度变化，通过 `@StorageLink` 驱动导航组件切换。同一套页面代码，不同布局容器。

---

## 9. 认证流程

保持与现有后端 Session 模式兼容：

```
1. 登录 → AuthService.login(user, pwd)
2. 成功 → preferences.put('Flag', 'isLogin') + preferences.put('loginUser', user)
3. 路由守卫 → @StorageLink('Flag') 监听，未登录跳转 LoginPage
4. 权限过滤 → loginUser.dept_type 决定显示的 Tab/菜单
5. 登出 → 清空 preferences，跳转 LoginPage
```

---

## 10. 分阶段迁移路线图

### Phase 0: 基础设施搭建（前置条件）

**产出**:
- [x] ApiClient 封装 + 双端口配置 + 错误拦截
- [x] 10 个通用组件库
- [x] 导航框架（手机 Tab + 平板 SideNavigation + BreakpointSystem）
- [x] 认证模块（LoginPage + AuthService + preferences 存储 + 路由守卫）
- [x] 所有数据模型 interface 定义

**验证标准**: 登录流程可跑通，通用组件在 Storyboard 中可展示

### Phase 1: 登录 + 挂号收费（6 页）

- [ ] LoginPage（登录）
- [ ] OnsiteRegistrationPage（窗口挂号）
- [ ] RegistrationRecordPage（窗口退号）
- [ ] ExpenseChargePage（收费）
- [ ] ExpenseRefundPage（退费）
- [ ] ExpenseManagePage（费用记录查询）

**验证标准**: 与 8092 后端连通，完整挂号退号收费退费流程可走通

### Phase 2: 门诊医生（11 页）

- [ ] PhysicianPatientPage（患者查看）
- [ ] HomeMedicalRecordPage（病历首页）
- [ ] OutpatientDiagnosisPage（门诊确诊）
- [ ] CheckRequestPage（检查申请）
- [ ] CheckResultsPage（检查结果）
- [ ] InspectionRequestPage（检验申请）
- [ ] InspectionResultsPage（检验结果）
- [ ] DisposalRequestPage（处置申请）
- [ ] WritePrescriptionPage（开设处方）
- [ ] ExpenseQueryPage（费用查询）
- [ ] PhysicianHistoryPage（看诊记录）

**验证标准**: 医生诊疗完整流程：患者→病历→确诊→开处方/申请检查检验

### Phase 3: 检查管理 + 检验管理（8 页）

- [ ] CheckApplyPage（检查申请）
- [ ] CheckPatientPage（患者录入）
- [ ] CheckInputPage（检查结果录入）
- [ ] CheckManagePage（检查管理）
- [ ] InspectionApplyPage（检验申请）
- [ ] InspectionPatientPage（患者录入）
- [ ] InspectionInputPage（检验结果录入）
- [ ] InspectionManagePage（检验管理）

**验证标准**: 检查/检验申请→录入→管理流程完整

### Phase 4: 药房管理 + 处置管理（8 页）

- [ ] GiveMedicinePage（药房发药）
- [ ] RefundMedicinePage（药房退药）
- [ ] DrugStoragePage（药库管理）
- [ ] TranHistoryPage（交易记录）
- [ ] DisposalApplyPage（处置申请）
- [ ] DisposalPatientPage（患者录入）
- [ ] DisposalInputPage（处置录入）
- [ ] DisposalManagePage（处置管理）

**验证标准**: 药房发药退药（8091）和处置管理（8092）双端口均正常

---

## 11. 风险与注意事项

| 风险 | 缓解措施 |
|------|---------|
| urlencoded 格式兼容性 | ApiClient 封装层统一处理，使用 `URLSearchParams` 构建请求体 |
| 平板/手机布局差异 | 使用 BreakpointSystem，在 Phase 0 就验证双布局 |
| 第三方组件缺失 | 采用方案B自建组件，不依赖社区库 |
| 现有脚手架 V1 遗留 | Phase 0 用 V2 重写 EntryAbility 和入口页面 |
| 后端双端口 8091/8092 | ApiClient 内置端口路由表，根据接口自动选择 |

---

## 12. 后续步骤

设计文档确认后：
1. 使用 `/writing-plans` 生成详细的实现计划（按 Phase 0→1→2→3→4）
2. 每阶段使用 `harmonyos-dev-expert` 代理辅助开发
3. 每阶段完成后进行联调验证
