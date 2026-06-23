import { HttpParams } from '../../services/ApiClient'
import { DrugstoreService } from '../../services/DrugstoreService'
import { PageHeader } from '../../components/PageHeader'
import { PageInfo, PaginationBar } from '../../components/PaginationBar'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { SearchField, SearchForm } from '../../components/SearchForm'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct TranHistoryPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }

  private columns: ColumnConfig[] = [
    { key: 'patient_name', title: '患者姓名', width: 100 },
    { key: 'drug_name', title: '药品名称', width: 130 },
    { key: 'quantity', title: '数量', width: 60 },
    { key: 'price', title: '金额', width: 70 },
    { key: 'status', title: '状态', width: 70 },
    { key: 'date', title: '日期', width: 100 },
  ]

  private searchFields: SearchField[] = [
    { key: 'keyword', label: '关键词', type: 'text', placeholder: '患者姓名/病历号' },
  ]

  aboutToAppear(): void { this.search() }

  private async search(page: number = 1): Promise<void> {
    this.loading = true
    try {
      const params: HttpParams = new HttpParams()
      params.add('nowPageNumber', page.toString())
      params.add('pageSize', this.pageInfo.size.toString())
      const result = await DrugstoreService.getFinishPricePatient(params)
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount; this.pageInfo.page = page
      }
    } catch (_e) { promptAction.showToast({ message: '查询交易记录失败', duration: 2000 }) }
    finally { this.loading = false }
  }

  build() {
    Column() {
      PageHeader({ title: '交易记录' })
      SearchForm({ fields: this.searchFields, onSearch: () => this.search(1), onReset: () => this.search(1) })
      DataTable({ columns: this.columns, data: this.tableData, loading: this.loading })
      PaginationBar({ pageInfo: this.pageInfo, onChange: (p: number, s: number) => { this.pageInfo.size = s; this.search(p) } })
    }
    .width('100%').height('100%').padding(16).backgroundColor('#F0F2F5')
  }
}

export default TranHistoryPage
