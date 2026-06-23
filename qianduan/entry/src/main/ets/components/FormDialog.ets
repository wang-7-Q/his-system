/**
 * @file 表单对话框组件
 * 支持 text/select/date/number 四种字段类型，带校验
 */

// 表单字段配置接口
export interface FormField {
  key: string
  label: string
  type: 'text' | 'select' | 'date' | 'number'
  placeholder?: string
  required?: boolean
  options?: { value: string; label: string }[]
}

@ComponentV2
export struct FormDialog {
  @Param visible: boolean = false
  @Param title: string = ''
  @Param fields: FormField[] = []
  @Param loading: boolean = false
  @Param submitText: string = '提交'
  @Event onSubmit: (values: Record<string, string>) => void = (values: Record<string, string>) => {}
  @Event onCancel: () => void = () => {}

  @Local formValues: Record<string, string> = {}
  @Local errors: Record<string, string> = {}

  aboutToAppear(): void {
    this.resetForm()
  }

  /**
   * 重置表单
   */
  resetForm(): void {
    const initValues: Record<string, string> = {}
    const initErrors: Record<string, string> = {}
    for (const field of this.fields) {
      initValues[field.key] = ''
      initErrors[field.key] = ''
    }
    this.formValues = initValues
    this.errors = initErrors
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
            if (!this.loading) {
              this.onCancel()
            }
          })

        // 表单卡片
        Column() {
          // 标题
          Text(this.title)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
            .margin({ bottom: 16 })

          // 表单字段
          Column() {
            ForEach(this.fields, (field: FormField) => {
              Column() {
                // 标签
                Text(field.label + (field.required ? ' *' : ''))
                  .fontSize(13)
                  .fontColor('#333333')
                  .margin({ top: 8, bottom: 4 })

                if (field.type === 'select') {
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
                      // 清除错误
                      const errUpdated: Record<string, string> = {}
                      for (const key in this.errors) {
                        if (this.errors.hasOwnProperty(key)) {
                          errUpdated[key] = this.errors[key]
                        }
                      }
                      errUpdated[field.key] = ''
                      this.errors = errUpdated
                    })
                    .fontSize(13)
                    .height(36)
                    .width('100%')
                } else if (field.type === 'number') {
                  TextInput({ placeholder: field.placeholder ?? '请输入数字' })
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
                      const errUpdated2: Record<string, string> = {}
                      for (const key in this.errors) {
                        if (this.errors.hasOwnProperty(key)) {
                          errUpdated2[key] = this.errors[key]
                        }
                      }
                      errUpdated2[field.key] = ''
                      this.errors = errUpdated2
                    })
                    .fontSize(13)
                    .height(36)
                    .width('100%')
                    .type(InputType.Number)
                } else {
                  // text / date 使用普通输入
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
                      const errUpdated3: Record<string, string> = {}
                      for (const key in this.errors) {
                        if (this.errors.hasOwnProperty(key)) {
                          errUpdated3[key] = this.errors[key]
                        }
                      }
                      errUpdated3[field.key] = ''
                      this.errors = errUpdated3
                    })
                    .fontSize(13)
                    .height(36)
                    .width('100%')
                }

                // 错误提示
                if (this.errors[field.key] !== '') {
                  Text(this.errors[field.key])
                    .fontSize(11)
                    .fontColor('#ff4d4f')
                    .margin({ top: 2 })
                }
              }
              .width('100%')
              .margin({ bottom: 8 })
            })
          }
          .width('100%')
          .layoutWeight(1)
          .scrollable(ScrollDirection.Vertical)

          // 按钮区域
          Row() {
            Button('取消')
              .fontSize(14)
              .fontColor('#666666')
              .backgroundColor('#f5f5f5')
              .borderRadius(4)
              .width('45%')
              .height(40)
              .onClick(() => {
                this.resetForm()
                this.onCancel()
              })

            Button(this.submitText)
              .fontSize(14)
              .fontColor(Color.White)
              .backgroundColor('#20A0FF')
              .borderRadius(4)
              .width('45%')
              .height(40)
              .enabled(!this.loading)
              .onClick(() => {
                // 校验
                let hasError: boolean = false
                const newErrors: Record<string, string> = {}
                for (const field of this.fields) {
                  newErrors[field.key] = ''
                  if (field.required && (this.formValues[field.key] ?? '') === '') {
                    newErrors[field.key] = field.label + '不能为空'
                    hasError = true
                  }
                }
                this.errors = newErrors
                if (!hasError) {
                  this.onSubmit(this.formValues)
                }
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ top: 16 })
        }
        .width('80%')
        .maxHeight('70%')
        .padding(24)
        .backgroundColor(Color.White)
        .borderRadius(12)
      }
    }
    .width('100%')
    .height('100%')
  }
}
