import { HttpParams } from '../../services/ApiClient'
import { CheckService } from '../../services/CheckService'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { promptAction } from '@kit.ArkUI'
import { PageHeader } from '../../components/PageHeader'

@ComponentV2
struct CheckInputPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local registId: string = ''
  @Local resultInput: string = ''
  @Local editingRow: Object | null = null

  private columns: ColumnConfig[] = [
    { key: 'patient_name', title: '患者姓名', width: 100 },
    { key: 'item_name', title: '检查项目', width: 130 },
    { key: 'status', title: '状态', width: 70 },
  ]

  aboutToAppear(): void {
    this.loadList()
  }

  private async loadList(): Promise<void> {
    this.loading = true
    try {
      const params: HttpParams = new HttpParams()
      const result = await CheckService.getFinishCheck(params)
      if (result.list) {
        this.tableData = result.list as Object[]
      }
    } catch (_e) {
      promptAction.showToast({ message: '加载失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  private async submitResult(): Promise<void> {
    const row = this.editingRow
    if (row === null) {
      return
    }
    if (!this.resultInput) {
      promptAction.showToast({ message: '请输入检查结果', duration: 2000 })
      return
    }
    try {
      const registId: string = String((row as Record<string, Object>)['regist_id'] || '')
      const params: HttpParams = new HttpParams()
      params.add('regist_id', registId)
      params.add('check_result', this.resultInput)
      const result = await CheckService.updateCheckInput(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '结果录入成功', duration: 2000 })
        this.resultInput = ''
        this.editingRow = null
        this.loadList()
      }
    } catch (_e) {
      promptAction.showToast({ message: '录入失败', duration: 2000 })
    }
  }

  @Builder
  resultInputBar() {
    if (this.editingRow !== null) {
      Row() {
        TextInput({ placeholder: '请输入检查结果', text: this.resultInput })
          .onChange((value: string) => { this.resultInput = value })
          .layoutWeight(1)
          .height(36)
          .fontSize(14)
        Button('确认录入').fontSize(13).height(36)
          .backgroundColor('#67C23A').fontColor('#FFFFFF')
          .onClick(() => { this.submitResult() })
        Button('取消').fontSize(13).height(36)
          .backgroundColor('#909399').fontColor('#FFFFFF')
          .margin({ left: 8 })
          .onClick(() => { this.editingRow = null; this.resultInput = '' })
      }
      .width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius(8)
      .margin({ bottom: 12 })
    }
  }

  @Builder
  actionButtons(row: Object) {
    Button('录入结果').fontSize(12).height(28)
      .backgroundColor('#67C23A').fontColor('#FFFFFF')
      .onClick(() => {
        this.editingRow = row
        this.resultInput = ''
      })
  }

  build() {
    Column() {
      PageHeader({ title: '检查结果录入' })
      this.resultInputBar()
      DataTable({
        columns: this.columns,
        data: this.tableData,
        loading: this.loading,
        showActionColumn: true,
        actionColumn: (row: Object) => { this.actionButtons(row) }
      })
    }
    .width('100%').height('100%')
    .padding(16).backgroundColor('#F0F2F5')
  }
}

export default CheckInputPage
