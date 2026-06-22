import { http } from '@kit.NetworkKit'
import { RestBean } from '../models/RestBean'
import { Constants } from '../common/Constants'

let requestCount: number = 0

function nextRequestId(): string {
  requestCount++
  return `REQ${requestCount}`
}

/**
 * ArkTS-compatible key-value builder that avoids object literal restrictions.
 * Use add() to append key-value pairs, then access via keys()/get().
 */
export class HttpParams {
  private keys: string[] = []
  private values: string[] = []

  add(key: string, value: string): void {
    this.keys.push(key)
    this.values.push(value)
  }

  size(): number {
    return this.keys.length
  }

  keyAt(index: number): string {
    return this.keys[index]
  }

  valueAt(index: number): string {
    return this.values[index]
  }
}

export class ApiClient {
  private static instance: ApiClient
  private authToken: string = ''

  static getInstance(): ApiClient {
    if (!ApiClient.instance) {
      ApiClient.instance = new ApiClient()
    }
    return ApiClient.instance
  }

  setAuthToken(token: string): void {
    this.authToken = token
  }

  clearAuthToken(): void {
    this.authToken = ''
  }

  private baseUrl(port: number): string {
    if (port === Constants.PORT_8091) {
      return Constants.BASE_URL_8091
    }
    return Constants.BASE_URL_8092
  }

  private buildQueryString(params: HttpParams): string {
    const parts: string[] = []
    for (let i = 0; i < params.size(); i++) {
      parts.push(`${encodeURIComponent(params.keyAt(i))}=${encodeURIComponent(params.valueAt(i))}`)
    }
    if (parts.length > 0) {
      return '?' + parts.join('&')
    }
    return ''
  }

  private toUrlEncoded(body: HttpParams): string {
    const parts: string[] = []
    for (let i = 0; i < body.size(); i++) {
      parts.push(`${encodeURIComponent(body.keyAt(i))}=${encodeURIComponent(body.valueAt(i))}`)
    }
    return parts.join('&')
  }

  private buildHeaders(): Object {
    const headers: Record<string, string> = {
      'Content-Type': 'application/x-www-form-urlencoded',
    }
    if (this.authToken) {
      headers['Authorization'] = `Bearer ${this.authToken}`
    }
    return headers as Object
  }

  private buildJsonHeaders(): Object {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
    }
    if (this.authToken) {
      headers['Authorization'] = `Bearer ${this.authToken}`
    }
    return headers as Object
  }

  private async makeRequest<T>(
    method: http.RequestMethod,
    url: string,
    headers: Object,
    extraData?: string | Object
  ): Promise<RestBean<T>> {
    const requestId: string = nextRequestId()
    const request: http.HttpRequest = http.createHttp()

    try {
      const response: http.HttpResponse = await request.request(url, {
        method: method,
        header: headers,
        extraData: extraData,
        expectDataType: http.HttpDataType.OBJECT,
        connectTimeout: Constants.REQUEST_TIMEOUT,
        readTimeout: Constants.REQUEST_TIMEOUT,
      })

      if (response.responseCode !== 200) {
        throw new Error(`HTTP ${response.responseCode}`)
      }

      const result: RestBean<T> = JSON.parse(response.result as string) as RestBean<T>
      return result
    } catch (err) {
      throw new Error('网络请求失败 (' + requestId + ')')
    } finally {
      request.destroy()
    }
  }

  async get<T>(port: number, path: string, params?: HttpParams): Promise<RestBean<T>> {
    const qs: string = params ? this.buildQueryString(params) : ''
    const url: string = `${this.baseUrl(port)}${path}${qs}`
    const headers: Object = this.buildHeaders()
    return this.makeRequest<T>(http.RequestMethod.GET, url, headers)
  }

  async post<T>(port: number, path: string, body?: HttpParams): Promise<RestBean<T>> {
    const url: string = `${this.baseUrl(port)}${path}`
    const headers: Object = this.buildHeaders()
    const extraData: string | undefined = body ? this.toUrlEncoded(body) : undefined
    return this.makeRequest<T>(http.RequestMethod.POST, url, headers, extraData)
  }

  async postJson<T>(port: number, path: string, jsonBody?: string): Promise<RestBean<T>> {
    const url: string = `${this.baseUrl(port)}${path}`
    const headers: Object = this.buildJsonHeaders()
    return this.makeRequest<T>(http.RequestMethod.POST, url, headers, jsonBody)
  }
}
