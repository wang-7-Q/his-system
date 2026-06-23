# 挂号模块重新设计

> 东软云医院 HIS — HarmonyOS ArkTS V2 前端

## 背景

挂号收费模块当前有 5 个页面，存在以下问题：

- `OnsiteRegistrationPage`：缺失 6 个关键字段（visit_date、noon、age_type、birthday、card_number、regist_method 等），缺少号别-医生联动和号额检查
- `ExpenseChargePage`：API 对接错误 — 后端接收 `@RequestBody List<Map>`，前端只传了 `regist_id + amount`
- `ExpenseRefundPage`：同上，缺少项目明细和患者信息展示
- 缺少快捷导航能力，页面之间没有入口连接

## 设计目标

将挂号模块从"5 个松散独立页面"转变为**以工作流为核心的仪表盘**，减少页面跳转，在同上下文完成高频操作。

## 导航结构

```
挂号收费 Tab
  ├── 挂号工作台 (RegistrationWorkbenchPage)       ← 主页面，原名 OnsiteRegistrationPage
  │     ├── 快捷操作卡：新增挂号 | 退号 | 收费 | 退费 | 费用查询
  │     ├── 今日挂号列表 (表格 + 分页 + 日期/午别过滤)
  │     └── 新增挂号表单 (侧滑 Drawer)
  ├── 退号 → RegistrationRecordPage
  ├── 收费 → ExpenseChargePage
  ├── 退费 → ExpenseRefundPage
  └── 费用查询 → ExpenseManagePage
```

## 逐页设计

### 1. RegistrationWorkbenchPage（挂号工作台）

**核心改动**：表单从 Dialog 弹窗改为侧边 Drawer，补齐 6 个缺失字段，实现号别-医生联动和号额检查。

**布局**：顶部快捷操作卡（5 个按钮导航到子功能）→ 过滤器行（日期 + 午别）→ 挂号列表表格 → 分页器 → 新增挂号侧边抽屉面板

**新增挂号表单字段**：
- 基本信息：病历号(auto)、姓名、性别、年龄、年龄类型(年/天)、出生日期、身份证号、家庭住址
- 挂号信息：看诊日期(auto-today)、午别(auto)、科室(下拉)、号别(下拉联动)、医生(下拉联动)、初始号额(auto)、已用号额(auto)、病历本(开关)、应收金额(auto)、收费方式(下拉)、结算类别(下拉)

**交互逻辑**：
1. 快捷操作卡中的 退号/收费/退费/费用查询 通过 `navPathStack.pushPath` 导航
2. 号别切换 → 自动填充 regist_money + total_number，重新请求医生列表（按科室+号别过滤）
3. 医生切换 → 调用 `getAlreadyRegisterCount` 查询已用号额，号额满则警告
4. 病历本开关打开 → 应收金额 +1 元
5. 下拉数据源在 `aboutToAppear` 预加载
6. 病历号从 `getMaxCaseNumber` 自动生成（最大号 +1）
7. 提交成功 → 清空表单、刷新列表、重新生成病历号

### 2. ExpenseChargePage（收费）— 重写

**核心改动**：从简单列表 + 金额输入框改为 搜索 → 项目明细表格(多选) → 合计收费 三步流。

**布局**：搜索区（病历号 + 姓名 + 搜索按钮）→ 患者信息行（姓名/身份证/年龄/性别）→ 待收费项目表格（复选框 + 项目名/单价/类型/数量/开立时间）→ 底部固定合计 + 收费结算按钮

**交互逻辑**：
1. 搜索 → `searchExpenseChargePatient` → 返回 registMap + requestList
2. 行勾选/取消 → 实时更新合计金额
3. 收费结算 → 将已选项目 List `POST` 到 `expenseCharge`
4. 成功后刷新列表

### 3. ExpenseRefundPage（退费）— 重写

**核心改动**：镜像收费页结构，搜索 → 已收费项目明细(多选) → 确认退费。

**布局**：搜索区 → 患者信息行 → 已收费项目表格（复选框 + 项目名/单价/类型/收费时间/数量）→ 底部确认退费按钮（点击弹出 ConfirmDialog）

**交互逻辑**：
1. 搜索 → `searchExpenseRefundPatient` → 返回 registMap + 已收费项目列表
2. 多选 → 实时合计
3. 确认退费 → ConfirmDialog → `POST` 已选项目到 `expenseRefund`
4. 成功后刷新

### 4. RegistrationRecordPage（退号）— 小幅优化

添加搜索框（病历号/姓名），其余保持现有结构。

### 5. ExpenseManagePage（费用查询）— 保持不变

当前实现已可用，搜索 + 分页列表结构合理。

## 实现要点

- 使用 ArkUI V2 状态管理（`@ComponentV2`、`@Local`、`@Param`、`@Event`）
- 使用 `Navigation` + `NavPathStack` 路由
- 遵循 MVVM 模式，业务逻辑与 UI 分离
- 表单 Drawer 使用 `transition` 动画滑入/滑出
- 不可变数据模式，创建新对象替代直接修改
- 错误处理：所有 API 调用包裹 try/catch，失败时 Toast 提示
