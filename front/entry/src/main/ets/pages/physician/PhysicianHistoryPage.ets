import { HttpParams } from '../../services/ApiClient'
import { PageHeader } from '../../components/PageHeader'
import { PhysicianService } from '../../services/PhysicianService'
import { PageInfo, PaginationBar } from '../../components/PaginationBar'
import { ColumnConfig, DataTable } from '../../components/DataTable'
import { SearchField, SearchForm } from '../../components/SearchForm'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
struct PhysicianHistoryPage {
  @Local tableData: Object[] = []
  @Local loading: boolean = false
  @Local pageInfo: PageInfo = { page: 1, size: 10, total: 0 }
  @Local searchParams: Record<string, string> = {}

  private columns: ColumnConfig[] = [
    { key: 'case_number', title: '病历号', width: 100 },
    { key: 'patient_name', title: '患者姓名', width: 100 },
    { key: 'dept_name', title: '科室', width: 100 },
    { key: 'doctor_name', title: '医生', width: 80 },
    { key: 'status', title: '状态', width: 70 },
    { key: 'regist_date', title: '日期', width: 100 },
  ]

  private searchFields: SearchField[] = [
    { key: 'patient_name', label: '患者姓名', type: 'text', placeholder: '输入患者姓名' },
    { key: 'case_number', label: '病历号', type: 'text', placeholder: '输入病历号' },
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

      // Iterate over known search field keys to avoid Object.keys()
      for (let i = 0; i < this.searchFields.length; i++) {
        const key: string = this.searchFields[i].key
        const value: string | undefined = this.searchParams[key]
        if (value) {
          params.add(key, value)
        }
      }

      const result = await PhysicianService.getCheckedPatient(params)
      if (result.list) {
        this.tableData = result.list as Object[]
        this.pageInfo.total = result.totalCount
        this.pageInfo.page = page
      } else {
        this.tableData = []
        this.pageInfo.total = 0
      }
    } catch (_e) {
      promptAction.showToast({ message: '查询看诊记录失败', duration: 2000 })
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      PageHeader({ title: '看诊记录' })
      SearchForm({
        fields: this.searchFields,
        onSearch: (values: Record<string, string>) => {
          this.searchParams = values
          this.search(1)
        },
        onReset: () => {
          this.searchParams = {}
          this.search(1)
        }
      })
      DataTable({ columns: this.columns, data: this.tableData, loading: this.loading })
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

export default PhysicianHistoryPage
