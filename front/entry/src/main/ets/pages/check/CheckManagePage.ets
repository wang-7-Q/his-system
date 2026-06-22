import { HttpParams } from '../../services/ApiClient'
import { CheckService } from '../../services/CheckService'
import { PageInfo } from '../../components/PaginationBar'
import { ColumnConfig } from '../../components/DataTable'
import { SearchField } from '../../components/SearchForm'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct CheckManagePage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }

  private columns: ColumnConfig<Object>[] = [
    { key: 'patient_name', title: '患者姓名', width: 100 },
    { key: 'item_name', title: '检查项目', width: 130 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'doctor_name', title: '医生', width: 80 },
    { key: 'result', title: '结果', width: 120 },
    { key: 'status', title: '状态', width: 70 },
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
      const result = await CheckService.getPatientQuery(params)
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount
        this.pageInfo.page = page
      }
    } catch (_e) {
      promptAction.showToast({ message: '查询失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      PageHeader({ title: '检查管理' })
      SearchForm({ fields: this.searchFields, onSearch: () => this.search(1), onReset: () => this.search(1) })
      DataTable({ columns: this.columns, data: this.tableData, loading: this.loading })
      PaginationBar({ pageInfo: this.pageInfo, onChange: (p: number, s: number) => { this.pageInfo.size = s; this.search(p) } })
    }
    .width('100%').height('100%')
    .padding(16).backgroundColor('#F0F2F5')
  }
}

export default CheckManagePage
