/**
 * @file 挂号工作台
 * 功能：快捷操作卡导航 + 今日挂号列表 + 侧边抽屉新增挂号表单
 * 号别-医生联动、号额检查、病历本费用计算
 */
import { HttpParams } from '../../services/ApiClient'
import { PageHeader } from '../../components/PageHeader'
import { RegistrationService } from '../../services/RegistrationService'
import { PageInfo, PaginationBar } from '../../components/PaginationBar'
import { RegistLevel, Department, Doctor, SettleCategory, Registration } from '../../models/Registration'
import { RestBean } from '../../models/RestBean'
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
      const results = await Promise.all([
        RegistrationService.getRegistLevelList(),
        RegistrationService.getAllDeptList(),
        RegistrationService.getSettleCategory(),
      ])
      const levels: RestBean<RegistLevel> = results[0] as RestBean<RegistLevel>
      const depts: RestBean<Department> = results[1] as RestBean<Department>
      const settle: RestBean<SettleCategory> = results[2] as RestBean<SettleCategory>
      this.registLevels = levels.list || []
      this.departments = depts.list || []
      this.settleCategories = settle.list || []
      this.loadDoctors()
    } catch (_e) {
      promptAction.showToast({ message: '加载下拉选项失败', duration: 2000 })
    }
  }

  private async loadDoctors(): Promise<void> {
    try {
      const result = await RegistrationService.getRegistDoctorList(
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
      const result: RestBean<Registration> = await RegistrationService.getAlreadyRegisterList(
        this.visitDate, this.noon, ''
      )
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
    this.loadDoctors()
  }

  /**
   * 科室变化 — 重新加载医生
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
      this.registMoney = Math.max(0, current - 1).toFixed(2)
    }
  }

  // ==================== 表单操作 ====================

  private async openDrawer(): Promise<void> {
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
      if (options[i].value === value) {
        return i
      }
    }
    return 0
  }

  // ==================== Builder 方法 ====================

  @Builder
  shortcutCards() {
    Row() {
      this.shortcutCard('新增挂号', '#409EFF', () => this.openDrawer())
      this.shortcutCard('退号', '#E6A23C', () => {
        this.navStack.pushPath({ name: 'RegistrationRecordPage' })
      })
      this.shortcutCard('收费', '#67C23A', () => {
        this.navStack.pushPath({ name: 'ExpenseChargePage' })
      })
      this.shortcutCard('退费', '#F56C6C', () => {
        this.navStack.pushPath({ name: 'ExpenseRefundPage' })
      })
      this.shortcutCard('费用查询', '#909399', () => {
        this.navStack.pushPath({ name: 'ExpenseManagePage' })
      })
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
  formField(
    label: string, value: string, onChange: (v: string) => void,
    w?: number, enabled: boolean = true
  ) {
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
  formPicker(
    label: string, options: SelectOption[], selected: string,
    onChange: (v: string) => void
  ) {
    Row() {
      Text(label)
        .fontSize(13)
        .fontColor('#606266')
        .width(72)
      Select(options)
        .layoutWeight(1)
        .height(34)
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
            Text('✕')
              .fontSize(18)
              .fontColor('#909399')
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
              this.formField('姓名 *', this.patientName, (v: string) => {
                this.patientName = v
              })
              Row() {
                this.formField('性别', this.gender, (v: string) => {
                  this.gender = v
                }, 40)
                this.formField('年龄', this.age, (v: string) => {
                  this.age = v
                }, 40)
                this.formField('类型', this.ageType, (v: string) => {
                  this.ageType = v
                }, 40)
              }
              this.formField('出生日期', this.birthday, (v: string) => {
                this.birthday = v
              })
              this.formField('身份证号', this.idCard, (v: string) => {
                this.idCard = v
              })
              this.formField('家庭住址', this.address, (v: string) => {
                this.address = v
              })

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
