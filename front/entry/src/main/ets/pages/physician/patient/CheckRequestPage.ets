import { hilog } from '@kit.PerformanceAnalysisKit'
import { HttpParams } from '../../../services/ApiClient'
import { PageHeader } from '../../../components/PageHeader'
import { PhysicianService } from '../../../services/PhysicianService'
import { ColumnConfig, DataTable } from '../../../components/DataTable'
import { getStringField } from '../../../utils/ObjectAccess'
import { promptAction } from '@kit.ArkUI'

const DOMAIN = 0x0000

interface PickerOption {
  label: string
  value: string
}

@ComponentV2
struct CheckRequestPage {
  @Local registId: string = ''
  @Local checkItems: Object[] = []
  @Local checkList: Object[] = []
  @Local loading: boolean = false
  @Local dialogVisible: boolean = false
  @Local selectedItemId: string = ''

  aboutToAppear(): void {
    this.loadCheckItems()
  }

  private async loadCheckItems(): Promise<void> {
    try {
      const params: HttpParams = new HttpParams()
      params.add('keyword', '')
      const result = await PhysicianService.getCheck(params)
      if (result.list) {
        this.checkItems = result.list as Object[]
      }
    } catch (e) {
      hilog.error(DOMAIN, 'CheckRequest', 'Failed to load items: %{public}s', JSON.stringify(e))
    }
  }

  private async onSubmit(): Promise<void> {
    if (!this.registId || !this.selectedItemId) {
      promptAction.showToast({ message: '请填写挂号ID并选择检查项目', duration: 2000 })
      return
    }
    this.loading = true
    try {
      const params: HttpParams = new HttpParams()
      params.add('regist_id', this.registId)
      params.add('check_item_id', this.selectedItemId)
      const result = await PhysicianService.addCheckRequest(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '检查申请提交成功', duration: 2000 })
        this.dialogVisible = false
      }
    } catch (_e) {
      promptAction.showToast({ message: '提交失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  private buildItemOptions(): PickerOption[] {
    const opts: PickerOption[] = []
    for (let i = 0; i < this.checkItems.length; i++) {
      const it: Object = this.checkItems[i]
      const opt: PickerOption = {
        value: getStringField(it, 'id'),
        label: getStringField(it, 'item_name')
      }
      opts.push(opt)
    }
    return opts
  }

  build() {
    Column() {
      PageHeader({ title: '检查申请' })
      Column() {
        Text('挂号ID').fontSize(14).fontColor('#606266').margin({ bottom: 4 })
        TextInput({ placeholder: '输入挂号ID' })
          .width('100%').height(36).fontSize(13).margin({ bottom: 16 })
          .onChange((v: string) => this.registId = v)

        Text('选择检查项目').fontSize(14).fontColor('#606266').margin({ bottom: 4 })
        Select(this.buildItemOptions())
          .width('100%').height(36)
          .onSelect((index: number) => {
            if (index >= 0 && index < this.checkItems.length) {
              this.selectedItemId = getStringField(this.checkItems[index], 'id')
            }
          })

        Button(this.loading ? '提交中...' : '提交申请')
          .width('100%').height(40).fontSize(15).margin({ top: 24 })
          .backgroundColor('#409EFF').fontColor('#FFFFFF')
          .enabled(!this.loading)
          .onClick(() => this.onSubmit())
      }
      .padding(16).backgroundColor('#FFFFFF').borderRadius(8)
    }
    .width('100%').height('100%')
    .padding(16).backgroundColor('#F0F2F5')
  }
}

export default CheckRequestPage
