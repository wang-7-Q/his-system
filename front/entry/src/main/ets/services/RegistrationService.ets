import { ApiClient, HttpParams } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { Registration, RegistLevel, Department, Doctor } from '../models/Registration'

export class RegistrationService {
  private static api: ApiClient = ApiClient.getInstance()

  static async addRegister(data: HttpParams): Promise<RestBean<void>> {
    return RegistrationService.api.post<void>(8092, '/addRegister', data)
  }

  static async refundMedicalRecord(registId: string): Promise<RestBean<void>> {
    const params: HttpParams = new HttpParams()
    params.add('registId', registId)
    return RegistrationService.api.get<void>(8092, '/refundMedicalRecord', params)
  }

  static async getRecordRefundPatient(): Promise<RestBean<Registration>> {
    return RegistrationService.api.get<Registration>(8092, '/getRecordRefundPatient')
  }

  static async getAlreadyRegisterCount(): Promise<RestBean<Registration>> {
    return RegistrationService.api.get<Registration>(8092, '/getAlreadyRegisterCount')
  }

  static async getRegistDoctorList(): Promise<RestBean<Doctor>> {
    return RegistrationService.api.get<Doctor>(8092, '/getRegistDoctorList')
  }

  static async getRegistLevelList(): Promise<RestBean<RegistLevel>> {
    return RegistrationService.api.get<RegistLevel>(8092, '/getRegistLevelList')
  }

  static async getAllDeptList(): Promise<RestBean<Department>> {
    return RegistrationService.api.get<Department>(8092, '/getAllDeptList')
  }

  static async getSettleCategory(): Promise<RestBean<Registration>> {
    return RegistrationService.api.get<Registration>(8092, '/getSettleCategory')
  }

  static async getMaxCaseNumber(): Promise<RestBean<Registration>> {
    return RegistrationService.api.get<Registration>(8092, '/getMaxCaseNumber')
  }

  static async expenseCharge(data: HttpParams): Promise<RestBean<void>> {
    return RegistrationService.api.post<void>(8092, '/expenseCharge', data)
  }

  static async expenseRefund(data: HttpParams): Promise<RestBean<void>> {
    return RegistrationService.api.post<void>(8092, '/expenseRefund', data)
  }

  static async searchExpenseChargePatient(): Promise<RestBean<Registration>> {
    return RegistrationService.api.get<Registration>(8092, '/searchExpenseChargePatient')
  }

  static async searchExpenseRefundPatient(): Promise<RestBean<Registration>> {
    return RegistrationService.api.get<Registration>(8092, '/searchExpenseRefundPatient')
  }

  static async searchAllPricePatient(params?: HttpParams): Promise<RestBean<Registration>> {
    return RegistrationService.api.get<Registration>(8092, '/searchAllPricePatient', params)
  }
}
