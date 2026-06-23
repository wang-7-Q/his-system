/**
 * @file 窗口退号页面
 * 对应 Vue 版 registration_record.vue
 * 功能：搜索患者 + 表格显示 + 退号操作
 */

import { promptAction } from '@kit.ArkUI'
import { getRecordRefundPatient, refundMedicalRecord } from '../../services/RegistrationService'
import { Registration } from '../../models/Registration'
import { PAGE_SIZE_DEFAULT } from '../../common/Constants'

@ComponentV2
export struct RegistrationRecordPage {
  @Local case_number: string = ''
  @Local real_name: string = ''
  @Local pageSize: number = PAGE_SIZE_DEFAULT
  @Local totalCount: number = 0
  @Local nowPage: number = 1
  @Local wait_patient: Registration[] = []

  aboutToAppear(): void {
    this.getWaitPatient(1)
  }

  /**
   * 获取可退号患者列表
   */
  async getWaitPatient(nowPageNumber: number): Promise<void> {
    this.nowPage = nowPageNumber
    try {
      const resp = await getRecordRefundPatient({
        case_number: this.case_number,
        real_name: this.real_name,
        nowPageNumber: nowPageNumber,
        pageSize: this.pageSize
      })
      this.wait_patient = resp.list
      this.totalCount = resp.totalCount
    } catch {
      this.wait_patient = []
      this.totalCount = 0
    }
  }

  /**
   * 退号
   */
  async handleRefund(index: number): Promise<void> {
    const patient: Registration = this.wait_patient[index]
    try {
      await refundMedicalRecord(patient.id)
      promptAction.showToast({ message: '退号患者: ' + patient.real_name, duration: 1500 })
      this.getWaitPatient(1)
    } catch {
      promptAction.showToast({ message: '退号失败', duration: 1500 })
    }
  }

  build() {
    NavDestination() {
      Column() {
        // 搜索栏
        Row() {
          TextInput({ placeholder: '请输入患者病历号' })
            .value(this.case_number)
            .onChange((val: string) => { this.case_number = val })
            .fontSize(13)
            .height(36)
            .constraintWidth({ min: 100, max: 200 })
            .margin({ right: 12 })

          TextInput({ placeholder: '请输入患者姓名' })
            .value(this.real_name)
            .onChange((val: string) => { this.real_name = val })
            .fontSize(13)
            .height(36)
            .constraintWidth({ min: 100, max: 200 })
            .margin({ right: 12 })

          Button('搜索')
            .fontSize(13)
            .fontColor(Color.White)
            .backgroundColor('#20A0FF')
            .borderRadius(4)
            .height(36)
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.getWaitPatient(1)
            })
        }
        .width('100%')
        .margin({ bottom: 16 })

        // 表格
        Scroll() {
          Column() {
            // 表头
            Row() {
              Text('编号').fontSize(13).fontWeight(FontWeight.Medium).width(60)
              Text('病历号').fontSize(13).fontWeight(FontWeight.Medium).layoutWeight(1)
              Text('姓名').fontSize(13).fontWeight(FontWeight.Medium).width(100)
              Text('性别').fontSize(13).fontWeight(FontWeight.Medium).width(60)
              Text('身份证号').fontSize(13).fontWeight(FontWeight.Medium).width(180)
              Text('付款方式').fontSize(13).fontWeight(FontWeight.Medium).width(100)
              Text('操作').fontSize(13).fontWeight(FontWeight.Medium).width(80)
            }
            .width('100%')
            .height(40)
            .backgroundColor('#fafafa')
            .padding({ left: 8 })

            // 数据行
            ForEach(this.wait_patient, (item: Registration, index: number) => {
              Row() {
                Text(this.createIndexStr(index + 1)).fontSize(13).fontColor('#666666').width(60)
                Text(item.case_number).fontSize(13).fontColor('#666666').layoutWeight(1)
                Text(item.real_name).fontSize(13).fontColor('#666666').width(100)
                Text(item.gender).fontSize(13).fontColor('#666666').width(60)
                Text(item.card_number).fontSize(13).fontColor('#666666').width(180)
                Text(item.regist_method).fontSize(13).fontColor('#666666').width(100)
                Button('退号')
                  .fontSize(12)
                  .fontColor('#ff4d4f')
                  .backgroundColor(Color.White)
                  .border({ width: 1, color: '#ff4d4f' })
                  .borderRadius(4)
                  .height(28)
                  .padding({ left: 8, right: 8 })
                  .onClick(() => {
                    this.handleRefund(index)
                  })
              }
              .width('100%')
              .height(40)
              .backgroundColor(index % 2 === 0 ? Color.White : '#fafafa')
              .padding({ left: 8 })
            })
          }
        }
        .layoutWeight(1)

        // 分页
        Row() {
          Text('共 ' + this.totalCount.toString() + ' 条')
            .fontSize(12)
            .fontColor('#999999')

          Blank()

          Button('上一页')
            .fontSize(12)
            .enabled(this.nowPage > 1)
            .onClick(() => {
              if (this.nowPage > 1) {
                this.getWaitPatient(this.nowPage - 1)
              }
            })

          Text(this.nowPage.toString())
            .fontSize(12)
            .fontColor('#333333')
            .margin({ left: 8, right: 8 })

          Button('下一页')
            .fontSize(12)
            .enabled(this.nowPage * this.pageSize < this.totalCount)
            .onClick(() => {
              this.getWaitPatient(this.nowPage + 1)
            })
        }
        .width('100%')
        .height(44)
        .backgroundColor(Color.White)
        .padding({ left: 16, right: 16 })
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor('#f5f5f5')
    }
    .title('窗口退号')
  }

  /**
   * 生成编号字符串
   */
  createIndexStr(val: number): string {
    return val.toString()
  }
}
