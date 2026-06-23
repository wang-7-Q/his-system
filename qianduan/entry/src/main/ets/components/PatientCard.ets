/**
 * @file 患者信息卡片组件
 * 蓝色边框卡片，显示患者基本信息
 */

import { Patient } from '../models/Patient'

@ComponentV2
export struct PatientCard {
  @Param patient: Patient | null = null

  build() {
    if (this.patient == null) {
      Column() {
        Text('请先搜索患者')
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .height(80)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#f9f9f9')
      .border({ width: 1, color: '#e8e8e8' })
      .borderRadius(8)
    } else {
      Column() {
        // 患者姓名
        Text((this.patient as Patient).real_name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .margin({ bottom: 8 })

        // 详细信息
        Row() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('病历号: ' + (this.patient as Patient).case_number)
              .fontSize(13)
              .fontColor('#666666')

            Text('性别: ' + (this.patient as Patient).gender)
              .fontSize(13)
              .fontColor('#666666')

            Text('年龄: ' + (this.patient as Patient).age)
              .fontSize(13)
              .fontColor('#666666')
          }
          .width('100%')
        }
        .margin({ bottom: 4 })

        Text('身份证: ' + (this.patient as Patient).card_number)
          .fontSize(13)
          .fontColor('#666666')
          .margin({ bottom: 4 })

        Text('电话: ' + (this.patient as Patient).phone)
          .fontSize(13)
          .fontColor('#666666')
          .margin({ bottom: 4 })

        Text('地址: ' + (this.patient as Patient).home_address)
          .fontSize(13)
          .fontColor('#666666')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#f0f8ff')
      .border({ width: 1, color: '#91d5ff' })
      .borderRadius(8)
    }
  }
}
