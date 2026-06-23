import { HttpParams } from '../../services/ApiClient'
import { ConfirmDialog } from '../../components/ConfirmDialog'
import { PageHeader } from '../../components/PageHeader'
import { RegistrationService } from '../../services/RegistrationService'
import { PageInfo, PaginationBar } from '../../components/PaginationBar'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { getStringField } from '../../utils/ObjectAccess'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct ExpenseRefundPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Local confirmVisible: boolean = false
  @Local selectedRow: Object | null = null

  private columns: ColumnConfig[] = [
    { key: 'case_number', title: '病历号', width: 100 },
    { key: 'patient_name', title: '姓名', width: 80 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'status', title: '状态', width: 70 },
  ]

  aboutToAppear(): void {
    this.loadList()
  }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const result = await RegistrationService.searchExpenseRefundPatient()
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount
      }
    } catch (_e) {
      promptAction.showToast({ message: '加载退费列表失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  private async doRefund(): Promise<void> {
    if (!this.selectedRow) {
      return
    }
    const registId: string = getStringField(this.selectedRow as Object, 'regist_id')
    try {
      const params: HttpParams = new HttpParams()
      params.add('regist_id', registId)
      const result = await RegistrationService.expenseRefund(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '退费成功', duration: 2000 })
        this.confirmVisible = false
        this.selectedRow = null
        this.loadList()
      }
    } catch (_e) {
      promptAction.showToast({ message: '退费失败', duration: 2000 })
    }
  }

  @Builder
  actionButtons(row: Object) {
    Button('退费').fontSize(12).height(28)
      .backgroundColor('#F56C6C').fontColor('#FFFFFF')
      .onClick(() => {
        this.selectedRow = row
        this.confirmVisible = true
      })
  }

  build() {
    Stack() {
      Column() {
        PageHeader({ title: '退费' })
        DataTable({
          columns: this.columns,
          data: this.tableData,
          loading: this.loading,
          showActionColumn: true,
          actionColumn: (row: Object) => { this.actionButtons(row) }
        })
        PaginationBar({
          pageInfo: this.pageInfo,
          onChange: (_page: number, _size: number) => this.loadList()
        })
      }
      .width('100%').height('100%')
      .padding(16).backgroundColor('#F0F2F5')

      ConfirmDialog({
        visible: this.confirmVisible,
        title: '确认退费',
        message: '确定要退费吗？',
        danger: true,
        onConfirm: () => this.doRefund(),
        onCancel: () => this.confirmVisible = false,
      })
    }
    .width('100%').height('100%')
  }
}

export default ExpenseRefundPage
