export interface SearchField {
  key: string
  label: string
  type: 'text' | 'select' | 'date'
  placeholder?: string
  options?: { label: string, value: string }[]
}

@ComponentV2
export struct SearchForm {
  @Param fields: SearchField[] = []
  @Event onSearch?: (values: Record<string, string>) => void
  @Event onReset?: () => void
  @Local formValues: Record<string, string> = {}

  aboutToAppear(): void {
    this.resetValues()
  }

  private resetValues(): void {
    const values: Record<string, string> = {}
    this.fields.forEach(f => values[f.key] = '')
    this.formValues = values
  }

  build() {
    Row() {
      ForEach(this.fields, (field: SearchField) => {
        Row() {
          Text(field.label)
            .fontSize(13)
            .fontColor('#606266')
            .margin({ right: 8 })
          if (field.type === 'text') {
            TextInput({ placeholder: field.placeholder || `请输入${field.label}` })
              .width(160)
              .height(32)
              .fontSize(13)
              .onChange((value: string) => this.formValues[field.key] = value)
          } else if (field.type === 'select' && field.options) {
            Select(field.options.map(o => ({ value: o.value, label: o.label })))
              .width(160)
              .height(32)
              .onSelect((index: number) => {
                this.formValues[field.key] = field.options![index].value
              })
          } else if (field.type === 'date') {
            DatePicker()
              .width(160)
              .height(32)
              .onChange((value: Date) => {
                this.formValues[field.key] =
                  `${value.getFullYear()}-${String(value.getMonth() + 1).padStart(2, '0')}-${String(value.getDate()).padStart(2, '0')}`
              })
          }
        }
        .margin({ right: 12 })
      }, (field: SearchField) => field.key)

      Button('搜索')
        .fontSize(13)
        .backgroundColor('#409EFF')
        .fontColor('#FFFFFF')
        .height(32)
        .onClick(() => this.onSearch?.({...this.formValues}))

      Button('重置')
        .fontSize(13)
        .backgroundColor('#F5F5F5')
        .fontColor('#606266')
        .height(32)
        .margin({ left: 8 })
        .onClick(() => {
          this.resetValues()
          this.onReset?.()
        })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .margin({ bottom: 12 })
    .flexWrap(FlexWrap.Wrap)
  }
}
