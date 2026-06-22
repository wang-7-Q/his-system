import { PageHeader } from '../../components/PageHeader'
import { PhysicianService } from '../../services/PhysicianService'
import { PageInfo, PaginationBar } from '../../components/PaginationBar'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct PhysicianPatientPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Local waitCount: number = 0
  @Local finishCount: number = 0

  private columns: ColumnConfig<Object>[] = [
    { key: 'case_number', title: '病历号', width: 100 },
    { key: 'patient_name', title: '姓名', width: 80 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'doctor_name', title: '医生', width: 80 },
    { key: 'status', title: '状态', width: 70 },
  ]

  aboutToAppear(): void {
    this.loadCounts()
    this.loadList()
  }

  private async loadCounts(): Promise<void> {
    try {
      const [wait, finish] = await Promise.all([
        PhysicianService.getWaitPatientCount(),
        PhysicianService.getFinishPatientCount(),
      ])
      if (wait.list && wait.list.length > 0) {
        this.waitCount = Number((wait.list[0] as Record<string, Object>)['count'] || 0)
      }
      if (finish.list && finish.list.length > 0) {
        this.finishCount = Number((finish.list[0] as Record<string, Object>)['count'] || 0)
      }
    } catch (_e) { /* counts are optional */ }
  }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const result = await PhysicianService.getWaitPatient()
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount
      }
    } catch (_e) {
      promptAction.showToast({ message: '加载患者列表失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  private async treatPatient(row: Object): Promise<void> {
    const registId: string = String((row as Record<string, Object>)['regist_id'] || '')
    try {
      const result = await PhysicianService.treatPatient(registId)
      if (result.status === 1) {
        promptAction.showToast({ message: '开始看诊', duration: 2000 })
      }
    } catch (_e) {
      promptAction.showToast({ message: '看诊操作失败', duration: 2000 })
    }
  }

  @Builder
  actionButtons(row: Object) {
    Button('看诊').fontSize(12).height(28)
      .backgroundColor('#409EFF').fontColor('#FFFFFF')
      .onClick(() => this.treatPatient(row))
  }

  build() {
    Column() {
      PageHeader({ title: '患者查看' })
      Row() {
        Text('待诊: ' + this.waitCount).fontSize(13).fontColor('#409EFF').margin({ right: 20 })
        Text('已诊: ' + this.finishCount).fontSize(13).fontColor('#67C23A')
        Blank()
      }.width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius(8).margin({ bottom: 12 })

      DataTable({
        columns: this.columns,
        data: this.tableData,
        loading: this.loading,
        actionColumn: (row: Object) => { this.actionButtons(row) }
      })
    }
    .width('100%').height('100%')
    .padding(16).backgroundColor('#F0F2F5')
  }
}

export default PhysicianPatientPage
