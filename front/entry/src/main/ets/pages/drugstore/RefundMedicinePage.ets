import { HttpParams } from '../../services/ApiClient'
import { DrugstoreService } from '../../services/DrugstoreService'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { PageHeader } from '../../components/PageHeader'
import { ConfirmDialog } from '../../components/ConfirmDialog'
import { getStringField } from '../../utils/ObjectAccess'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct RefundMedicinePage {
  @Local tableData: Object[] = []
  @Local drugData: Object[] = []
  @Local loading: boolean = false
  @Local confirmVisible: boolean = false
  @Local selectedRow: Object | null = null

  private columns: ColumnConfig[] = [
    { key: 'patient_name', title: '患者姓名', width: 100 },
    { key: 'case_number', title: '病历号', width: 100 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'status', title: '状态', width: 70 },
  ]

  @Builder
  actionButtons(row: Object) {
    Button('退药').fontSize(12).height(28).backgroundColor('#F56C6C').fontColor('#FFFFFF')
      .onClick(() => { this.selectedRow = row; this.loadDrugs(row); this.confirmVisible = true })
  }

  aboutToAppear(): void { this.loadList() }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const params: HttpParams = new HttpParams()
      const result = await DrugstoreService.getGivePricePatient(params)
      if (result.list) { this.tableData = result.list as Object as Object[] }
    } catch (_e) { promptAction.showToast({ message: '加载退药列表失败', duration: 2000 }) }
    finally { this.loading = false }
  }

  private async loadDrugs(row: Object): Promise<void> {
    const registId: string = getStringField(row, 'regist_id')
    try {
      const result = await DrugstoreService.getGivePatientDrug(registId)
      if (result.list) { this.drugData = result.list as Object as Object[] }
    } catch (_e) { promptAction.showToast({ message: '加载药品失败', duration: 2000 }) }
  }

  private async doRefund(): Promise<void> {
    if (!this.selectedRow) { return }
    const registId: string = getStringField(this.selectedRow as Object, 'regist_id')
    try {
      const params: HttpParams = new HttpParams()
      params.add('regist_id', registId)
      const result = await DrugstoreService.refundPatientDrugs(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '退药成功', duration: 2000 })
        this.confirmVisible = false; this.loadList()
      }
    } catch (_e) { promptAction.showToast({ message: '退药失败', duration: 2000 }) }
  }

  build() {
    Stack() {
      Column() {
        PageHeader({ title: '药房退药' })
        DataTable({
          columns: this.columns, data: this.tableData, loading: this.loading,
          showActionColumn: true,
          actionColumn: (row: Object) => { this.actionButtons(row) }
        })
      }
      .width('100%').height('100%').padding(16).backgroundColor('#F0F2F5')

      ConfirmDialog({
        visible: this.confirmVisible, title: '确认退药', danger: true,
        message: '确定要退回所有药品吗？此操作不可撤销。',
        onConfirm: () => this.doRefund(),
        onCancel: () => this.confirmVisible = false,
      })
    }
    .width('100%').height('100%')
  }
}

export default RefundMedicinePage
