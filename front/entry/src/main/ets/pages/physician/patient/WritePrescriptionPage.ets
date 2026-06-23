import { HttpParams } from '../../../services/ApiClient'
import { PageHeader } from '../../../components/PageHeader'
import { PhysicianService } from '../../../services/PhysicianService'
import { DrugSelector } from '../../../components/DrugSelector'
import { Drug, PrescriptionDrug } from '../../../models/Drug'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct WritePrescriptionPage {
  @Local registId: string = ''
  @Local selectedDrugs: PrescriptionDrug[] = []
  @Local drugSelectorVisible: boolean = false
  @Local loading: boolean = false

  private onDrugSelected(drug: Drug): void {
    const pd: PrescriptionDrug = {
      drug_id: drug.id,
      drug_name: drug.drug_name,
      quantity: 1,
      usage_method: '口服',
      dosage: drug.drug_format,
      frequency: 'tid',
      days: 3,
    }
    const updated: PrescriptionDrug[] = [...this.selectedDrugs, pd]
    this.selectedDrugs = updated
    this.drugSelectorVisible = false
  }

  private async onSubmit(): Promise<void> {
    if (!this.registId || this.selectedDrugs.length === 0) {
      promptAction.showToast({ message: '请填写挂号ID并至少添加一种药品', duration: 2000 })
      return
    }
    this.loading = true
    try {
      for (let i = 0; i < this.selectedDrugs.length; i++) {
        const drug: PrescriptionDrug = this.selectedDrugs[i]
        const params: HttpParams = new HttpParams()
        params.add('regist_id', this.registId)
        params.add('drug_id', drug.drug_id.toString())
        params.add('drug_name', drug.drug_name)
        params.add('quantity', drug.quantity.toString())
        params.add('usage_method', drug.usage_method)
        params.add('dosage', drug.dosage)
        params.add('frequency', drug.frequency)
        params.add('days', drug.days.toString())
        await PhysicianService.addPrescription(params)
      }
      promptAction.showToast({ message: '处方提交成功', duration: 2000 })
      this.selectedDrugs = []
    } catch (_e) {
      promptAction.showToast({ message: '处方提交失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  build() {
    Stack() {
      Column() {
        PageHeader({ title: '开设处方' })

        Column() {
          Text('挂号ID').fontSize(14).fontColor('#606266').margin({ bottom: 4 })
          TextInput({ placeholder: '输入挂号ID' })
            .width('100%').height(36).fontSize(13).margin({ bottom: 16 })
            .onChange((v: string) => this.registId = v)

          Row() {
            Text('处方药品').fontSize(14).fontColor('#303133').layoutWeight(1)
            Button('+ 添加药品').fontSize(13).backgroundColor('#67C23A').fontColor('#FFFFFF').height(32)
              .onClick(() => this.drugSelectorVisible = true)
          }.margin({ bottom: 8 })

          List() {
            ForEach(this.selectedDrugs, (drug: PrescriptionDrug, index: number) => {
              ListItem() {
                Row() {
                  Text(drug.drug_name).fontSize(13).layoutWeight(1)
                  Text('x' + drug.quantity).fontSize(13).margin({ right: 8 })
                  Text(drug.usage_method).fontSize(13).margin({ right: 8 })
                  Button('删除').fontSize(11).height(24).backgroundColor('#F56C6C').fontColor('#FFFFFF')
                    .onClick(() => {
                      const updated: PrescriptionDrug[] = [...this.selectedDrugs]
                      updated.splice(index, 1)
                      this.selectedDrugs = updated
                    })
                }.width('100%').padding(8)
                .border({ width: { bottom: 1 }, color: '#EBEEF5' })
              }
            }, (_drug: PrescriptionDrug, index: number) => String(index))
          }
          .backgroundColor('#FAFAFA').borderRadius(4).constraintSize({ maxHeight: 200 }).margin({ bottom: 16 })

          Button(this.loading ? '提交中...' : '提交处方')
            .width('100%').height(40).fontSize(15)
            .backgroundColor('#409EFF').fontColor('#FFFFFF')
            .enabled(!this.loading)
            .onClick(() => this.onSubmit())
        }
        .padding(16).backgroundColor('#FFFFFF').borderRadius(8)
      }
      .width('100%').height('100%')
      .padding(16).backgroundColor('#F0F2F5')

      DrugSelector({
        visible: this.drugSelectorVisible,
        onSelect: (drug: Drug) => this.onDrugSelected(drug),
        onCancel: () => this.drugSelectorVisible = false,
      })
    }
    .width('100%').height('100%')
  }
}

export default WritePrescriptionPage
