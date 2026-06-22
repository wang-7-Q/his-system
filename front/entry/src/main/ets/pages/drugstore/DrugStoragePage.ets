import { HttpParams } from '../../services/ApiClient'
import { DrugstoreService } from '../../services/DrugstoreService'
import { PageInfo } from '../../components/PaginationBar'
import { ColumnConfig } from '../../components/DataTable'
import { SearchField } from '../../components/SearchForm'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct DrugStoragePage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Local keyword: string = ''

  private columns: ColumnConfig<Object>[] = [
    { key: 'drug_code', title: '药品编码', width: 100 },
    { key: 'drug_name', title: '药品名称', width: 130 },
    { key: 'drug_format', title: '规格', width: 80 },
    { key: 'manufacturer', title: '生产厂家', width: 130 },
    { key: 'unit_price', title: '单价', width: 70 },
    { key: 'stock', title: '库存', width: 60 },
    { key: 'expiry_date', title: '有效期', width: 90 },
  ]

  private searchFields: SearchField[] = [
    { key: 'keyword', label: '药品名称', type: 'text', placeholder: '输入药品名称' },
  ]

  aboutToAppear(): void { this.search() }

  private async search(page: number = 1): Promise<void> {
    this.loading = true
    try {
      const params: HttpParams = new HttpParams()
      params.add('nowPageNumber', page.toString())
      params.add('pageSize', this.pageInfo.size.toString())
      if (this.keyword) {
        params.add('keyword', this.keyword)
      }
      const result = await DrugstoreService.getDrugInfo(params)
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount; this.pageInfo.page = page
      }
    } catch (_e) { promptAction.showToast({ message: '查询药品失败', duration: 2000 }) }
    finally { this.loading = false }
  }

  build() {
    Column() {
      PageHeader({ title: '药库管理' })
      SearchForm({
        fields: this.searchFields,
        onSearch: (v: Record<string, string>) => { this.keyword = v['keyword'] || ''; this.search(1) },
        onReset: () => { this.keyword = ''; this.search(1) }
      })
      DataTable({ columns: this.columns, data: this.tableData, loading: this.loading })
      PaginationBar({ pageInfo: this.pageInfo, onChange: (p: number, s: number) => { this.pageInfo.size = s; this.search(p) } })
    }
    .width('100%').height('100%').padding(16).backgroundColor('#F0F2F5')
  }
}

export default DrugStoragePage
