import { HttpParams } from '../../../services/ApiClient'
import { PageHeader } from '../../../components/PageHeader'
import { PhysicianService } from '../../../services/PhysicianService'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct HomeMedicalRecordPage {
  @Local registId: string = ''
  @Local chiefComplaint: string = ''
  @Local presentIllness: string = ''
  @Local pastHistory: string = ''
  @Local physicalExam: string = ''
  @Local loading: boolean = false
  @Local diseaseData: Object[] = []

  aboutToAppear(): void {
    this.loadDiseases()
  }

  private async loadDiseases(): Promise<void> {
    try {
      const params: HttpParams = new HttpParams()
      params.add('keyword', '')
      const result = await PhysicianService.getDisease(params)
      if (result.list) {
        this.diseaseData = result.list as Object[]
      }
    } catch (_e) { /* optional */ }
  }

  private async onSubmit(): Promise<void> {
    if (!this.registId) {
      promptAction.showToast({ message: '请输入挂号ID', duration: 2000 })
      return
    }
    this.loading = true
    try {
      const params: HttpParams = new HttpParams()
      params.add('regist_id', this.registId)
      params.add('chief_complaint', this.chiefComplaint)
      params.add('present_illness', this.presentIllness)
      params.add('past_history', this.pastHistory)
      params.add('physical_exam', this.physicalExam)

      const result = await PhysicianService.addHomeMedicalRecord(params)
      if (result.status === 1) {
        promptAction.showToast({ message: '病历保存成功', duration: 2000 })
      }
    } catch (_e) {
      promptAction.showToast({ message: '保存失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      PageHeader({ title: '病历首页' })
      Scroll() {
        Column() {
          Text('挂号ID').fontSize(14).fontColor('#606266').margin({ bottom: 4 })
          TextInput({ placeholder: '输入挂号ID' })
            .width('100%').height(36).fontSize(13).margin({ bottom: 12 })
            .onChange((v: string) => this.registId = v)

          Text('主诉').fontSize(14).fontColor('#606266').margin({ bottom: 4 })
          TextInput({ placeholder: '患者主诉' })
            .width('100%').height(36).fontSize(13).margin({ bottom: 12 })
            .onChange((v: string) => this.chiefComplaint = v)

          Text('现病史').fontSize(14).fontColor('#606266').margin({ bottom: 4 })
          TextArea({ placeholder: '现病史描述' })
            .width('100%').height(80).fontSize(13).margin({ bottom: 12 })
            .onChange((v: string) => this.presentIllness = v)

          Text('既往史').fontSize(14).fontColor('#606266').margin({ bottom: 4 })
          TextArea({ placeholder: '既往病史' })
            .width('100%').height(80).fontSize(13).margin({ bottom: 12 })
            .onChange((v: string) => this.pastHistory = v)

          Text('体格检查').fontSize(14).fontColor('#606266').margin({ bottom: 4 })
          TextArea({ placeholder: '体格检查结果' })
            .width('100%').height(80).fontSize(13).margin({ bottom: 16 })
            .onChange((v: string) => this.physicalExam = v)

          Button(this.loading ? '保存中...' : '保存病历')
            .width('100%').height(40).fontSize(15)
            .backgroundColor('#409EFF').fontColor('#FFFFFF')
            .enabled(!this.loading)
            .onClick(() => this.onSubmit())
        }
        .padding(16).backgroundColor('#FFFFFF').borderRadius(8)
      }
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .padding(16).backgroundColor('#F0F2F5')
  }
}

export default HomeMedicalRecordPage
