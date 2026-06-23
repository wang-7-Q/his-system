import { ApiClient, HttpParams } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { DisposalItem } from '../models/DisposalItem'

export class DisposalService {
  private static api: ApiClient = ApiClient.getInstance()

  static async getWaitDisposalCount(): Promise<RestBean<DisposalItem>> {
    return DisposalService.api.get<DisposalItem>(8092, '/getWaitDisposalCount')
  }

  static async getFinishDisposalCount(): Promise<RestBean<DisposalItem>> {
    return DisposalService.api.get<DisposalItem>(8092, '/getFinishDisposalCount')
  }

  static async getWaitDisposal(): Promise<RestBean<DisposalItem>> {
    return DisposalService.api.get<DisposalItem>(8092, '/getWaitDisposal')
  }

  static async getFinishDisposal(params: HttpParams): Promise<RestBean<DisposalItem>> {
    return DisposalService.api.post<DisposalItem>(8092, '/getFinishDisposal', params)
  }

  static async getFinishDisposalByRegistid(registId: string): Promise<RestBean<DisposalItem>> {
    const params: HttpParams = new HttpParams()
    params.add('registId', registId)
    return DisposalService.api.get<DisposalItem>(8092, '/getFinishDisposalByRegistid', params)
  }

  static async getDisposalPatientEmp(): Promise<RestBean<DisposalItem>> {
    return DisposalService.api.get<DisposalItem>(8092, '/getDisposalPatientEmp')
  }

  static async getDisposalPatientDept(): Promise<RestBean<DisposalItem>> {
    return DisposalService.api.get<DisposalItem>(8092, '/getDisposalPatientDept')
  }

  static async updateDisposalInput(data: HttpParams): Promise<RestBean<void>> {
    return DisposalService.api.post<void>(8092, '/updateDisposalInput', data)
  }

  static async getPatientItemByDisposal(registId: string): Promise<RestBean<DisposalItem>> {
    const params: HttpParams = new HttpParams()
    params.add('registId', registId)
    return DisposalService.api.get<DisposalItem>(8092, '/getPatientItemByDisposal', params)
  }

  static async updateDisposalPatient(data: HttpParams): Promise<RestBean<void>> {
    return DisposalService.api.post<void>(8092, '/updateDisposalPatient', data)
  }

  static async getDisposalPatient(): Promise<RestBean<DisposalItem>> {
    return DisposalService.api.get<DisposalItem>(8092, '/getDisposalPatient')
  }
}
