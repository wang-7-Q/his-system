import { hilog } from '@kit.PerformanceAnalysisKit'
import { HttpParams } from '../../../services/ApiClient'
import { PageHeader } from '../../../components/PageHeader'
import { PhysicianService } from '../../../services/PhysicianService'
import { getStringField } from '../../../utils/ObjectAccess'
import { promptAction } from '@kit.ArkUI'

const DOMAIN = 0x0000

interface PickerOption {
  label: string
  value: string
}

@ComponentV2
struct DisposalRequestPage {
  @Local registId: string = ''
  @Local items: Object[] = []
  @Local selectedItemId: string = ''
  @Local loading: boolean = false

  aboutToAppear(): void {
    this.loadItems()
  }

  private async loadItems(): Promise<void> {
    try {
      const params: HttpParams = new HttpParams()
      params.add('keyword', '')
      const result = await PhysicianService.getDisposal(params)
      if (result.list) {
        this.items = result.list as Object[]
      }
    } catch (e) {
      hilog.error(DOMAIN, 'DisposalRequest', 'Failed to load items: %{public}s', JSON.stringify(e))
    }
  }

  private async onSubmit(): Promise<void> {
    if (!this.registId || !this.selectedItemId) {
      promptAction.showToast({ message: '请填写挂号ID并选择处置项目', duration: 2000 })
      return
    }
    this.loading = true
    try {
      const params: HttpParams = new HttpParams()
      params.add('regist_id', this.registId)
      params.add('disposal_item_id', this.selectedItemId)
      const result = await PhysicianService.addDisposalRequest(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '处置申请提交成功', duration: 2000 })
      }
    } catch (_e) {
      promptAction.showToast({ message: '提交失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  private buildItemOptions(): PickerOption[] {
    const opts: PickerOption[] = []
    for (let i = 0; i < this.items.length; i++) {
      const it: Object = this.items[i]
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
      PageHeader({ title: '处置申请' })
      Column() {
        Text('挂号ID').fontSize(14).fontColor('#606266').margin({ bottom: 4 })
        TextInput({ placeholder: '输入挂号ID' })
          .width('100%').height(36).fontSize(13).margin({ bottom: 16 })
          .onChange((v: string) => this.registId = v)

        Text('选择处置项目').fontSize(14).fontColor('#606266').margin({ bottom: 4 })
        Select(this.buildItemOptions())
          .width('100%').height(36)
          .onSelect((index: number) => {
            if (index >= 0 && index < this.items.length) {
              this.selectedItemId = getStringField(this.items[index], 'id')
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

export default DisposalRequestPage
