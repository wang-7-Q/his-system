/**
 * @file 数据表格组件
 * 泛型表格，支持列配置、条纹行、加载状态、空数据状态
 */

import { EmptyState } from './EmptyState'

// 列配置接口
export interface ColumnConfig<T> {
  key: keyof T | 'index'
  title: string
  width?: number
  align?: 'left' | 'center' | 'right'
  render?: (row: T, index: number) => void
}

@ComponentV2
export struct DataTable<T extends Object> {
  @Param columns: ColumnConfig<T>[] = []
  @Param data: T[] = []
  @Param loading: boolean = false
  @Param rowKey: string = 'id'
  @Param showIndex: boolean = false
  @Event onRowClick: (row: T, index: number) => void = (row: T, index: number) => {}

  build() {
    Column() {
      if (this.loading) {
        // 加载中状态
        Column() {
          LoadingProgress()
            .width(32)
            .height(32)
            .color('#20A0FF')
          Text('加载中...')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 8 })
        }
        .width('100%')
        .height(200)
        .justifyContent(FlexAlign.Center)
      } else if (this.data.length === 0) {
        // 空数据状态
        EmptyState({ text: '暂无数据' })
      } else {
        // 数据表格
        Column() {
          // 表头
          this.renderHeader()

          // 数据行
          List() {
            ForEach(this.data, (item: T, index: number) => {
              ListItem() {
                this.renderRow(item, index)
              }
              .width('100%')
            }, (item: T, index: number) => {
              return String(item[this.rowKey as keyof T] ?? index)
            })
          }
          .width('100%')
          .divider({ strokeWidth: 0.5, color: '#f0f0f0' })
        }
        .border({ width: 1, color: '#f0f0f0' })
        .borderRadius(8)
      }
    }
    .width('100%')
    .padding({ left: 8, right: 8 })
  }

  /**
   * 渲染表头
   */
  @Builder
  renderHeader(): void {
    Row() {
      ForEach(this.columns, (col: ColumnConfig<T>) => {
        Row() {
          Text(col.title)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
        }
        .constraintWidth({ min: 60, max: col.width ?? 150 })
      }, (col: ColumnConfig<T>) => col.title)
    }
    .width('100%')
    .height(44)
    .backgroundColor('#fafafa')
    .padding({ left: 12, right: 12 })
  }

  /**
   * 渲染数据行
   * @param item - 行数据
   * @param index - 行索引
   */
  @Builder
  renderRow(item: T, index: number): void {
    Row() {
      ForEach(this.columns, (col: ColumnConfig<T>) => {
        Row() {
          if (col.key === 'index') {
            Text((index + 1).toString())
              .fontSize(13)
              .fontColor('#666666')
              .textAlign(TextAlign.Center)
          } else if (col.render != null) {
            col.render(item, index)
          } else {
            Text(String(item[col.key] ?? ''))
              .fontSize(13)
              .fontColor('#666666')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
        }
        .constraintWidth({ min: 60, max: col.width ?? 150 })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
      })
    }
    .width('100%')
    .height(40)
    .backgroundColor(index % 2 === 0 ? Color.White : '#fafafa')
    .padding({ left: 12, right: 12 })
    .onClick(() => {
      this.onRowClick(item, index)
    })
  }
}
