/**
 * @file 分页条组件
 * 上一页/下一页 + 页码显示 + 每页条数选择
 */

import { PageInfo, PAGE_SIZES } from '../common/Constants'

@ComponentV2
export struct PaginationBar {
  @Param pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Event onChange: (page: number, size: number) => void = (page: number, size: number) => {}

  build() {
    Row() {
      // 每页条数选择
      Text('每页')
        .fontSize(13)
        .fontColor('#666666')

      // 简化的条数选择（固定列表）
      Text(this.pageInfo.size.toString())
        .fontSize(13)
        .fontColor('#20A0FF')
        .margin({ left: 4, right: 4 })

      Text('条')
        .fontSize(13)
        .fontColor('#666666')

      Blank()

      // 总数显示
      Text('共 ' + this.pageInfo.total.toString() + ' 条')
        .fontSize(13)
        .fontColor('#666666')
        .margin({ right: 16 })

      // 上一页
      Button('上一页')
        .fontSize(12)
        .fontColor(this.pageInfo.page <= 1 ? '#cccccc' : '#333333')
        .backgroundColor('#f5f5f5')
        .borderRadius(4)
        .height(28)
        .padding({ left: 12, right: 12 })
        .enabled(this.pageInfo.page > 1)
        .onClick(() => {
          if (this.pageInfo.page > 1) {
            this.onChange(this.pageInfo.page - 1, this.pageInfo.size)
          }
        })

      // 页码显示
      Text(this.pageInfo.page.toString() + '/' + this.getTotalPages().toString())
        .fontSize(13)
        .fontColor('#333333')
        .margin({ left: 8, right: 8 })

      // 下一页
      Button('下一页')
        .fontSize(12)
        .fontColor(this.pageInfo.page >= this.getTotalPages() ? '#cccccc' : '#333333')
        .backgroundColor('#f5f5f5')
        .borderRadius(4)
        .height(28)
        .padding({ left: 12, right: 12 })
        .enabled(this.pageInfo.page < this.getTotalPages())
        .onClick(() => {
          if (this.pageInfo.page < this.getTotalPages()) {
            this.onChange(this.pageInfo.page + 1, this.pageInfo.size)
          }
        })
    }
    .width('100%')
    .height(44)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
  }

  /**
   * 计算总页数
   * @returns 总页数
   */
  getTotalPages(): number {
    if (this.pageInfo.total <= 0) {
      return 1
    }
    return Math.ceil(this.pageInfo.total / this.pageInfo.size)
  }
}
