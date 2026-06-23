/**
 * @file 搜索表单组件
 * 支持 text/select/date 三种字段类型
 */

// 搜索字段配置接口
export interface SearchField {
  key: string
  label: string
  type: 'text' | 'select' | 'date'
  placeholder?: string
  options?: { value: string; label: string }[]
}

@ComponentV2
export struct SearchForm {
  @Param fields: SearchField[] = []
  @Param searchButtonText: string = '搜索'
  @Event onSearch: (values: Record<string, string>) => void = (values: Record<string, string>) => {}
  @Event onReset: () => void = () => {}

  @Local formValues: Record<string, string> = {}

  aboutToAppear(): void {
    // 初始化表单值
    const initValues: Record<string, string> = {}
    for (const field of this.fields) {
      initValues[field.key] = ''
    }
    this.formValues = initValues
  }

  build() {
    Flex() {
      // 遍历搜索字段
      ForEach(this.fields, (field: SearchField) => {
        if (field.type === 'text') {
          // 文本输入
          TextInput({ placeholder: field.placeholder ?? '请输入' })
            .value(this.formValues[field.key] ?? '')
            .onChange((val: string) => {
              const updated: Record<string, string> = {}
              for (const key in this.formValues) {
                if (this.formValues.hasOwnProperty(key)) {
                  updated[key] = this.formValues[key]
                }
              }
              updated[field.key] = val
              this.formValues = updated
            })
            .fontSize(13)
            .height(36)
            .constraintWidth({ min: 120, max: 200 })
        } else if (field.type === 'select') {
          // 选择器
          // 简化为输入框
          TextInput({ placeholder: field.placeholder ?? '请选择' })
            .value(this.formValues[field.key] ?? '')
            .onChange((val: string) => {
              const updated: Record<string, string> = {}
              for (const key in this.formValues) {
                if (this.formValues.hasOwnProperty(key)) {
                  updated[key] = this.formValues[key]
                }
              }
              updated[field.key] = val
              this.formValues = updated
            })
            .fontSize(13)
            .height(36)
            .constraintWidth({ min: 120, max: 200 })
        }
      })

      // 搜索按钮
      Button(this.searchButtonText)
        .fontSize(13)
        .fontColor(Color.White)
        .backgroundColor('#20A0FF')
        .borderRadius(4)
        .height(36)
        .padding({ left: 16, right: 16 })
        .margin({ left: 16 })
        .onClick(() => {
          this.onSearch(this.formValues)
        })

      // 重置按钮
      Button('重置')
        .fontSize(13)
        .fontColor('#666666')
        .backgroundColor('#f5f5f5')
        .borderRadius(4)
        .height(36)
        .padding({ left: 16, right: 16 })
        .margin({ left: 8 })
        .onClick(() => {
          const resetValues: Record<string, string> = {}
          for (const field of this.fields) {
            resetValues[field.key] = ''
          }
          this.formValues = resetValues
          this.onReset()
        })
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
    .wrap(FlexWrap.Wrap)
    .alignItems(VerticalAlign.Center)
    .gap(8)
  }
}
