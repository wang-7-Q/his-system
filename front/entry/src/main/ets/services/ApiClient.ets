import { http } from '@kit.NetworkKit'
import { RestBean, createRestBean } from '../models/RestBean'
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
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: Constants.REQUEST_TIMEOUT,
        readTimeout: Constants.REQUEST_TIMEOUT,
      })

      if (response.responseCode !== 200) {
        throw new Error(`HTTP ${response.responseCode}`)
      }

      const bodyStr: string = response.result as string
      const parsed: Object = JSON.parse(bodyStr) as Object
      // 后端某些接口返回数组(如login)，需包装为RestBean格式
      if (parsed instanceof Array) {
        const arr: Object[] = parsed as Object[]
        return createRestBean(arr as T[], 'success', 1)
      }
      const result: RestBean<T> = parsed as RestBean<T>
      return result
    } catch (err) {
      // 尝试从 HarmonyOS http 错误对象中提取详细字段
      let errMsg: string = ''
      if (err instanceof Object) {
        const e: Record<string, Object> = err as Record<string, Object>
        const code: Object | undefined = e['code']
        const data: Object | undefined = e['data']
        if (code !== undefined) {
          errMsg = errMsg + ' code=' + String(code)
        }
        if (data !== undefined) {
          errMsg = errMsg + ' data=' + String(data)
        }
        if (errMsg === '') {
          errMsg = JSON.stringify(err)
        }
      } else {
        errMsg = String(err)
      }
      throw new Error('URL: ' + url + ' | ' + errMsg)
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

  /** 发起请求并返回原始响应字符串（不解析 JSON），用于 plain/text 端点 */
  private async makeRawRequest(
    method: http.RequestMethod, url: string, headers: Object, extraData?: string | Object
  ): Promise<string> {
    const request: http.HttpRequest = http.createHttp()
    try {
      const response: http.HttpResponse = await request.request(url, {
        method: method,
        header: headers,
        extraData: extraData,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: Constants.REQUEST_TIMEOUT,
        readTimeout: Constants.REQUEST_TIMEOUT,
      })
      if (response.responseCode !== 200) {
        throw new Error(`HTTP ${response.responseCode}`)
      }
      return response.result as string
    } finally {
      request.destroy()
    }
  }

  /** GET 请求，返回原始字符串（用于非 JSON 端点如 getMaxCaseNumber） */
  async getRaw(port: number, path: string, params?: HttpParams): Promise<string> {
    const qs: string = params ? this.buildQueryString(params) : ''
    const url: string = `${this.baseUrl(port)}${path}${qs}`
    const headers: Object = this.buildHeaders()
    return this.makeRawRequest(http.RequestMethod.GET, url, headers)
  }

  /** POST 请求，返回原始字符串（用于非 JSON 端点如 addRegister） */
  async postRaw(port: number, path: string, body?: HttpParams): Promise<string> {
    const url: string = `${this.baseUrl(port)}${path}`
    const headers: Object = this.buildHeaders()
    const extraData: string | undefined = body ? this.toUrlEncoded(body) : undefined
    return this.makeRawRequest(http.RequestMethod.POST, url, headers, extraData)
  }
}
