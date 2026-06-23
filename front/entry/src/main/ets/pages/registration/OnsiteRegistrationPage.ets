import { HttpParams } from '../../services/ApiClient'
import { PageHeader } from '../../components/PageHeader'
import { RegistrationService } from '../../services/RegistrationService'
import { PageInfo } from '../../components/PaginationBar'
import { RegistLevel, Department, Doctor } from '../../models/Registration'
import { RestBean } from '../../models/RestBean'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { getStringField } from '../../utils/ObjectAccess'
import { promptAction } from '@kit.ArkUI'

interface SelectOption {
  label: string
  value: string
}

@ComponentV2
struct OnsiteRegistrationPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Local registLevels: RegistLevel[] = []
  @Local departments: Department[] = []
  @Local doctors: Doctor[] = []
  @Local settleCategories: Object[] = []
  @Local caseNumber: string = ''
  @Local dialogVisible: boolean = false
  @Local formLoading: boolean = false

  // Form fields
  @Local patientName: string = ''
  @Local gender: string = ''
  @Local age: string = ''
  @Local idCard: string = ''
  @Local phone: string = ''
  @Local address: string = ''
  @Local selectedDeptId: string = ''
  @Local selectedDoctorId: string = ''
  @Local selectedLevelId: string = ''
  @Local selectedSettleId: string = ''

  private columns: ColumnConfig[] = [
    { key: 'case_number', title: '病历号', width: 100 },
    { key: 'patient_name', title: '姓名', width: 80 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'doctor_name', title: '医生', width: 80 },
    { key: 'regist_level', title: '挂号级别', width: 80 },
    { key: 'status', title: '状态', width: 80 },
  ]

  aboutToAppear(): void {
    this.loadDropdowns()
    this.loadList()
  }

  private async loadDropdowns(): Promise<void> {
    try {
      const results = await Promise.all([
        RegistrationService.getRegistLevelList(),
        RegistrationService.getAllDeptList(),
        RegistrationService.getRegistDoctorList(),
        RegistrationService.getSettleCategory(),
        RegistrationService.getMaxCaseNumber(),
      ])
      const levels = results[0]
      const depts = results[1]
      const doctors = results[2]
      const settle = results[3]
      const caseNo = results[4]
      this.registLevels = levels.list || []
      this.departments = depts.list || []
      this.doctors = doctors.list || []
      this.settleCategories = settle.list || []
      if (caseNo.list && caseNo.list.length > 0) {
        this.caseNumber = getStringField(caseNo.list[0] as Object, 'case_number')
      }
    } catch (e) {
      promptAction.showToast({ message: '加载下拉选项失败', duration: 2000 })
    }
  }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const result = await RegistrationService.getAlreadyRegisterCount()
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount
      }
    } catch (e) {
      promptAction.showToast({ message: '加载挂号列表失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  private async onSubmit(): Promise<void> {
    if (!this.patientName || !this.selectedDeptId || !this.selectedDoctorId || !this.selectedLevelId) {
      promptAction.showToast({ message: '请填写必填项', duration: 2000 })
      return
    }
    this.formLoading = true
    try {
      const params: HttpParams = new HttpParams()
      params.add('patient_name', this.patientName)
      params.add('gender', this.gender)
      params.add('age', this.age)
      params.add('id_card', this.idCard)
      params.add('phone', this.phone)
      params.add('address', this.address)
      params.add('dept_id', this.selectedDeptId)
      params.add('doctor_id', this.selectedDoctorId)
      params.add('regist_level_id', this.selectedLevelId)
      params.add('settle_category_id', this.selectedSettleId)
      params.add('case_number', this.caseNumber)

      const result = await RegistrationService.addRegister(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '挂号成功', duration: 2000 })
        this.dialogVisible = false
        this.resetForm()
        this.loadList()
        this.loadDropdowns()
      }
    } catch (e) {
      promptAction.showToast({ message: '挂号提交失败', duration: 2000 })
    } finally {
      this.formLoading = false
    }
  }

  private resetForm(): void {
    this.patientName = ''
    this.gender = ''
    this.age = ''
    this.idCard = ''
    this.phone = ''
    this.address = ''
    this.selectedDeptId = ''
    this.selectedDoctorId = ''
    this.selectedLevelId = ''
    this.selectedSettleId = ''
  }

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
      opts.push({ label: this.registLevels[i].level_name, value: String(this.registLevels[i].id) })
    }
    return opts
  }

  private buildSettleOptions(): SelectOption[] {
    const opts: SelectOption[] = []
    for (let i = 0; i < this.settleCategories.length; i++) {
      const s: Object = this.settleCategories[i]
      const opt: SelectOption = {
        label: getStringField(s, 'name'),
        value: getStringField(s, 'id')
      }
      opts.push(opt)
    }
    return opts
  }

  build() {
    Stack() {
      Column() {
        PageHeader({ title: '窗口挂号' })
        DataTable({
          columns: this.columns,
          data: this.tableData,
          loading: this.loading,
          showIndex: true,
        })

        Button('新增挂号')
          .fontSize(14)
          .backgroundColor('#409EFF')
          .fontColor('#FFFFFF')
          .margin({ top: 12 })
          .onClick(() => this.dialogVisible = true)
      }
      .width('100%').height('100%')
      .padding(16).backgroundColor('#F0F2F5')

      // Registration form dialog
      if (this.dialogVisible) {
        Column()
          .width('100%').height('100%')
          .backgroundColor('rgba(0,0,0,0.4)')
          .onClick(() => this.dialogVisible = false)

        Column() {
          Text('新增挂号').fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 16 })

          Scroll() {
            Column() {
              this.formField('患者姓名', this.patientName, (v: string) => this.patientName = v)
              Row() {
                this.formField('性别', this.gender, (v: string) => this.gender = v, 100)
                this.formField('年龄', this.age, (v: string) => this.age = v, 80)
              }
              this.formField('身份证号', this.idCard, (v: string) => this.idCard = v)
              this.formField('电话', this.phone, (v: string) => this.phone = v)
              this.formField('地址', this.address, (v: string) => this.address = v)
              this.formField('病历号', this.caseNumber, (_v: string) => {}, 140, false)

              this.formPicker('科室', this.buildDeptOptions(),
                this.selectedDeptId, (v: string) => this.selectedDeptId = v)

              this.formPicker('医生', this.buildDoctorOptions(),
                this.selectedDoctorId, (v: string) => this.selectedDoctorId = v)

              this.formPicker('挂号级别', this.buildLevelOptions(),
                this.selectedLevelId, (v: string) => this.selectedLevelId = v)

              this.formPicker('结算类别', this.buildSettleOptions(),
                this.selectedSettleId, (v: string) => this.selectedSettleId = v)
            }
          }
          .layoutWeight(1)

          Row() {
            Button('取消')
              .backgroundColor('#F5F5F5').fontColor('#606266').layoutWeight(1)
              .onClick(() => this.dialogVisible = false)
            Blank().width(12)
            Button(this.formLoading ? '提交中...' : '提交')
              .backgroundColor('#409EFF').fontColor('#FFFFFF').layoutWeight(1)
              .enabled(!this.formLoading)
              .onClick(() => this.onSubmit())
          }.width('100%').margin({ top: 16 })
        }
        .width('90%').constraintSize({ maxHeight: '85%' }).padding(20)
        .backgroundColor('#FFFFFF').borderRadius(12)
      }
    }
    .width('100%').height('100%')
  }

  @Builder
  formField(label: string, value: string, onChange: (v: string) => void, w?: number, enabled: boolean = true) {
    Row() {
      Text(label).fontSize(14).fontColor('#606266').width(w || 80)
      TextInput({ text: value })
        .layoutWeight(1).height(36).fontSize(13)
        .enabled(enabled)
        .onChange(onChange)
    }.margin({ bottom: 10 })
  }

  @Builder
  formPicker(label: string, options: SelectOption[], selected: string, onChange: (v: string) => void) {
    Row() {
      Text(label).fontSize(14).fontColor('#606266').width(80)
      Select(options.map((o: SelectOption): SelectOption => ({ value: o.value, label: o.label }) as SelectOption))
        .layoutWeight(1).height(36)
        .selected(this.findOptionIndex(options, selected))
        .onSelect((index: number) => onChange(options[index].value))
    }.margin({ bottom: 10 })
  }

  private findOptionIndex(options: SelectOption[], selected: string): number {
    for (let i = 0; i < options.length; i++) {
      if (options[i].value === selected) {
        return i
      }
    }
    return 0
  }
}

export default OnsiteRegistrationPage
