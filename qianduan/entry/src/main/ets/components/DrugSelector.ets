/**
 * @file 药品选择器弹窗组件
 * 搜索药品并选择，显示名称/规格/厂家/单价/库存
 */

import ApiClient from '../services/ApiClient'
import { Drug } from '../models/Drug'

const PORT_DRUG: number = 8091

@ComponentV2
export struct DrugSelector {
  @Param visible: boolean = false
  @Event onSelect: (drug: Drug) => void = (drug: Drug) => {}
  @Event onCancel: () => void = () => {}

  @Local searchKeyword: string = ''
  @Local drugList: Drug[] = []
  @Local loading: boolean = false

  /**
   * 搜索药品
   */
  async searchDrugs(): Promise<void> {
    if (this.searchKeyword.trim() === '') {
      return
    }
    this.loading = true
    try {
      const data = await ApiClient.getInstance().get<{ list: Drug[] }>(
        PORT_DRUG,
        '/getDrugInfo',
        { drug_name: this.searchKeyword }
      )
      this.drugList = data.list ?? []
    } catch {
      this.drugList = []
    }
    this.loading = false
  }

  build() {
    Stack() {
      if (this.visible) {
        // 遮罩
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#66000000')
          .onClick(() => {
            this.onCancel()
          })

        // 弹窗内容
        Column() {
          // 标题
          Text('选择药品')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
            .margin({ bottom: 12 })

          // 搜索输入
          Row() {
            TextInput({ placeholder: '输入药品名称搜索' })
              .value(this.searchKeyword)
              .onChange((val: string) => {
                this.searchKeyword = val
              })
              .fontSize(13)
              .height(36)
              .layoutWeight(1)

            Button('搜索')
              .fontSize(13)
              .fontColor(Color.White)
              .backgroundColor('#20A0FF')
              .borderRadius(4)
              .height(36)
              .padding({ left: 12, right: 12 })
              .margin({ left: 8 })
              .onClick(() => {
                this.searchDrugs()
              })
          }
          .width('100%')
          .margin({ bottom: 12 })

          // 加载状态
          if (this.loading) {
            LoadingProgress()
              .width(24)
              .height(24)
              .color('#20A0FF')
          }

          // 药品列表
          List() {
            ForEach(this.drugList, (drug: Drug, index: number) => {
              ListItem() {
                Column() {
                  Text(drug.drug_name)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#333333')

                  Row() {
                    Text('规格: ' + drug.drug_format)
                    Text('厂家: ' + drug.manufacturer)
                  }
                  .fontSize(12)
                  .fontColor('#999999')
                  .margin({ top: 4 })

                  Row() {
                    Text('单价: ' + drug.drug_price)
                    Text('库存: ' + (drug.drug_stock ?? 0))
                  }
                  .fontSize(12)
                  .fontColor('#999999')
                  .margin({ top: 2 })
                }
                .width('100%')
                .padding(12)
              }
              .backgroundColor(Color.White)
              .borderRadius(4)
              .margin({ bottom: 4 })
              .onClick(() => {
                this.onSelect(drug)
              })
            })
          }
          .width('100%')
          .layoutWeight(1)

          // 取消按钮
          Button('取消')
            .fontSize(14)
            .fontColor('#666666')
            .backgroundColor('#f5f5f5')
            .borderRadius(4)
            .width('100%')
            .height(40)
            .margin({ top: 12 })
            .onClick(() => {
              this.onCancel()
            })
        }
        .width('85%')
        .maxHeight('75%')
        .padding(20)
        .backgroundColor(Color.White)
        .borderRadius(12)
      }
    }
    .width('100%')
    .height('100%')
  }
}
