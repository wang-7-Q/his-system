interface GeneratedTypeLiteralInterface_1 {
  label: string;
  value: string;
}

export interface FormField {
  key: string
  label: string
  type: 'text' | 'select' | 'date' | 'number'
  required?: boolean
  placeholder?: string
  options?: GeneratedTypeLiteralInterface_1[]
}

@ComponentV2
export struct FormDialog {
  @Param visible: boolean = false
  @Param title: string = '表单'
  @Param fields: FormField[] = []
  @Param loading: boolean = false
  @Event onSubmit: (values: Record<string, string>) => void = (_values: Record<string, string>) => {}
  @Event onCancel: () => void = () => {}
  @Local formValues: Record<string, string> = {}
  @Local errors: Record<string, string> = {}

  aboutToAppear(): void {
    this.initForm()
  }

  private buildSelectOptions(field: FormField): GeneratedTypeLiteralInterface_1[] {
    if (!field.options) {
      return []
    }
    const result: GeneratedTypeLiteralInterface_1[] = []
    for (let i = 0; i < field.options.length; i++) {
      const opt: GeneratedTypeLiteralInterface_1 = {
        value: field.options[i].value,
        label: field.options[i].label
      }
      result.push(opt)
    }
    return result
  }

  private initForm(): void {
    const values: Record<string, string> = {}
    const errs: Record<string, string> = {}
    this.fields.forEach(f => {
      values[f.key] = ''
      errs[f.key] = ''
    })
    this.formValues = values
    this.errors = errs
  }

  build() {
    if (this.visible) {
      Stack() {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(0,0,0,0.4)')
          .onClick(() => this.onCancel())

        Column() {
          Text(this.title)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 20 })

          Scroll() {
            Column() {
              ForEach(this.fields, (field: FormField) => {
                Column() {
                  Row() {
                    Text(field.label)
                      .fontSize(14)
                      .fontColor('#606266')
                      .width(80)
                    if (field.type === 'text' || field.type === 'number') {
                      TextInput({ placeholder: field.placeholder || '' })
                        .layoutWeight(1)
                        .height(36)
                        .fontSize(13)
                        .type(field.type === 'number' ? InputType.Number : InputType.Normal)
                        .onChange((value: string) => this.formValues[field.key] = value)
                    } else if (field.type === 'select' && field.options) {
                      Select(this.buildSelectOptions(field))
                        .layoutWeight(1)
                        .height(36)
                        .onSelect((index: number) => {
                          this.formValues[field.key] = field.options![index].value
                        })
                    } else if (field.type === 'date') {
                      DatePicker()
                        .layoutWeight(1)
                        .height(36)
                        .onChange((value: DatePickerResult) => {
                          const year: number = value.year || 2024
                          const month: number = (value.month || 0) + 1
                          const day: number = value.day || 1
                          this.formValues[field.key] =
                            `${year}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`
                        })
                    }
                  }
                  if (this.errors[field.key]) {
                    Text(this.errors[field.key])
                      .fontSize(11)
                      .fontColor('#F56C6C')
                      .margin({ top: 4, left: 80 })
                  }
                }
                .margin({ bottom: 12 })
              }, (field: FormField) => field.key)
            }
          }
          .layoutWeight(1)

          Row() {
            Button('取消')
              .backgroundColor('#F5F5F5')
              .fontColor('#606266')
              .layoutWeight(1)
              .onClick(() => this.onCancel())
            Blank().width(12)
            Button(this.loading ? '提交中...' : '确定')
              .backgroundColor('#409EFF')
              .fontColor('#FFFFFF')
              .layoutWeight(1)
              .enabled(!this.loading)
              .onClick(() => this.onSubmit(this.formValues))
          }
          .width('100%')
        }
        .width('90%')
        .height('80%')
        .padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
      }
      .width('100%')
      .height('100%')
    }
  }
}
