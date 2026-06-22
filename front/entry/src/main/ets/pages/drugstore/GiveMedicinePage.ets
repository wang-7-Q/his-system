import { HttpParams } from '../../services/ApiClient'
import { DrugstoreService } from '../../services/DrugstoreService'
import { ColumnConfig } from '../../components/DataTable'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct GiveMedicinePage {
  @Local tableData: Object[] = []
  @Local drugData: Object[] = []
  @Local loading: boolean = false
  @Local confirmVisible: boolean = false
  @Local selectedRow: Object | null = null

  private columns: ColumnConfig<Object>[] = [
    { key: 'patient_name', title: '患者姓名', width: 100 },
    { key: 'case_number', title: '病历号', width: 100 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'status', title: '状态', width: 70 },
  ]

  aboutToAppear(): void { this.loadList() }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const params: HttpParams = new HttpParams()
      const result = await DrugstoreService.getFinishPricePatient(params)
      if (result.list) { this.tableData = result.list as Object[] }
    } catch (_e) {
      promptAction.showToast({ message: '加载发药列表失败', duration: 2000 })
    } finally { this.loading = false }
  }

  private async loadDrugs(row: Object): Promise<void> {
    const registId: string = String((row as Record<string, Object>)['regist_id'] || '')
    try {
      const result = await DrugstoreService.getPricePatientDrug(registId)
      if (result.list) { this.drugData = result.list as Object[] }
    } catch (_e) { promptAction.showToast({ message: '加载药品失败', duration: 2000 }) }
  }

  private async doGive(): Promise<void> {
    if (!this.selectedRow) { return }
    const registId: string = String((this.selectedRow as Record<string, Object>)['regist_id'] || '')
    try {
      const params: HttpParams = new HttpParams()
      params.add('regist_id', registId)
      const result = await DrugstoreService.givePatientDrugs(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '发药成功', duration: 2000 })
        this.confirmVisible = false; this.loadList()
      }
    } catch (_e) { promptAction.showToast({ message: '发药失败', duration: 2000 }) }
  }

  build() {
    Column() {
      PageHeader({ title: '药房发药' })
      DataTable({
        columns: this.columns, data: this.tableData, loading: this.loading,
        actionColumn: (row: Object) => {
          Button('发药').fontSize(12).height(28).backgroundColor('#67C23A').fontColor('#FFFFFF')
            .onClick(() => { this.selectedRow = row; this.loadDrugs(row); this.confirmVisible = true })
        }
      })
    }
    .width('100%').height('100%').padding(16).backgroundColor('#F0F2F5')

    ConfirmDialog({
      visible: this.confirmVisible, title: '确认发药',
      message: '确定发放药品吗？共 ' + this.drugData.length + ' 种药品。',
      onConfirm: () => this.doGive(),
      onCancel: () => this.confirmVisible = false,
    })
  }
}

export default GiveMedicinePage
