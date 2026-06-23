import { EmptyState } from './EmptyState'

export interface ColumnConfig {
  key: string
  title: string
  width?: number
  flex?: number
  /**
   * Optional formatter function for type-safe cell value extraction.
   * When provided, the DataTable uses this instead of Record-based key lookup.
   * Example: formatter: (row: Object) => String((row as Record<string, Object>)['realname'] || '')
   */
  formatter?: (row: Object) => string
}

/**
 * Safely extract a string value from an Object by property name.
 * Uses Object.keys/values to comply with ArkTS indexed-access restrictions.
 */
function getFieldValue(obj: Object, key: string): string {
  const keys: string[] = Object.keys(obj)
  const values: Object[] = Object.values(obj)
  for (let i = 0; i < keys.length; i++) {
    if (keys[i] === key) {
      const val: Object = values[i]
      if (val !== undefined && val !== null) {
        return String(val)
      }
      break
    }
  }
  return ''
}

@ComponentV2
export struct DataTable {
  @Param columns: ColumnConfig[] = []
  @Param data: Object[] = []
  @Param loading: boolean = false
  @Param rowKey: string = 'id'
  @Param showIndex: boolean = true
  @Param showActionColumn: boolean = false
  @Event onRowClick: (row: Object) => void = (_row: Object) => {}
  @BuilderParam actionColumn: (row: Object) => void = this.defaultActionColumn

  @Builder
  defaultActionColumn(row: Object) {
  }

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
        ForEach(this.columns, (col: ColumnConfig) => {
          Text(col.title)
            .width(col.width)
            .layoutWeight(col.flex ? 0 : 1)
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#303133')
            .padding({ left: 8, right: 8 })
        }, (col: ColumnConfig) => col.key)
        if (this.showActionColumn) {
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
          ForEach(this.data, (row: Object, index: number) => {
            ListItem() {
              Row() {
                if (this.showIndex) {
                  Text(`${index + 1}`)
                    .width(48)
                    .fontSize(13)
                    .fontColor('#606266')
                    .textAlign(TextAlign.Center)
                }
                ForEach(this.columns, (col: ColumnConfig) => {
                  Text(this.getCellValue(row, col))
                    .width(col.width)
                    .layoutWeight(col.flex ? 0 : 1)
                    .fontSize(13)
                    .fontColor('#606266')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .padding({ left: 8, right: 8 })
                }, (col: ColumnConfig) => col.key)
                if (this.showActionColumn) {
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
              .onClick(() => this.onRowClick(row))
            }
          }, (row: Object, index: number) => `${index}`)
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
   * Falls back to Record-based key lookup for backward compatibility.
   */
  private getCellValue(row: Object, col: ColumnConfig): string {
    if (col.formatter) {
      return col.formatter(row)
    }
    return getFieldValue(row, col.key)
  }
}
