import { HttpParams } from '../services/ApiClient'
import { Drug } from '../models/Drug'
import { PhysicianService } from '../services/PhysicianService'

@ComponentV2
export struct DrugSelector {
  @Param visible: boolean = false
  @Event onSelect: (drug: Drug) => void = (_drug: Drug) => {}
  @Event onCancel: () => void = () => {}
  @Local searchKey: string = ''
  @Local drugList: Drug[] = []
  @Local loading: boolean = false

  private async search(): Promise<void> {
    this.loading = true
    try {
      const params: HttpParams = new HttpParams()
      params.add('keyword', this.searchKey)
      const result = await PhysicianService.searchDrug(params)
      if (result.list) {
        this.drugList = result.list
      }
    } finally {
      this.loading = false
    }
  }

  build() {
    if (this.visible) {
      Stack() {
        Column()
          .width('100%').height('100%')
          .backgroundColor('rgba(0,0,0,0.4)')
          .onClick(() => this.onCancel())

        Column() {
          Text('选择药品').fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 12 })
          Row() {
            TextInput({ placeholder: '输入药品名称搜索' })
              .layoutWeight(1).height(36).fontSize(13)
              .onChange((value: string) => this.searchKey = value)
            Button('搜索').fontSize(13).backgroundColor('#409EFF').fontColor('#FFFFFF')
              .height(36).margin({ left: 8 })
              .onClick(() => this.search())
          }.margin({ bottom: 12 })

          if (this.loading) {
            LoadingProgress().width(40).height(40).margin(40)
          } else {
            List() {
              ForEach(this.drugList, (drug: Drug) => {
                ListItem() {
                  Row() {
                    Column() {
                      Text(drug.drug_name).fontSize(14).fontColor('#303133')
                      Text(drug.drug_format + ' | ' + drug.manufacturer).fontSize(12).fontColor('#909399')
                    }.layoutWeight(1)
                    Text('¥' + drug.unit_price).fontSize(14).fontColor('#F56C6C').margin({ right: 12 })
                    Text('库存: ' + drug.stock).fontSize(12).fontColor('#909399').margin({ right: 12 })
                    Button('选择').fontSize(12).backgroundColor('#67C23A').fontColor('#FFFFFF').height(28)
                      .onClick(() => this.onSelect(drug))
                  }.width('100%').padding(12)
                  .border({ width: { bottom: 1 }, color: '#EBEEF5' })
                }
              }, (drug: Drug) => drug.id.toString())
            }.layoutWeight(1)
          }
        }.width('90%').height('70%').padding(20).backgroundColor('#FFFFFF').borderRadius(12)
      }.width('100%').height('100%')
    }
  }
}
