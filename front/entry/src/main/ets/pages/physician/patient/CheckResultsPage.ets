import { PageHeader } from '../../../components/PageHeader'
import { PhysicianService } from '../../../services/PhysicianService'
import { ColumnConfig, DataTable } from '../../../components/DataTable'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct CheckResultsPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local registId: string = ''

  private columns: ColumnConfig[] = [
    { key: 'item_name', title: '检查项目', width: 120 },
    { key: 'result', title: '检查结果', width: 160 },
    { key: 'doctor_name', title: '检查医生', width: 80 },
    { key: 'status', title: '状态', width: 70 },
  ]

  aboutToAppear(): void {
    const cached: string | undefined = AppStorage.get<string>('currentRegistId')
    if (cached) { this.registId = cached }
  }

  private async loadResults(): Promise<void> {
    if (!this.registId) {
      promptAction.showToast({ message: '请输入挂号ID', duration: 2000 })
      return
    }
    this.loading = true
    try {
      const result = await PhysicianService.getCheckPatientTableByRegist(this.registId)
      if (result.list) {
        this.tableData = result.list as Object[]
      }
    } catch (_e) {
      promptAction.showToast({ message: '加载检查结果失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      PageHeader({ title: '检查结果查看' })
      Row() {
        TextInput({ placeholder: '输入挂号ID' })
          .layoutWeight(1).height(36).fontSize(13)
          .onChange((v: string) => this.registId = v)
        Button('查询').fontSize(13).backgroundColor('#409EFF').fontColor('#FFFFFF')
          .height(36).margin({ left: 8 })
          .onClick(() => this.loadResults())
      }
      .width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius(8).margin({ bottom: 12 })

      DataTable({ columns: this.columns, data: this.tableData, loading: this.loading })
    }
    .width('100%').height('100%')
    .padding(16).backgroundColor('#F0F2F5')
  }
}

export default CheckResultsPage
