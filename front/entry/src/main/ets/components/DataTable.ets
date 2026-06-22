import { EmptyState } from './EmptyState'

export interface ColumnConfig<T> {
  key: string
  title: string
  width?: number
  flex?: number
  /**
   * Optional formatter function for type-safe cell value extraction.
   * When provided, the DataTable uses this instead of dynamic key access.
   * Example: formatter: (row: User) => row.realname
   */
  formatter?: (row: T) => string
}

/**
 * Safely extract a string value from an object by property name.
 * Uses Object.keys pattern working within ArkTS constraints.
 */
function getFieldValue(obj: Object, key: string): string {
  const keys: string[] = Object.keys(obj as Record<string, Object>)
  for (let i = 0; i < keys.length; i++) {
    if (keys[i] === key) {
      const val: Object | undefined = (obj as Record<string, Object>)[keys[i]]
      if (val !== undefined && val !== null) {
        return String(val)
      }
      return ''
    }
  }
  return ''
}

@ComponentV2
export struct DataTable<T extends Object> {
  @Param columns: ColumnConfig<T>[] = []
  @Param data: T[] = []
  @Param loading: boolean = false
  @Param rowKey: string = 'id'
  @Param showIndex: boolean = true
  @Event onRowClick?: (row: T) => void
  @BuilderParam actionColumn?: (row: T) => void

  build() {
    Column() {
      // Header row
      Row() {
        if (this.showIndex) {
          Text('#')
            .width(48)
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#303133')
            .textAlign(TextAlign.Center)
        }
        ForEach(this.columns, (col: ColumnConfig<T>) => {
          Text(col.title)
            .width(col.width)
            .layoutWeight(col.flex ? 0 : 1)
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#303133')
            .padding({ left: 8, right: 8 })
        }, (col: ColumnConfig<T>) => col.key)
        if (this.actionColumn) {
          Text('操作')
            .width(120)
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#303133')
            .textAlign(TextAlign.Center)
        }
      }
      .width('100%')
      .height(44)
      .backgroundColor('#F5F7FA')
      .borderRadius({ topLeft: 8, topRight: 8 })

      // Loading state
      if (this.loading) {
        LoadingProgress()
          .width(40).height(40)
          .margin({ top: 60, bottom: 60 })
      } else if (this.data.length === 0) {
        // Empty state
        EmptyState({ text: '暂无数据' })
      } else {
        // Data rows
        List() {
          ForEach(this.data, (row: T, index: number) => {
            ListItem() {
              Row() {
                if (this.showIndex) {
                  Text(`${index + 1}`)
                    .width(48)
                    .fontSize(13)
                    .fontColor('#606266')
                    .textAlign(TextAlign.Center)
                }
                ForEach(this.columns, (col: ColumnConfig<T>) => {
                  Text(this.getCellValue(row, col))
                    .width(col.width)
                    .layoutWeight(col.flex ? 0 : 1)
                    .fontSize(13)
                    .fontColor('#606266')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .padding({ left: 8, right: 8 })
                }, (col: ColumnConfig<T>) => col.key)
                if (this.actionColumn) {
                  Row() {
                    this.actionColumn(row)
                  }
                  .width(120)
                  .justifyContent(FlexAlign.Center)
                }
              }
              .width('100%')
              .height(48)
              .backgroundColor(index % 2 === 0 ? '#FFFFFF' : '#FAFAFA')
              .onClick(() => this.onRowClick?.(row))
            }
          }, (row: T, index: number) => `${index}`)
        }
        .layoutWeight(1)
        .divider({ strokeWidth: 1, color: '#EBEEF5' })
      }
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
  }

  /**
   * Get the display value for a cell.
   * Uses the column's formatter when provided (type-safe).
   * Falls back to safe key-based lookup for backward compatibility.
   */
  private getCellValue(row: T, col: ColumnConfig<T>): string {
    if (col.formatter) {
      return col.formatter(row)
    }
    return getFieldValue(row, col.key)
  }
}
