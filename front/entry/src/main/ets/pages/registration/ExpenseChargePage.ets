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
  @Local chargeDialogVisible: boolean = false

  private columns: ColumnConfig[] = [
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
    if (this.selectedRow === null) {
      return
    }
    if (!this.amountInput) {
      promptAction.showToast({ message: '请输入收费金额', duration: 2000 })
      return
    }
    try {
      const registId: string = String((this.selectedRow as Record<string, Object>)['regist_id'] || '')
      const params: HttpParams = new HttpParams()
      params.add('regist_id', registId)
      params.add('amount', this.amountInput)

      const result = await RegistrationService.expenseCharge(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '收费成功', duration: 2000 })
        this.chargeDialogVisible = false
        this.selectedRow = null
        this.amountInput = ''
        this.loadList()
      }
    } catch (_e) {
      promptAction.showToast({ message: '收费失败', duration: 2000 })
    }
  }

  @Builder
  chargeDialog() {
    if (this.chargeDialogVisible && this.selectedRow !== null) {
      Stack() {
        Column() {
          Text('收费').fontSize(16).fontWeight(FontWeight.Bold).margin({ bottom: 16 })
          Row() {
            Text('患者：').fontSize(14).fontColor('#606266')
            Text(String((this.selectedRow as Record<string, Object>)['patient_name'] || '')).fontSize(14)
          }
          .width('100%').margin({ bottom: 8 })
          Row() {
            Text('病历号：').fontSize(14).fontColor('#606266')
            Text(String((this.selectedRow as Record<string, Object>)['case_number'] || '')).fontSize(14)
          }
          .width('100%').margin({ bottom: 16 })
          TextInput({ placeholder: '请输入收费金额', text: this.amountInput })
            .onChange((value: string) => { this.amountInput = value })
            .type(InputType.Number)
            .width('100%').height(40).fontSize(14)
            .margin({ bottom: 16 })
          Row() {
            Button('取消').fontSize(14).height(36)
              .backgroundColor('#909399').fontColor('#FFFFFF')
              .layoutWeight(1).margin({ right: 8 })
              .onClick(() => { this.chargeDialogVisible = false; this.selectedRow = null; this.amountInput = '' })
            Button('确认收费').fontSize(14).height(36)
              .backgroundColor('#409EFF').fontColor('#FFFFFF')
              .layoutWeight(1)
              .onClick(() => { this.doCharge() })
          }
          .width('100%')
        }
        .width('80%').padding(20).backgroundColor('#FFFFFF').borderRadius(12)
        .shadow({ radius: 16, color: '#00000020' })
      }
      .width('100%').height('100%')
      .backgroundColor('#00000050')
      .position({ x: 0, y: 0 })
    }
  }

  @Builder
  actionButtons(row: Object) {
    Button('收费').fontSize(12).height(28)
      .backgroundColor('#67C23A').fontColor('#FFFFFF')
      .onClick(() => {
        this.selectedRow = row
        this.amountInput = ''
        this.chargeDialogVisible = true
      })
  }

  build() {
    Stack() {
      Column() {
        PageHeader({ title: '收费' })
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
      this.chargeDialog()
    }
    .width('100%').height('100%')
  }
}

export default ExpenseChargePage
