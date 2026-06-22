import { HttpParams } from '../../services/ApiClient'
import { DisposalService } from '../../services/DisposalService'
import { ColumnConfig } from '../../components/DataTable'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct DisposalInputPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local resultInput: string = ''

  private columns: ColumnConfig<Object>[] = [
    { key: 'patient_name', title: '患者姓名', width: 100 },
    { key: 'item_name', title: '处置项目', width: 130 },
    { key: 'status', title: '状态', width: 70 },
  ]

  aboutToAppear(): void { this.loadList() }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const params: HttpParams = new HttpParams()
      const result = await DisposalService.getFinishDisposal(params)
      if (result.list) { this.tableData = result.list as Object[] }
    } catch (_e) { promptAction.showToast({ message: '加载失败', duration: 2000 }) }
    finally { this.loading = false }
  }

  private async submitResult(row: Object): Promise<void> {
    if (!this.resultInput) { promptAction.showToast({ message: '请输入处置结果', duration: 2000 }); return }
    try {
      const params: HttpParams = new HttpParams()
      params.add('regist_id', String((row as Record<string, Object>)['regist_id'] || ''))
      params.add('disposal_result', this.resultInput)
      const result = await DisposalService.updateDisposalInput(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '结果录入成功', duration: 2000 }); this.resultInput = ''; this.loadList()
      }
    } catch (_e) { promptAction.showToast({ message: '录入失败', duration: 2000 }) }
  }

  build() {
    Column() {
      PageHeader({ title: '处置结果录入' })
      DataTable({
        columns: this.columns, data: this.tableData, loading: this.loading,
        actionColumn: (row: Object) => {
          Button('录入结果').fontSize(12).height(28).backgroundColor('#67C23A').fontColor('#FFFFFF')
            .onClick(() => { this.resultInput = ''; this.submitResult(row) })
        }
      })
    }
    .width('100%').height('100%').padding(16).backgroundColor('#F0F2F5')
  }
}

export default DisposalInputPage
