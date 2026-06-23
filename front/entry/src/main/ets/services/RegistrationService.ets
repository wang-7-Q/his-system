import { ApiClient, HttpParams } from './ApiClient'
import { RestBean, RestBeanMap } from '../models/RestBean'
import { Registration, RegistLevel, Department, Doctor, SettleCategory } from '../models/Registration'

const PORT: number = 8092

export class RegistrationService {
  private static api: ApiClient = ApiClient.getInstance()

  // ---- 挂号核心 ----

  /** 新增挂号 — 返回纯文本 "添加成功"/"添加失败" */
  static async addRegister(data: HttpParams): Promise<string> {
    return RegistrationService.api.postRaw(PORT, '/addRegister', data)
  }

  /** 退号 — 通过 id 退号 */
  static async refundMedicalRecord(registId: string): Promise<RestBean<void>> {
    const params: HttpParams = new HttpParams()
    params.add('id', registId)
    return RegistrationService.api.get<void>(PORT, '/refundMedicalRecord', params)
  }

  /** 查询可退号患者列表（状态=1 已挂号患者，分页） */
  static async getRecordRefundPatient(
    caseNumber?: string, realName?: string, page?: number, size?: number
  ): Promise<RestBean<Registration>> {
    const params: HttpParams = new HttpParams()
    if (caseNumber) { params.add('case_number', caseNumber) }
    if (realName) { params.add('real_name', realName) }
    if (page) { params.add('nowPageNumber', String(page)) }
    if (size) { params.add('pageSize', String(size)) }
    return RegistrationService.api.get<Registration>(PORT, '/getRecordRefundPatient', params)
  }

  /** 查询今日已挂号列表 */
  static async getAlreadyRegisterList(
    visitDate?: string, noon?: string, employeeId?: string
  ): Promise<RestBean<Registration>> {
    const params: HttpParams = new HttpParams()
    if (visitDate) { params.add('visitDate', visitDate) }
    if (noon) { params.add('noon', noon) }
    if (employeeId) { params.add('employeeId', employeeId) }
    return RegistrationService.api.get<Registration>(PORT, '/getAlreadyRegisterCount', params)
  }

  /** 查询医生已挂号数量（号额检查）— 返回纯文本数字 */
  static async getAlreadyRegisterCount(
    visitDate: string, noon: string, employeeId: string
  ): Promise<string> {
    const params: HttpParams = new HttpParams()
    params.add('visitDate', visitDate)
    params.add('noon', noon)
    params.add('employeeId', employeeId)
    return RegistrationService.api.getRaw(PORT, '/getAlreadyRegisterCount', params)
  }

  // ---- 下拉数据源 ----

  /** 挂号级别列表 */
  static async getRegistLevelList(): Promise<RestBean<RegistLevel>> {
    return RegistrationService.api.get<RegistLevel>(PORT, '/getRegistLevelList')
  }

  /** 科室列表 */
  static async getAllDeptList(): Promise<RestBean<Department>> {
    return RegistrationService.api.get<Department>(PORT, '/getAllDeptList')
  }

  /** 医生列表 — 按科室+号别过滤 */
  static async getRegistDoctorList(deptId?: string, levelId?: string): Promise<RestBean<Doctor>> {
    const params: HttpParams = new HttpParams()
    if (deptId) { params.add('deptmentId', deptId) }
    if (levelId) { params.add('registLevelId', levelId) }
    return RegistrationService.api.get<Doctor>(PORT, '/getRegistDoctorList', params)
  }

  /** 结算类别列表 */
  static async getSettleCategory(): Promise<RestBean<SettleCategory>> {
    return RegistrationService.api.get<SettleCategory>(PORT, '/getSettleCategory')
  }

  /** 获取最大病历号 — 返回纯文本数字字符串 */
  static async getMaxCaseNumber(): Promise<string> {
    return RegistrationService.api.getRaw(PORT, '/getMaxCaseNumber')
  }

  // ---- 收费/退费 ----

  /** 搜索待收费患者 — 返回原始 Map 格式 (registMap + requestList) */
  static async searchExpenseChargePatient(
    caseNumber?: string, realName?: string
  ): Promise<RestBeanMap> {
    const params: HttpParams = new HttpParams()
    if (caseNumber) { params.add('case_number', caseNumber) }
    if (realName) { params.add('real_name', realName) }
    const raw: string = await RegistrationService.api.getRaw(
      PORT, '/searchExpenseChargePatient', params
    )
    return JSON.parse(raw) as RestBeanMap
  }

  /** 收费结算 — POST JSON body: List<Map> */
  static async expenseCharge(jsonBody: string): Promise<RestBean<void>> {
    return RegistrationService.api.postJson<void>(PORT, '/expenseCharge', jsonBody)
  }

  /** 搜索待退费患者 */
  static async searchExpenseRefundPatient(
    caseNumber?: string, realName?: string
  ): Promise<RestBeanMap> {
    const params: HttpParams = new HttpParams()
    if (caseNumber) { params.add('case_number', caseNumber) }
    if (realName) { params.add('real_name', realName) }
    const raw: string = await RegistrationService.api.getRaw(
      PORT, '/searchExpenseRefundPatient', params
    )
    return JSON.parse(raw) as RestBeanMap
  }

  /** 退费结算 — POST JSON body: List<Map> */
  static async expenseRefund(jsonBody: string): Promise<RestBean<void>> {
    return RegistrationService.api.postJson<void>(PORT, '/expenseRefund', jsonBody)
  }

  /** 查询患者全部费用记录（分页） */
  static async searchAllPricePatient(params?: HttpParams): Promise<RestBean<Registration>> {
    return RegistrationService.api.get<Registration>(PORT, '/searchAllPricePatient', params)
  }
}
