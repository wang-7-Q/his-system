import { ApiClient, HttpParams } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { CheckItem } from '../models/CheckItem'

export class CheckService {
  private static api: ApiClient = ApiClient.getInstance()

  static async getWaitCheckCount(): Promise<RestBean<CheckItem>> {
    return CheckService.api.get<CheckItem>(8092, '/getWaitCheckCount')
  }

  static async getFinishCheckCount(): Promise<RestBean<CheckItem>> {
    return CheckService.api.get<CheckItem>(8092, '/getFinishCheckCount')
  }

  static async getWaitCheck(): Promise<RestBean<CheckItem>> {
    return CheckService.api.get<CheckItem>(8092, '/getWaitCheck')
  }

  static async getFinishCheck(params: HttpParams): Promise<RestBean<CheckItem>> {
    return CheckService.api.post<CheckItem>(8092, '/getFinishCheck', params)
  }

  static async getFinishCheckByRegistid(registId: string): Promise<RestBean<CheckItem>> {
    const params: HttpParams = new HttpParams()
    params.add('registId', registId)
    return CheckService.api.get<CheckItem>(8092, '/getFinishCheckByRegistid', params)
  }

  static async getCheckPatientEmp(): Promise<RestBean<CheckItem>> {
    return CheckService.api.get<CheckItem>(8092, '/getCheckPatientEmp')
  }

  static async getCheckPatientDept(): Promise<RestBean<CheckItem>> {
    return CheckService.api.get<CheckItem>(8092, '/getCheckPatientDept')
  }

  static async updateCheckInput(data: HttpParams): Promise<RestBean<void>> {
    return CheckService.api.post<void>(8092, '/updateCheckInput', data)
  }

  static async getPatientQuery(params: HttpParams): Promise<RestBean<CheckItem>> {
    return CheckService.api.post<CheckItem>(8092, '/getPatientQuery', params)
  }

  static async getPatientItemByCheck(registId: string): Promise<RestBean<CheckItem>> {
    const params: HttpParams = new HttpParams()
    params.add('registId', registId)
    return CheckService.api.get<CheckItem>(8092, '/getPatientItemByCheck', params)
  }

  static async updateCheckPatient(data: HttpParams): Promise<RestBean<void>> {
    return CheckService.api.post<void>(8092, '/updateCheckPatient', data)
  }

  static async getCheckPatient(): Promise<RestBean<CheckItem>> {
    return CheckService.api.get<CheckItem>(8092, '/getCheckPatient')
  }
}
