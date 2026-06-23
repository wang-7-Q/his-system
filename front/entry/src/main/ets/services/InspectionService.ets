import { ApiClient, HttpParams } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { InspectionItem } from '../models/InspectionItem'

export class InspectionService {
  private static api: ApiClient = ApiClient.getInstance()

  static async getWaitInspectionCount(): Promise<RestBean<InspectionItem>> {
    return InspectionService.api.get<InspectionItem>(8092, '/getWaitInspectionCount')
  }

  static async getFinishInspectionCount(): Promise<RestBean<InspectionItem>> {
    return InspectionService.api.get<InspectionItem>(8092, '/getFinishInspectionCount')
  }

  static async getWaitInspection(): Promise<RestBean<InspectionItem>> {
    return InspectionService.api.get<InspectionItem>(8092, '/getWaitInspection')
  }

  static async getInspectionPatient(): Promise<RestBean<InspectionItem>> {
    return InspectionService.api.get<InspectionItem>(8092, '/getInspectionPatient')
  }

  static async getInspectionPatientDept(): Promise<RestBean<InspectionItem>> {
    return InspectionService.api.get<InspectionItem>(8092, '/getInspectionPatientDept')
  }

  static async getInspectionPatientEmp(): Promise<RestBean<InspectionItem>> {
    return InspectionService.api.get<InspectionItem>(8092, '/getInspectionPatientEmp')
  }

  static async updateInspectionPatient(data: HttpParams): Promise<RestBean<void>> {
    return InspectionService.api.post<void>(8092, '/updateInspectionPatient', data)
  }

  static async getPatientItemByInspection(registId: string): Promise<RestBean<InspectionItem>> {
    const params: HttpParams = new HttpParams()
    params.add('registId', registId)
    return InspectionService.api.get<InspectionItem>(8092, '/getPatientItemByInspection', params)
  }
}
