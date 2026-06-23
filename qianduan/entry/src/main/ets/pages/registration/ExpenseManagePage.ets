/**
 * @file 费用记录查询页面
 * 对应 Vue 版 expense_manage.vue
 * 功能：搜索患者 -> 确认信息 -> 查看费用明细（只读）
 */

import { promptAction } from '@kit.ArkUI'
import { searchAllPricePatient } from '../../services/RegistrationService'
import { ExpenseItem, RestBeanMap } from '../../models/RestBean'

@ComponentV2
export struct ExpenseManagePage {
  @Local case_number: string = ''
  @Local real_name: string = ''

  // 患者信息
  @Local patientName: string = ''
  @Local patientCard: string = ''
  @Local patientAge: string = ''
  @Local patientGender: string = ''

  // 费用项目列表
  @Local price_project_table: ExpenseItem[] = []
  @Local total_price: string = '0.00'

  /**
   * 搜索患者
   */
  async searchPatient(): Promise<void> {
    try {
      const resp: RestBeanMap = await searchAllPricePatient({
        case_number: this.case_number,
        real_name: this.real_name
      })
      if (resp.registMap == null) {
        promptAction.showToast({ message: '用户不存在，请使用默认病历号 1000009 查询', duration: 2000 })
        this.clearPatientInfo()
        return
      }
      const reg: Record<string, Object> = resp.registMap as Record<string, Object>
      this.patientName = String(reg['real_name'] ?? '')
      this.patientCard = String(reg['card_number'] ?? '')
      this.patientAge = String(reg['age'] ?? '')
      this.patientGender = String(reg['gender'] ?? '')
      this.price_project_table = resp.requestList ?? []
      this.mathTotalPrice(this.price_project_table)
    } catch {
      promptAction.showToast({ message: '查询失败', duration: 1500 })
    }
  }

  /**
   * 清除患者信息
   */
  clearPatientInfo(): void {
    this.patientName = ''
    this.patientCard = ''
    this.patientAge = ''
    this.patientGender = ''
    this.price_project_table = []
    this.total_price = '0.00'
  }

  /**
   * 计算总金额（排除已退费项目）
   */
  mathTotalPrice(items: ExpenseItem[]): void {
    let total: number = 0
    for (const item of items) {
      if (item.item_state === '已退费') {
        continue
      }
      const price: number = parseFloat(item.item_price) || 0
      const num: number = parseInt(item.item_number) || 1
      total = total + price * num
    }
    this.total_price = total.toFixed(2)
  }

  build() {
    NavDestination() {
      Column() {
        // 查询部分
        Text('患者信息查询')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .margin({ bottom: 12 })

        Row() {
          TextInput({ placeholder: '请输入病历号' })
            .value(this.case_number)
            .onChange((val: string) => { this.case_number = val })
            .fontSize(13)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 12 })

          TextInput({ placeholder: '请输入患者名' })
            .value(this.real_name)
            .onChange((val: string) => { this.real_name = val })
            .fontSize(13)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 12 })

          Button('搜索')
            .fontSize(13)
            .fontColor(Color.White)
            .backgroundColor('#20A0FF')
            .borderRadius(4)
            .height(36)
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.searchPatient()
            })
        }
        .width('100%')
        .margin({ bottom: 16 })

        // 患者信息确认
        Text('患者信息确认')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .margin({ bottom: 12 })

        Row() {
          Column() {
            Text('患者名：').fontSize(12).fontColor('#666666')
            TextInput({}).value(this.patientName).fontSize(13).height(36).width('90%').enabled(false)
          }
          .layoutWeight(1)
          Column() {
            Text('身份证号：').fontSize(12).fontColor('#666666')
            TextInput({}).value(this.patientCard).fontSize(13).height(36).width('90%').enabled(false)
          }
          .layoutWeight(1)
          Column() {
            Text('年龄：').fontSize(12).fontColor('#666666')
            TextInput({}).value(this.patientAge).fontSize(13).height(36).width('90%').enabled(false)
          }
          .layoutWeight(1)
          Column() {
            Text('性别：').fontSize(12).fontColor('#666666')
            TextInput({}).value(this.patientGender).fontSize(13).height(36).width('90%').enabled(false)
          }
          .layoutWeight(1)
        }
        .width('100%')
        .margin({ bottom: 16 })

        // 总金额
        Row() {
          Text('项目金额: ' + this.total_price + '元')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
        }
        .width('100%')
        .margin({ bottom: 12 })

        // 费用明细表格
        Scroll() {
          Column() {
            Row() {
              Text('项目名称').fontSize(12).fontWeight(FontWeight.Medium).layoutWeight(1)
              Text('单价').fontSize(12).fontWeight(FontWeight.Medium).width(80)
              Text('类型').fontSize(12).fontWeight(FontWeight.Medium).width(80)
              Text('规格').fontSize(12).fontWeight(FontWeight.Medium).width(120)
              Text('数量').fontSize(12).fontWeight(FontWeight.Medium).width(60)
              Text('开立时间').fontSize(12).fontWeight(FontWeight.Medium).width(160)
              Text('状态').fontSize(12).fontWeight(FontWeight.Medium).width(80)
            }
            .width('100%')
            .height(36)
            .backgroundColor('#fafafa')

            ForEach(this.price_project_table, (item: ExpenseItem, index: number) => {
              Row() {
                Text(item.item_name).fontSize(12).fontColor('#333333').layoutWeight(1).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(item.item_price).fontSize(12).fontColor('#333333').width(80)
                Text(item.item_type).fontSize(12).fontColor('#333333').width(80)
                Text(item.item_format).fontSize(12).fontColor('#333333').width(120).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(item.item_number).fontSize(12).fontColor('#333333').width(60)
                Text(item.item_create_time).fontSize(12).fontColor('#333333').width(160).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(item.item_state).fontSize(12).fontColor(item.item_state === '已退费' ? '#ff4d4f' : '#52c41a').width(80)
              }
              .width('100%')
              .height(36)
              .backgroundColor(index % 2 === 0 ? Color.White : '#fafafa')
            })
          }
        }
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor('#f5f5f5')
    }
    .title('费用记录查询')
  }
}
