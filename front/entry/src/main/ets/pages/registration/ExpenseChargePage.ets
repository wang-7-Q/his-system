/**
 * @file 收费页面
 * 功能：搜索患者 → 显示待收费项目明细（多选）→ 合计收费结算
 */
import { PageHeader } from '../../components/PageHeader'
import { RegistrationService } from '../../services/RegistrationService'
import { RestBeanMap, ExpenseItem } from '../../models/RestBean'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct ExpenseChargePage {
  // ---- 搜索 ----
  @Local caseNumber: string = ''
  @Local realName: string = ''

  // ---- 患者信息 ----
  @Local patientName: string = ''
  @Local patientCard: string = ''
  @Local patientAge: string = ''
  @Local patientGender: string = ''

  // ---- 项目列表 ----
  @Local items: ExpenseItem[] = []
  @Local selectedIds: Set<number> = new Set<number>()
  @Local totalPrice: string = '0.00'
  @Local loading: boolean = false

  // ==================== 搜索 ====================

  private async searchPatient(): Promise<void> {
    if (!this.caseNumber && !this.realName) {
      promptAction.showToast({ message: '请输入病历号或患者姓名', duration: 2000 })
      return
    }
    this.loading = true
    try {
      const resp: RestBeanMap = await RegistrationService.searchExpenseChargePatient(
        this.caseNumber, this.realName
      )
      if (resp.registMap == null) {
        promptAction.showToast({ message: '未找到患者信息', duration: 2000 })
        this.clearPatientInfo()
        return
      }
      const reg: Record<string, Object> = resp.registMap as Record<string, Object>
      const keys: string[] = Object.keys(reg)
      const values: Object[] = Object.values(reg)
      for (let i = 0; i < keys.length; i++) {
        const k: string = keys[i]
        const v: string = String(values[i] || '')
        if (k === 'real_name') { this.patientName = v }
        else if (k === 'card_number') { this.patientCard = v }
        else if (k === 'age') { this.patientAge = v }
        else if (k === 'gender') { this.patientGender = v }
      }
      this.items = resp.requestList || []
      this.selectedIds = new Set<number>()
      this.calcTotal()
    } catch (_e) {
      promptAction.showToast({ message: '查询失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  private clearPatientInfo(): void {
    this.patientName = ''
    this.patientCard = ''
    this.patientAge = ''
    this.patientGender = ''
    this.items = []
    this.selectedIds = new Set<number>()
    this.totalPrice = '0.00'
  }

  // ==================== 选择逻辑 ====================

  private toggleItem(itemId: number): void {
    if (this.selectedIds.has(itemId)) {
      this.selectedIds.delete(itemId)
    } else {
      this.selectedIds.add(itemId)
    }
    this.calcTotal()
  }

  private isSelected(itemId: number): boolean {
    return this.selectedIds.has(itemId)
  }

  private calcTotal(): void {
    let total: number = 0
    for (let i = 0; i < this.items.length; i++) {
      if (this.selectedIds.has(this.items[i].id)) {
        const price: number = parseFloat(this.items[i].item_price) || 0
        const num: number = parseInt(this.items[i].item_number) || 1
        total = total + price * num
      }
    }
    this.totalPrice = total.toFixed(2)
  }

  // ==================== 收费 ====================

  private async doCharge(): Promise<void> {
    if (this.selectedIds.size === 0) {
      promptAction.showToast({ message: '请选择要收费的项目', duration: 2000 })
      return
    }
    const selectedList: Object[] = []
    for (let i = 0; i < this.items.length; i++) {
      if (this.selectedIds.has(this.items[i].id)) {
        selectedList.push(this.items[i] as Object)
      }
    }
    try {
      const jsonBody: string = JSON.stringify(selectedList)
      const result = await RegistrationService.expenseCharge(jsonBody)
      if (result.status === 1) {
        promptAction.showToast({
          message: '收费成功，合计 ¥' + this.totalPrice,
          duration: 2000
        })
        this.searchPatient()
      } else {
        promptAction.showToast({ message: result.msg || '收费失败', duration: 2000 })
      }
    } catch (_e) {
      promptAction.showToast({ message: '收费失败', duration: 2000 })
    }
  }

  // ==================== Builder ====================

  @Builder
  patientInfoBar() {
    if (this.patientName) {
      Row() {
        Text('患者信息确认')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#303133')
          .margin({ right: 16 })
        Text('姓名: ' + this.patientName)
          .fontSize(13).fontColor('#606266').margin({ right: 8 })
        Text('身份证: ' + this.patientCard)
          .fontSize(13).fontColor('#606266').margin({ right: 8 })
        Text('年龄: ' + this.patientAge)
          .fontSize(13).fontColor('#606266').margin({ right: 8 })
        Text('性别: ' + this.patientGender)
          .fontSize(13).fontColor('#606266')
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(8)
      .margin({ bottom: 12 })
    }
  }

  @Builder
  itemHeader() {
    Row() {
      Text('选择').fontSize(12).fontWeight(FontWeight.Medium).width(50)
      Text('项目名称').fontSize(12).fontWeight(FontWeight.Medium).layoutWeight(1)
      Text('单价').fontSize(12).fontWeight(FontWeight.Medium).width(70)
      Text('类型').fontSize(12).fontWeight(FontWeight.Medium).width(60)
      Text('规格').fontSize(12).fontWeight(FontWeight.Medium).width(100)
      Text('数量').fontSize(12).fontWeight(FontWeight.Medium).width(50)
      Text('开立时间').fontSize(12).fontWeight(FontWeight.Medium).width(140)
    }
    .width('100%')
    .height(36)
    .backgroundColor('#F5F7FA')
    .borderRadius({ topLeft: 8, topRight: 8 })
    .padding({ left: 8, right: 8 })
  }

  @Builder
  itemRow(item: ExpenseItem, index: number) {
    Row() {
      Button(this.isSelected(item.id) ? '☑' : '☐')
        .fontSize(14)
        .fontColor(this.isSelected(item.id) ? '#409EFF' : '#909399')
        .backgroundColor(Color.Transparent)
        .width(50)
        .height(32)
        .onClick(() => { this.toggleItem(item.id) })
      Text(item.item_name)
        .fontSize(12).fontColor('#303133')
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(item.item_price)
        .fontSize(12).fontColor('#303133').width(70)
      Text(item.item_type)
        .fontSize(12).fontColor('#303133').width(60)
      Text(item.item_format)
        .fontSize(12).fontColor('#303133').width(100)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(item.item_number)
        .fontSize(12).fontColor('#303133').width(50)
      Text(item.item_create_time)
        .fontSize(12).fontColor('#303133').width(140)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(36)
    .backgroundColor(index % 2 === 0 ? '#FFFFFF' : '#FAFAFA')
    .padding({ left: 8, right: 8 })
  }

  @Builder
  bottomBar() {
    Row() {
      Text('已选: ' + String(this.selectedIds.size) + ' 项')
        .fontSize(13)
        .fontColor('#606266')
      Blank()
      Text('合计: ¥' + this.totalPrice)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#E6A23C')
        .margin({ right: 16 })
      Button('收费结算')
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor('#67C23A')
        .borderRadius(4)
        .height(40)
        .padding({ left: 20, right: 20 })
        .onClick(() => this.doCharge())
    }
    .width('100%')
    .height(52)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .shadow({ radius: 4, color: '#00000010' })
  }

  // ==================== 主构建 ====================

  build() {
    Column() {
      Column() {
        PageHeader({ title: '收费' })

        // 搜索区
        Row() {
          TextInput({ placeholder: '请输入病历号' })
            .value(this.caseNumber)
            .onChange((v: string) => { this.caseNumber = v })
            .fontSize(13)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 12 })

          TextInput({ placeholder: '请输入患者名' })
            .value(this.realName)
            .onChange((v: string) => { this.realName = v })
            .fontSize(13)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 12 })

          Button('搜索')
            .fontSize(13)
            .fontColor('#FFFFFF')
            .backgroundColor('#409EFF')
            .borderRadius(4)
            .height(36)
            .padding({ left: 16, right: 16 })
            .onClick(() => this.searchPatient())
        }
        .width('100%')
        .margin({ bottom: 12 })

        // 患者信息
        this.patientInfoBar()

        // 项目表格
        if (this.loading) {
          LoadingProgress().width(40).height(40).margin({ top: 60 })
        } else if (this.items.length > 0) {
          Column() {
            this.itemHeader()
            Scroll() {
              Column() {
                ForEach(this.items, (item: ExpenseItem, index: number) => {
                  this.itemRow(item, index)
                }, (item: ExpenseItem) => String(item.id))
              }
            }
            .layoutWeight(1)
          }
          .layoutWeight(1)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
        }
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor('#F0F2F5')
    }
    .width('100%')
    .height('100%')

    // 底部操作栏
    this.bottomBar()
  }
}

export default ExpenseChargePage
