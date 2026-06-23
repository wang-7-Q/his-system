import { HttpParams } from '../../services/ApiClient'
import { InspectionService } from '../../services/InspectionService'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { getStringField } from '../../utils/ObjectAccess'
import { promptAction } from '@kit.ArkUI'
import { PageHeader } from '../../components/PageHeader'

@ComponentV2
struct InspectionPatientPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local dialogVisible: boolean = false
  @Local formLoading: boolean = false
  @Local recordId: string = ''
  @Local patientName: string = ''
  @Local inspectionItem: string = ''

  private columns: ColumnConfig[] = [
    { key: 'patient_name', title: '患者姓名', width: 100 },
    { key: 'item_name', title: '检验项目', width: 130 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'status', title: '状态', width: 70 },
  ]

  @Builder
  actionButtons(row: Object) {
    Button('录入').fontSize(12).height(28).backgroundColor('#409EFF').fontColor('#FFFFFF')
      .onClick(() => { this.recordId = getStringField(row, 'id'); this.dialogVisible = true })
  }

  aboutToAppear(): void { this.loadList() }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const result = await InspectionService.getInspectionPatient()
      if (result.list) { this.tableData = result.list as Object[] }
    } catch (_e) {
      promptAction.showToast({ message: '加载失败', duration: 2000 })
    } finally { this.loading = false }
  }

  private async onSubmit(): Promise<void> {
    if (!this.recordId || !this.patientName) {
      promptAction.showToast({ message: '请填写必填项', duration: 2000 })
      return
    }
    this.formLoading = true
    try {
      const params: HttpParams = new HttpParams()
      params.add('id', this.recordId)
      params.add('patient_name', this.patientName)
      params.add('inspection_item', this.inspectionItem)
      const result = await InspectionService.updateInspectionPatient(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '录入成功', duration: 2000 })
        this.dialogVisible = false; this.loadList()
      }
    } catch (_e) {
      promptAction.showToast({ message: '录入失败', duration: 2000 })
    } finally { this.formLoading = false }
  }

  build() {
    Column() {
      PageHeader({ title: '检验患者录入' })
      DataTable({
        columns: this.columns, data: this.tableData, loading: this.loading,
        showActionColumn: true,
        actionColumn: (row: Object) => { this.actionButtons(row) }
      })
      if (this.dialogVisible) {
        Stack() {
          Column().width('100%').height('100%').backgroundColor('rgba(0,0,0,0.4)').onClick(() => this.dialogVisible = false)
          Column() {
            Text('录入检验信息').fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 16 })
            Text('患者姓名').fontSize(14).margin({ bottom: 4 })
            TextInput({ text: this.patientName }).width('100%').height(36).margin({ bottom: 12 }).onChange((v) => this.patientName = v)
            Text('检验项目').fontSize(14).margin({ bottom: 4 })
            TextInput({ text: this.inspectionItem }).width('100%').height(36).margin({ bottom: 16 }).onChange((v) => this.inspectionItem = v)
            Row() {
              Button('取消').layoutWeight(1).backgroundColor('#F5F5F5').onClick(() => this.dialogVisible = false)
              Blank().width(12)
              Button(this.formLoading ? '提交中...' : '提交').layoutWeight(1).backgroundColor('#409EFF').fontColor('#FFFFFF').enabled(!this.formLoading).onClick(() => this.onSubmit())
            }.width('100%')
          }.width('85%').padding(20).backgroundColor('#FFFFFF').borderRadius(12)
        }.width('100%').height('100%')
      }
    }
    .width('100%').height('100%').padding(16).backgroundColor('#F0F2F5')
  }
}

export default InspectionPatientPage
