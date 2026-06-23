import { RestBean } from '../../models/RestBean'
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
  @Local searchCaseNumber: string = ''
  @Local searchRealName: string = ''

  private columns: ColumnConfig[] = [
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
      const result: RestBean<Object> = await RegistrationService.getRecordRefundPatient(
        this.searchCaseNumber, this.searchRealName, this.pageInfo.page, this.pageInfo.size
      ) as Promise<RestBean<Object>>
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
    const keys: string[] = Object.keys(this.selectedRow)
    const values: Object[] = Object.values(this.selectedRow)
    let registId: string = ''
    for (let i = 0; i < keys.length; i++) {
      if (keys[i] === 'id') {
        registId = String(values[i] || '')
        break
      }
    }
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
    Stack() {
      Column() {
        PageHeader({ title: '窗口退号' })

        // 搜索区
        Row() {
          TextInput({ placeholder: '请输入病历号' })
            .value(this.searchCaseNumber)
            .onChange((v: string) => { this.searchCaseNumber = v })
            .fontSize(13)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 12 })

          TextInput({ placeholder: '请输入患者名' })
            .value(this.searchRealName)
            .onChange((v: string) => { this.searchRealName = v })
            .fontSize(13)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 12 })

          Button('搜索')
            .fontSize(13)
            .fontColor('#FFFFFF')
            .backgroundColor('#409EFF')
            .borderRadius(4)
            .height(36)
            .padding({ left: 16, right: 16 })
            .onClick(() => this.loadList())

          Button('重置')
            .fontSize(13)
            .backgroundColor('#F5F5F5')
            .fontColor('#606266')
            .borderRadius(4)
            .height(36)
            .padding({ left: 16, right: 16 })
            .margin({ left: 8 })
            .onClick(() => {
              this.searchCaseNumber = ''
              this.searchRealName = ''
              this.loadList()
            })
        }
        .width('100%')
        .margin({ bottom: 12 })

        DataTable({
          columns: this.columns,
          data: this.tableData,
          loading: this.loading,
          showActionColumn: true,
          actionColumn: (row: Object) => { this.actionButtons(row) }
        })
        .layoutWeight(1)

        PaginationBar({
          pageInfo: this.pageInfo,
          onChange: (_page: number, _size: number) => this.loadList()
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
    .width('100%').height('100%')
  }
}

export default RegistrationRecordPage
