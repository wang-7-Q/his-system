import { ConfirmDialog } from '../../components/ConfirmDialog'
import { PageHeader } from '../../components/PageHeader'
import { RegistrationService } from '../../services/RegistrationService'
import { PageInfo, PaginationBar } from '../../components/PaginationBar'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct RegistrationRecordPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Local confirmVisible: boolean = false
  @Local selectedRow: Object | null = null

  private columns: ColumnConfig<Object>[] = [
    { key: 'case_number', title: '病历号', width: 100 },
    { key: 'patient_name', title: '姓名', width: 80 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'doctor_name', title: '医生', width: 80 },
    { key: 'regist_level', title: '级别', width: 70 },
    { key: 'status', title: '状态', width: 70 },
  ]

  aboutToAppear(): void {
    this.loadList()
  }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const result = await RegistrationService.getRecordRefundPatient()
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount
      }
    } catch (_e) {
      promptAction.showToast({ message: '加载退号列表失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  private async doRefund(): Promise<void> {
    if (!this.selectedRow) {
      return
    }
    const registId: string = String((this.selectedRow as Record<string, Object>)['regist_id'] || '')
    try {
      const result = await RegistrationService.refundMedicalRecord(registId)
      if (result.status === 1) {
        promptAction.showToast({ message: '退号成功', duration: 2000 })
        this.confirmVisible = false
        this.selectedRow = null
        this.loadList()
      }
    } catch (_e) {
      promptAction.showToast({ message: '退号失败', duration: 2000 })
    }
  }

  @Builder
  actionButtons(row: Object) {
    Button('退号')
      .fontSize(12).height(28)
      .backgroundColor('#F56C6C').fontColor('#FFFFFF')
      .onClick(() => {
        this.selectedRow = row
        this.confirmVisible = true
      })
  }

  build() {
    Column() {
      PageHeader({ title: '窗口退号' })
      DataTable({
        columns: this.columns,
        data: this.tableData,
        loading: this.loading,
        actionColumn: (row: Object) => { this.actionButtons(row) }
      })
    }
    .width('100%').height('100%')
    .padding(16).backgroundColor('#F0F2F5')

    ConfirmDialog({
      visible: this.confirmVisible,
      title: '确认退号',
      message: '确定要退号吗？此操作不可撤销。',
      danger: true,
      onConfirm: () => this.doRefund(),
      onCancel: () => this.confirmVisible = false,
    })
  }
}

export default RegistrationRecordPage
