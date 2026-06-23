import { PageHeader } from '../../../components/PageHeader'
import { PhysicianService } from '../../../services/PhysicianService'
import { ColumnConfig, DataTable } from '../../../components/DataTable'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct ExpenseQueryPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local registId: string = ''

  private columns: ColumnConfig[] = [
    { key: 'item_name', title: '项目名称', width: 130 },
    { key: 'item_type', title: '类型', width: 70 },
    { key: 'price', title: '金额', width: 70 },
    { key: 'status', title: '状态', width: 70 },
  ]

  private async query(): Promise<void> {
    if (!this.registId) {
      promptAction.showToast({ message: '请输入挂号ID', duration: 2000 })
      return
    }
    this.loading = true
    try {
      const result = await PhysicianService.getPatientItemByPhysician(this.registId)
      if (result.list) {
        this.tableData = result.list as Object[]
      } else {
        this.tableData = []
      }
    } catch (_e) {
      promptAction.showToast({ message: '查询失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      PageHeader({ title: '费用查询' })
      Row() {
        TextInput({ placeholder: '输入挂号ID' })
          .layoutWeight(1).height(36).fontSize(13)
          .onChange((v: string) => this.registId = v)
        Button('查询').fontSize(13).backgroundColor('#409EFF').fontColor('#FFFFFF')
          .height(36).margin({ left: 8 })
          .onClick(() => this.query())
      }
      .width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius(8).margin({ bottom: 12 })

      DataTable({ columns: this.columns, data: this.tableData, loading: this.loading })
    }
    .width('100%').height('100%')
    .padding(16).backgroundColor('#F0F2F5')
  }
}

export default ExpenseQueryPage
