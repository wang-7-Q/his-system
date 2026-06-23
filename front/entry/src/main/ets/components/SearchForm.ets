export interface PickerOption {
  label: string
  value: string
}

export interface SearchField {
  key: string
  label: string
  type: 'text' | 'select' | 'date'
  placeholder?: string
  options?: PickerOption[]
}

@ComponentV2
export struct SearchForm {
  @Param fields: SearchField[] = []
  @Event onSearch: (values: Record<string, string>) => void = (_values: Record<string, string>) => {}
  @Event onReset: () => void = () => {}
  @Local formValues: Record<string, string> = {}

  aboutToAppear(): void {
    this.resetValues()
  }

  private resetValues(): void {
    const values: Record<string, string> = {}
    this.fields.forEach((f: SearchField) => values[f.key] = '')
    this.formValues = values
  }

  private buildSelectOptions(field: SearchField): PickerOption[] {
    if (!field.options) {
      return []
    }
    const result: PickerOption[] = []
    for (let i = 0; i < field.options.length; i++) {
      const opt: PickerOption = { value: field.options[i].value, label: field.options[i].label }
      result.push(opt)
    }
    return result
  }

  build() {
    Flex({ wrap: FlexWrap.Wrap }) {
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
            Select(this.buildSelectOptions(field))
              .width(160)
              .height(32)
              .onSelect((index: number) => {
                this.formValues[field.key] = field.options![index].value
              })
          } else if (field.type === 'date') {
            DatePicker()
              .width(160)
              .height(32)
              .onChange((value: DatePickerResult) => {
                const year: number = value.year || 2024
                const month: number = (value.month || 0) + 1
                const day: number = value.day || 1
                this.formValues[field.key] =
                  `${year}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`
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
        .onClick(() => this.onSearch(this.formValues))

      Button('重置')
        .fontSize(13)
        .backgroundColor('#F5F5F5')
        .fontColor('#606266')
        .height(32)
        .margin({ left: 8 })
        .onClick(() => {
          this.resetValues()
          this.onReset()
        })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .margin({ bottom: 12 })
  }
}
