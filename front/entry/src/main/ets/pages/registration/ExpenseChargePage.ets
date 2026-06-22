import { HttpParams } from '../../services/ApiClient'
import { PageHeader } from '../../components/PageHeader'
import { RegistrationService } from '../../services/RegistrationService'
import { PageInfo, PaginationBar } from '../../components/PaginationBar'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct ExpenseChargePage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Local selectedRow: Object | null = null
  @Local amountInput: string = ''

  private columns: ColumnConfig<Object>[] = [
    { key: 'case_number', title: '病历号', width: 100 },
    { key: 'patient_name', title: '姓名', width: 80 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'doctor_name', title: '医生', width: 80 },
    { key: 'status', title: '状态', width: 70 },
  ]

  aboutToAppear(): void {
    this.loadList()
  }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const result = await RegistrationService.searchExpenseChargePatient()
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount
      }
    } catch (_e) {
      promptAction.showToast({ message: '加载收费列表失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  private async doCharge(): Promise<void> {
    if (!this.selectedRow) {
      return
    }
    const registId: string = String((this.selectedRow as Record<string, Object>)['regist_id'] || '')
    try {
      const params: HttpParams = new HttpParams()
      params.add('regist_id', registId)
      params.add('amount', this.amountInput)

      const result = await RegistrationService.expenseCharge(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '收费成功', duration: 2000 })
        this.selectedRow = null
        this.amountInput = ''
        this.loadList()
      }
    } catch (_e) {
      promptAction.showToast({ message: '收费失败', duration: 2000 })
    }
  }

  @Builder
  actionButtons(row: Object) {
    Button('收费').fontSize(12).height(28)
      .backgroundColor('#67C23A').fontColor('#FFFFFF')
      .onClick(() => this.selectedRow = row)
  }

  build() {
    Column() {
      PageHeader({ title: '收费' })
      DataTable({
        columns: this.columns,
        data: this.tableData,
        loading: this.loading,
        actionColumn: (row: Object) => { this.actionButtons(row) }
      })
      PaginationBar({
        pageInfo: this.pageInfo,
        onChange: (_page: number, _size: number) => this.loadList()
      })
    }
    .width('100%').height('100%')
    .padding(16).backgroundColor('#F0F2F5')
  }
}

export default ExpenseChargePage
