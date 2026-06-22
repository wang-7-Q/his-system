import { HttpParams } from '../../../services/ApiClient'
import { PageHeader } from '../../../components/PageHeader'
import { PhysicianService } from '../../../services/PhysicianService'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct OutpatientDiagnosisPage {
  @Local registId: string = ''
  @Local diagnosis: string = ''
  @Local loading: boolean = false

  private async onSubmit(): Promise<void> {
    if (!this.registId || !this.diagnosis) {
      promptAction.showToast({ message: '请填写挂号ID和诊断结果', duration: 2000 })
      return
    }
    this.loading = true
    try {
      const params: HttpParams = new HttpParams()
      params.add('regist_id', this.registId)
      params.add('diagnosis', this.diagnosis)
      const result = await PhysicianService.outpatientDiagnosis(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '确诊提交成功', duration: 2000 })
      }
    } catch (_e) {
      promptAction.showToast({ message: '确诊提交失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      PageHeader({ title: '门诊确诊' })
      Column() {
        Text('挂号ID').fontSize(14).fontColor('#606266').margin({ bottom: 4 })
        TextInput({ placeholder: '输入挂号ID' })
          .width('100%').height(36).fontSize(13).margin({ bottom: 16 })
          .onChange((v: string) => this.registId = v)

        Text('诊断结果').fontSize(14).fontColor('#606266').margin({ bottom: 4 })
        TextArea({ placeholder: '诊断结果描述' })
          .width('100%').height(120).fontSize(13).margin({ bottom: 16 })
          .onChange((v: string) => this.diagnosis = v)

        Button(this.loading ? '提交中...' : '提交确诊').width('100%').height(40).fontSize(15)
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

export default OutpatientDiagnosisPage
