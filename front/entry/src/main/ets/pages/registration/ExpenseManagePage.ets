import { HttpParams } from '../../services/ApiClient'
import { PageHeader } from '../../components/PageHeader'
import { RegistrationService } from '../../services/RegistrationService'
import { PageInfo, PaginationBar } from '../../components/PaginationBar'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { SearchField, SearchForm } from '../../components/SearchForm'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct ExpenseManagePage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Local searchKeyword: string = ''

  private columns: ColumnConfig[] = [
    { key: 'case_number', title: '病历号', width: 100 },
    { key: 'patient_name', title: '患者姓名', width: 100 },
    { key: 'item_name', title: '项目名称', width: 120 },
    { key: 'item_type', title: '项目类型', width: 80 },
    { key: 'price', title: '金额', width: 80 },
    { key: 'status', title: '状态', width: 70 },
    { key: 'charge_date', title: '日期', width: 100 },
  ]

  private searchFields: SearchField[] = [
    { key: 'keyword', label: '关键词', type: 'text', placeholder: '患者姓名/病历号' },
  ]

  aboutToAppear(): void {
    this.search()
  }

  private async search(page: number = 1): Promise<void> {
    this.loading = true
    try {
      const params: HttpParams = new HttpParams()
      params.add('nowPageNumber', page.toString())
      params.add('pageSize', this.pageInfo.size.toString())
      if (this.searchKeyword) {
        params.add('keyword', this.searchKeyword)
      }
      const result = await RegistrationService.searchAllPricePatient(params)
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount
        this.pageInfo.page = page
      } else {
        this.tableData = []
        this.pageInfo.total = 0
      }
    } catch (_e) {
      promptAction.showToast({ message: '查询费用记录失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      PageHeader({ title: '费用记录查询' })
      SearchForm({
        fields: this.searchFields,
        onSearch: (values: Record<string, string>) => {
          this.searchKeyword = values['keyword'] || ''
          this.search(1)
        },
        onReset: () => {
          this.searchKeyword = ''
          this.search(1)
        }
      })
      DataTable({
        columns: this.columns,
        data: this.tableData,
        loading: this.loading,
      })
      PaginationBar({
        pageInfo: this.pageInfo,
        onChange: (page: number, size: number) => {
          this.pageInfo.size = size
          this.search(page)
        }
      })
    }
    .width('100%').height('100%')
    .padding(16).backgroundColor('#F0F2F5')
  }
}

export default ExpenseManagePage
