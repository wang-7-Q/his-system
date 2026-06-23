import { hilog } from '@kit.PerformanceAnalysisKit'
import { CheckService } from '../../services/CheckService'
import { PageHeader } from '../../components/PageHeader'
import { PageInfo, PaginationBar } from '../../components/PaginationBar'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { getNumberField } from '../../utils/ObjectAccess'
import { promptAction } from '@kit.ArkUI'

const DOMAIN = 0x0000

@ComponentV2
struct CheckApplyPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Local waitCount: number = 0
  @Local finishCount: number = 0

  private columns: ColumnConfig[] = [
    { key: 'patient_name', title: '患者姓名', width: 100 },
    { key: 'item_name', title: '检查项目', width: 130 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'status', title: '状态', width: 70 },
  ]

  aboutToAppear(): void {
    this.loadCounts()
    this.loadList()
  }

  private async loadCounts(): Promise<void> {
    try {
      const results = await Promise.all([
        CheckService.getWaitCheckCount(),
        CheckService.getFinishCheckCount(),
      ])
      const wait = results[0]
      const finish = results[1]
      if (wait.list && wait.list.length > 0) {
        this.waitCount = getNumberField(wait.list[0] as Object, 'count')
      }
      if (finish.list && finish.list.length > 0) {
        this.finishCount = getNumberField(finish.list[0] as Object, 'count')
      }
    } catch (e) {
      hilog.error(DOMAIN, 'CheckApply', 'Failed to load counts: %{public}s', JSON.stringify(e))
    }
  }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const result = await CheckService.getWaitCheck()
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount
      }
    } catch (_e) {
      promptAction.showToast({ message: '加载检查申请列表失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      PageHeader({ title: '检查申请' })
      Row() {
        Text('待检查: ' + this.waitCount).fontSize(13).fontColor('#E6A23C').margin({ right: 20 })
        Text('已完成: ' + this.finishCount).fontSize(13).fontColor('#67C23A')
        Blank()
      }.width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius(8).margin({ bottom: 12 })

      DataTable({ columns: this.columns, data: this.tableData, loading: this.loading })
      PaginationBar({ pageInfo: this.pageInfo, onChange: (_p, _s) => this.loadList() })
    }
    .width('100%').height('100%')
    .padding(16).backgroundColor('#F0F2F5')
  }
}

export default CheckApplyPage
