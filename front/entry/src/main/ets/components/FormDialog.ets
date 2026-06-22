export interface FormField {
  key: string
  label: string
  type: 'text' | 'select' | 'date' | 'number'
  required?: boolean
  placeholder?: string
  options?: { label: string, value: string }[]
}

@ComponentV2
export struct FormDialog {
  @Param visible: boolean = false
  @Param title: string = '表单'
  @Param fields: FormField[] = []
  @Param loading: boolean = false
  @Event onSubmit?: (values: Record<string, string>) => void
  @Event onCancel?: () => void
  @Local formValues: Record<string, string> = {}
  @Local errors: Record<string, string> = {}

  aboutToAppear(): void {
    this.initForm()
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
          .onClick(() => this.onCancel?.())

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
                      Select(field.options.map(o => ({ value: o.value, label: o.label })))
                        .layoutWeight(1)
                        .height(36)
                        .onSelect((index: number) => {
                          this.formValues[field.key] = field.options![index].value
                        })
                    } else if (field.type === 'date') {
                      DatePicker()
                        .layoutWeight(1)
                        .height(36)
                        .onChange((value: Date) => {
                          this.formValues[field.key] =
                            value.getFullYear() + '-' +
                            String(value.getMonth() + 1).padStart(2, '0') + '-' +
                            String(value.getDate()).padStart(2, '0')
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
              .onClick(() => this.onCancel?.())
            Blank().width(12)
            Button('确定')
              .backgroundColor('#409EFF')
              .fontColor('#FFFFFF')
              .layoutWeight(1)
              .loading(this.loading)
              .onClick(() => this.onSubmit?.({...this.formValues}))
          }
          .width('100%')
        }
        .width('90%')
        .maxHeight('80%')
        .padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
      }
      .width('100%')
      .height('100%')
    }
  }
}
