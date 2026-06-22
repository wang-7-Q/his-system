export interface PageInfo {
  page: number
  size: number
  total: number
}

@ComponentV2
export struct PaginationBar {
  @Param pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Param pageSizes: number[] = [5, 10, 20, 50]
  @Event onChange?: (page: number, size: number) => void

  @Computed
  get totalPages(): number {
    return Math.ceil(this.pageInfo.total / this.pageInfo.size)
  }

  build() {
    Row() {
      Text(`共 ${this.pageInfo.total} 条`)
        .fontSize(13)
        .fontColor('#909399')

      Blank()

      Button('<')
        .width(32)
        .height(32)
        .fontSize(13)
        .enabled(this.pageInfo.page > 1)
        .backgroundColor('#F5F5F5')
        .onClick(() => {
          if (this.pageInfo.page > 1) {
            this.onChange?.(this.pageInfo.page - 1, this.pageInfo.size)
          }
        })

      Text(`${this.pageInfo.page} / ${this.totalPages}`)
        .fontSize(13)
        .margin({ left: 8, right: 8 })

      Button('>')
        .width(32)
        .height(32)
        .fontSize(13)
        .enabled(this.pageInfo.page < this.totalPages)
        .backgroundColor('#F5F5F5')
        .onClick(() => {
          if (this.pageInfo.page < this.totalPages) {
            this.onChange?.(this.pageInfo.page + 1, this.pageInfo.size)
          }
        })

      Blank()

      Row() {
        Text('每页 ').fontSize(13).fontColor('#909399')
        Select([{ value: '5' }, { value: '10' }, { value: '20' }, { value: '50' }])
          .selected(String(this.pageInfo.size))
          .width(70)
          .height(32)
          .onSelect((index: number) => {
            const newSize: number = this.pageSizes[index]
            this.onChange?.(1, newSize)
          })
        Text(' 条').fontSize(13).fontColor('#909399')
      }
      .margin({ left: 16 })
    }
    .width('100%')
    .height(48)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .margin({ top: 12 })
  }
}
